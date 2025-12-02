# Evaluación DevOps - Unidades 2 y 3

Proyecto de evaluación DevOps implementando pruebas de integración, containerización con Docker, proxy inverso con Nginx y estrategia de Blue-Green Deployment.

## 📋 Requisitos Implementados

### ✅ Nivel Satisfactorio (Base)

1. **Pruebas de Integración (Supertest)**
   - Suite completa de pruebas con Jest y Supertest
   - Más de 7 pruebas que validan todos los endpoints principales
   - Cobertura de código > 70%

2. **Contenerización (Docker)**
   - Dockerfile optimizado con Node.js Alpine
   - Docker Compose para orquestación
   - Health checks configurados
   - Integración con Docker Hub

3. **Servidor Web (Nginx)**
   - Nginx configurado como Proxy Inverso
   - Gestión de peticiones hacia la aplicación
   - Configuración optimizada con gzip y caching

### 🌟 Nivel Destacado (Intermedio)

4. **Estrategia Blue-Green Deployment**
   - Script automatizado para despliegue sin downtime
   - Dos entornos (Blue/Green) con switch automático de tráfico
   - Health checks antes del cambio
   - Rollback automático en caso de fallo
   - Zero Downtime garantizado mediante Nginx

## 🚀 Tecnologías Utilizadas

- **Backend**: Node.js + Express
- **Testing**: Jest + Supertest
- **Containerización**: Docker + Docker Compose
- **Proxy Inverso**: Nginx
- **CI/CD**: GitHub Actions
- **VPS**: Digital Ocean (o similar)

## 📦 Instalación Local

### 1. Clonar el repositorio

```bash
git clone https://github.com/Derck23/evaluacionU2U3.git
cd evaluacionU2U3
```

### 2. Instalar dependencias

```bash
npm install
```

### 3. Ejecutar tests

```bash
npm test
```

### 4. Ejecutar en desarrollo

```bash
npm run dev
```

### 5. Ejecutar en producción

```bash
npm start
```

## 🐳 Docker

### Construcción y ejecución con Docker Compose

```bash
# Construir e iniciar contenedores
docker-compose up -d

# Ver logs
docker-compose logs -f

# Detener contenedores
docker-compose down
```

Servicios disponibles:
- **API**: http://localhost (puerto 80 a través de Nginx)
- **API Directa**: http://localhost:3000

## 📡 Endpoints de la API

| Método | Endpoint | Descripción |
|--------|----------|-------------|
| GET | / | Información de la API |
| GET | /health | Estado de salud del servidor |
| GET | /api/users | Lista de usuarios |
| GET | /api/users/:id | Usuario específico |
| POST | /api/users | Crear nuevo usuario |

### Ejemplos de uso

```bash
# Obtener información de la API
curl http://localhost/

# Health check
curl http://localhost/health

# Listar usuarios
curl http://localhost/api/users

# Obtener usuario por ID
curl http://localhost/api/users/1

# Crear usuario
curl -X POST http://localhost/api/users \
  -H "Content-Type: application/json" \
  -d '{"name":"Juan Pérez","email":"juan@example.com"}'
```

## 🚀 Despliegue a Producción

**📖 Para una guía completa paso a paso de cómo desplegar este proyecto, ver [DEPLOYMENT.md](./DEPLOYMENT.md)**

La guía de despliegue incluye:
- Cómo subir el código a GitHub
- Configurar Secrets en GitHub Actions
- Configurar SSH y conectar con el VPS
- Instalar Docker en Digital Ocean
- Configurar el firewall y seguridad
- Probar el pipeline CI/CD
- Verificar Blue-Green Deployment
- Troubleshooting completo

## 🔧 Configuración de GitHub Actions

### Secrets necesarios en GitHub

Ve a tu repositorio → **Settings** → **Secrets and variables** → **Actions** y añade:

#### Docker Hub
- `DOCKER_USERNAME`: Tu usuario de Docker Hub
- `DOCKER_PASSWORD`: Tu token/password de Docker Hub

#### VPS (Digital Ocean)
- `VPS_HOST`: IP de tu VPS
- `VPS_USERNAME`: Usuario SSH (ej: root)
- `VPS_SSH_KEY`: Tu clave SSH privada
- `VPS_PORT`: Puerto SSH (por defecto: 22)

### Generar y configurar SSH Key

```bash
# Generar clave SSH (si no tienes una)
ssh-keygen -t ed25519 -C "tu@email.com"

# Copiar clave PÚBLICA al VPS
ssh-copy-id usuario@IP_DEL_VPS

# En Windows PowerShell, copiar clave PRIVADA al clipboard
Get-Content ~/.ssh/id_ed25519 | Set-Clipboard

# En Linux/Mac
cat ~/.ssh/id_ed25519 | pbcopy  # Mac
cat ~/.ssh/id_ed25519 | xclip   # Linux
```

Pega la clave privada completa en el secret `VPS_SSH_KEY`.

## 🖥️ Configuración del VPS

### 1. Conectar al VPS

```bash
ssh root@TU_IP_VPS
```

### 2. Instalar Docker y Docker Compose

```bash
# Actualizar sistema
apt update && apt upgrade -y

# Instalar Docker
curl -fsSL https://get.docker.com -o get-docker.sh
sh get-docker.sh

# Instalar Docker Compose
apt install docker-compose git -y

# Verificar instalación
docker --version
docker-compose --version
```

### 3. Clonar el repositorio

```bash
cd ~
git clone https://github.com/Derck23/evaluacionU2U3.git
cd evaluacionU2U3
```

### 4. Hacer ejecutable el script

```bash
chmod +x scripts/blue-green-deploy.sh
```

### 5. Iniciar servicios

```bash
docker-compose up -d
```

## 🔄 Blue-Green Deployment

### ¿Qué es Blue-Green Deployment?

Es una estrategia de deployment que reduce el downtime y el riesgo al tener dos entornos de producción idénticos:
- **Blue**: Entorno actualmente en producción
- **Green**: Nuevo entorno con la versión actualizada

### ¿Cómo funciona?

1. **Deploy del nuevo entorno**: Se despliega la nueva versión en el entorno inactivo (Green)
2. **Health Check**: Se verifica que la nueva versión funcione correctamente
3. **Switch de tráfico**: Nginx redirige el tráfico del entorno Blue al Green
4. **Rollback automático**: Si hay problemas, se revierte al entorno anterior

### Ejecutar manualmente

```bash
./scripts/blue-green-deploy.sh usuario/evaluacion-devops:latest
```

### Flujo del script

```
┌─────────────────────────────────────────┐
│ 1. Detectar entorno activo (Blue/Green)│
└──────────────┬──────────────────────────┘
               │
┌──────────────▼──────────────────────────┐
│ 2. Desplegar en entorno inactivo       │
└──────────────┬──────────────────────────┘
               │
┌──────────────▼──────────────────────────┐
│ 3. Health Check del nuevo entorno      │
└──────────────┬──────────────────────────┘
               │
┌──────────────▼──────────────────────────┐
│ 4. Actualizar configuración de Nginx   │
└──────────────┬──────────────────────────┘
               │
┌──────────────▼──────────────────────────┐
│ 5. Recargar Nginx (sin downtime)       │
└──────────────┬──────────────────────────┘
               │
┌──────────────▼──────────────────────────┐
│ 6. Verificar tráfico redirigido        │
└──────────────┬──────────────────────────┘
               │
       ┌───────┴────────┐
       │                │
   ┌───▼───┐      ┌────▼────┐
   │ ✅ OK │      │ ❌ Error │
   └───┬───┘      └────┬────┘
       │               │
       │          ┌────▼────┐
       │          │Rollback │
       │          └─────────┘
       │
┌──────▼──────────────────────────────────┐
│ 7. Detener entorno antiguo              │
└─────────────────────────────────────────┘
```

## 📊 CI/CD Pipeline

El pipeline de GitHub Actions se ejecuta automáticamente en cada push a `main`:

### Fases del Pipeline

1. **Test** 🧪
   - Checkout del código
   - Instalación de dependencias
   - Ejecución de tests con cobertura

2. **Build** 🏗️
   - Construcción de imagen Docker
   - Push a Docker Hub con tags latest y SHA del commit
   - Cache para optimizar builds futuros

3. **Deploy** 🚀
   - Conexión SSH al VPS
   - Pull de la última imagen
   - Ejecución del script Blue-Green Deployment
   - Verificación del deployment

## 🧪 Testing

### Ejecutar todos los tests

```bash
npm test
```

### Tests incluidos

- ✅ GET / - Información de la API
- ✅ GET /health - Health check
- ✅ GET /api/users - Lista de usuarios
- ✅ GET /api/users/:id - Usuario específico
- ✅ GET /api/users/:id - Usuario inexistente (404)
- ✅ POST /api/users - Crear usuario
- ✅ POST /api/users - Validación de campos requeridos
- ✅ Ruta no encontrada (404)

### Cobertura de código

El proyecto mantiene >70% de cobertura en:
- Statements
- Branches
- Functions
- Lines

## 📁 Estructura del Proyecto

```
evaluacionU2U3/
├── src/
│   ├── index.js              # Aplicación Express
│   └── index.test.js         # Tests con Supertest
├── scripts/
│   └── blue-green-deploy.sh  # Script de Blue-Green Deployment
├── nginx/
│   ├── nginx.conf            # Configuración principal de Nginx
│   └── conf.d/
│       └── default.conf      # Configuración del proxy inverso
├── .github/
│   └── workflows/
│       └── ci-cd.yml         # Pipeline de CI/CD
├── Dockerfile                # Imagen Docker de la aplicación
├── docker-compose.yml        # Orquestación de servicios
├── package.json              # Dependencias del proyecto
├── jest.config.js            # Configuración de Jest
└── README.md                 # Este archivo
```

## 🐛 Troubleshooting

### Error: Cannot connect to Docker daemon

```bash
sudo systemctl start docker
sudo systemctl enable docker
```

### Error en health check

```bash
# Ver logs
docker logs evaluacion-app

# Verificar estado
docker ps

# Probar endpoint
curl http://localhost:3000/health
```

### Pipeline falla en deploy

1. Verifica que los secrets estén configurados correctamente
2. Asegúrate de que el VPS sea accesible: `ssh usuario@IP`
3. Verifica permisos: `chmod +x scripts/blue-green-deploy.sh`
4. Revisa los logs en GitHub Actions

### Nginx no redirige correctamente

```bash
# Verificar configuración
docker exec evaluacion-nginx nginx -t

# Recargar
docker exec evaluacion-nginx nginx -s reload

# Ver logs
docker logs evaluacion-nginx
```

## 📚 Recursos

- [Docker Documentation](https://docs.docker.com/)
- [GitHub Actions](https://docs.github.com/en/actions)
- [Digital Ocean Tutorials](https://www.digitalocean.com/community/tutorials)
- [Nginx Documentation](https://nginx.org/en/docs/)
- [Blue-Green Deployment](https://martinfowler.com/bliki/BlueGreenDeployment.html)

## 👥 Autor

Derck23

## 📄 Licencia

ISC
