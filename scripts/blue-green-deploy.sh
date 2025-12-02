#!/bin/bash

# Script de Blue-Green Deployment
set -e

IMAGE=$1
BLUE_PORT=3000
GREEN_PORT=3001

if [ -z "$IMAGE" ]; then
    echo "❌ Error: Debes proporcionar la imagen Docker como argumento"
    echo "Uso: ./blue-green-deploy.sh <docker-image>"
    exit 1
fi

echo "🔵🟢 Iniciando Blue-Green Deployment..."
echo "Imagen: $IMAGE"

# Detectar cuál entorno está activo actualmente
ACTIVE_PORT=$(docker inspect evaluacion-nginx 2>/dev/null | grep -o "app:[0-9]*" | cut -d: -f2 || echo "3000")

if [ "$ACTIVE_PORT" == "$BLUE_PORT" ]; then
    INACTIVE_ENV="green"
    INACTIVE_PORT=$GREEN_PORT
    INACTIVE_CONTAINER="evaluacion-app-green"
    ACTIVE_ENV="blue"
    ACTIVE_CONTAINER="evaluacion-app"
else
    INACTIVE_ENV="blue"
    INACTIVE_PORT=$BLUE_PORT
    INACTIVE_CONTAINER="evaluacion-app"
    ACTIVE_ENV="green"
    ACTIVE_CONTAINER="evaluacion-app-green"
fi

echo "🎯 Entorno activo: $ACTIVE_ENV (puerto $ACTIVE_PORT)"
echo "🎯 Desplegando en: $INACTIVE_ENV (puerto $INACTIVE_PORT)"

# Detener y eliminar contenedor inactivo si existe
echo "🛑 Limpiando entorno $INACTIVE_ENV..."
docker stop $INACTIVE_CONTAINER 2>/dev/null || true
docker rm $INACTIVE_CONTAINER 2>/dev/null || true

# Iniciar nuevo contenedor en el entorno inactivo
echo "🚀 Iniciando nuevo contenedor en $INACTIVE_ENV..."
docker pull $IMAGE
docker run -d \
    --name $INACTIVE_CONTAINER \
    --network evaluacionu2u3_app-network \
    -p $INACTIVE_PORT:3000 \
    -e NODE_ENV=production \
    -e PORT=3000 \
    --restart unless-stopped \
    $IMAGE

# Esperar a que el nuevo contenedor esté listo
echo "⏳ Esperando a que $INACTIVE_ENV esté listo..."
sleep 5

for i in {1..30}; do
    if curl -f http://localhost:$INACTIVE_PORT/health > /dev/null 2>&1; then
        echo "✅ $INACTIVE_ENV está healthy!"
        break
    fi
    if [ $i -eq 30 ]; then
        echo "❌ Error: $INACTIVE_ENV no respondió al health check"
        docker logs $INACTIVE_CONTAINER
        exit 1
    fi
    echo "Intento $i/30: Esperando..."
    sleep 2
done

# Actualizar configuración de Nginx
echo "🔄 Actualizando configuración de Nginx..."
NGINX_CONF="./nginx/conf.d/default.conf"

# Backup de la configuración actual
cp $NGINX_CONF ${NGINX_CONF}.backup

# Crear nueva configuración apuntando al nuevo backend
if [ "$INACTIVE_ENV" == "green" ]; then
    NEW_BACKEND="app-green"
else
    NEW_BACKEND="app"
fi

cat > $NGINX_CONF <<EOF
upstream app_backend {
    server $INACTIVE_CONTAINER:3000;
}

server {
    listen 80;
    server_name _;

    location / {
        proxy_pass http://app_backend;
        proxy_http_version 1.1;
        proxy_set_header Upgrade \$http_upgrade;
        proxy_set_header Connection 'upgrade';
        proxy_set_header Host \$host;
        proxy_cache_bypass \$http_upgrade;
        proxy_set_header X-Real-IP \$remote_addr;
        proxy_set_header X-Forwarded-For \$proxy_add_x_forwarded_for;
        proxy_set_header X-Forwarded-Proto \$scheme;
    }

    location /health {
        proxy_pass http://app_backend/health;
        access_log off;
    }
}
EOF

# Recargar Nginx
echo "🔄 Recargando Nginx..."
docker exec evaluacion-nginx nginx -t && docker exec evaluacion-nginx nginx -s reload

# Verificar que Nginx está funcionando correctamente
echo "🔍 Verificando que el tráfico se redirigió correctamente..."
sleep 2
if curl -f http://localhost/health > /dev/null 2>&1; then
    echo "✅ Tráfico redirigido exitosamente a $INACTIVE_ENV!"
    
    # Detener el contenedor antiguo
    echo "🛑 Deteniendo contenedor antiguo ($ACTIVE_ENV)..."
    docker stop $ACTIVE_CONTAINER 2>/dev/null || true
    
    echo "🎉 Blue-Green Deployment completado exitosamente!"
    echo "✨ $INACTIVE_ENV es ahora el entorno activo"
else
    echo "❌ Error: El nuevo entorno no está respondiendo"
    echo "🔄 Revirtiendo cambios..."
    mv ${NGINX_CONF}.backup $NGINX_CONF
    docker exec evaluacion-nginx nginx -s reload
    docker stop $INACTIVE_CONTAINER
    exit 1
fi
