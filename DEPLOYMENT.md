# 🚀 Guía de Despliegue Completo

## Paso 1: Subir el Proyecto a GitHub

### 1.1 Inicializar Git (si no está inicializado)

```powershell
# Verificar si ya está inicializado
git status

# Si no está inicializado, hacer:
git init
```

### 1.2 Configurar Git (primera vez)

```powershell
git config --global user.name "Tu Nombre"
git config --global user.email "tu@email.com"
```

### 1.3 Conectar con tu repositorio

```powershell
# Agregar el remote (tu repositorio)
git remote add origin https://github.com/Derck23/evaluacionU2U3.git

# Verificar
git remote -v
```

### 1.4 Subir el código

```powershell
# Agregar todos los archivos
git add .

# Hacer commit
git commit -m "Initial commit: Proyecto DevOps con Docker, Nginx y Blue-Green Deployment"

# Subir a GitHub (primera vez)
git branch -M main
git push -u origin main
```

Si ya existe contenido en GitHub:
```powershell
# Pull primero para evitar conflictos
git pull origin main --allow-unrelated-histories

# Luego push
git push -u origin main
```

---

## Paso 2: Configurar Secrets en GitHub

### 2.1 Ir a la configuración de Secrets

1. Ve a tu repositorio: https://github.com/Derck23/evaluacionU2U3
2. Click en **Settings** (arriba a la derecha)
3. En el menú izquierdo: **Secrets and variables** → **Actions**
4. Click en **New repository secret**

### 2.2 Crear los siguientes Secrets:

#### **DOCKER_USERNAME**
- **Name**: `DOCKER_USERNAME`
- **Value**: Tu usuario de Docker Hub (ej: `derck23`)

#### **DOCKER_PASSWORD**
- **Name**: `DOCKER_PASSWORD`
- **Value**: Tu password/token de Docker Hub

**Para crear un token en Docker Hub:**
1. Ve a https://hub.docker.com/settings/security
2. Click en "New Access Token"
3. Dale un nombre (ej: "GitHub Actions")
4. Copia el token generado
5. Úsalo como `DOCKER_PASSWORD`

#### **VPS_HOST**
- **Name**: `VPS_HOST`
- **Value**: La IP de tu VPS (ej: `164.92.123.456`)

#### **VPS_USERNAME**
- **Name**: `VPS_USERNAME`
- **Value**: Usuario SSH del VPS (normalmente `root`)

#### **VPS_PORT**
- **Name**: `VPS_PORT`
- **Value**: Puerto SSH (normalmente `22`)

#### **VPS_SSH_KEY**
- **Name**: `VPS_SSH_KEY`
- **Value**: Tu clave SSH PRIVADA (ver abajo cómo obtenerla)

---

## Paso 3: Configurar SSH para el VPS

### 3.1 Generar clave SSH (si no tienes una)

```powershell
# Generar nueva clave SSH
ssh-keygen -t ed25519 -C "tu@email.com"

# Presiona Enter para ubicación por defecto
# Presiona Enter 2 veces para sin contraseña (recomendado para CI/CD)
```

### 3.2 Copiar clave PÚBLICA al VPS

```powershell
# Ver tu clave PÚBLICA
Get-Content ~/.ssh/id_ed25519.pub

# Copiar la salida (toda la línea que empieza con ssh-ed25519)
```

**En el VPS** (conéctate primero con `ssh root@TU_IP`):
```bash
# Crear carpeta SSH si no existe
mkdir -p ~/.ssh

# Pegar tu clave pública
nano ~/.ssh/authorized_keys
# Pegar la clave y guardar (Ctrl+O, Enter, Ctrl+X)

# Establecer permisos correctos
chmod 700 ~/.ssh
chmod 600 ~/.ssh/authorized_keys
```

### 3.3 Copiar clave PRIVADA para GitHub

```powershell
# Copiar clave PRIVADA al clipboard
Get-Content ~/.ssh/id_ed25519 | Set-Clipboard

# O ver en pantalla
Get-Content ~/.ssh/id_ed25519
```

**IMPORTANTE**: Copia TODO el contenido, incluyendo:
```
-----BEGIN OPENSSH PRIVATE KEY-----
...todo el contenido...
-----END OPENSSH PRIVATE KEY-----
```

Pega esto en el secret `VPS_SSH_KEY` en GitHub.

### 3.4 Probar conexión SSH

```powershell
# Probar que puedes conectarte sin password
ssh root@TU_IP_VPS

# Si funciona, estás listo
```

---

## Paso 4: Configurar el VPS (Digital Ocean)

### 4.1 Crear Droplet en Digital Ocean

1. Ve a https://cloud.digitalocean.com/
2. Click en **Create** → **Droplets**
3. Configuración recomendada:
   - **Image**: Ubuntu 22.04 LTS
   - **Plan**: Basic - $6/mes (1GB RAM)
   - **Datacenter**: El más cercano a ti
   - **Authentication**: SSH Key (añade tu clave pública)
   - **Hostname**: evaluacion-devops

4. Click en **Create Droplet**
5. Anota la IP que te asignen

### 4.2 Conectarse al VPS

```powershell
# Primera conexión
ssh root@TU_IP_VPS
```

### 4.3 Instalar Docker y Docker Compose

```bash
# Actualizar sistema
apt update && apt upgrade -y

# Instalar Docker
curl -fsSL https://get.docker.com -o get-docker.sh
sh get-docker.sh

# Instalar Docker Compose
apt install docker-compose -y

# Instalar Git
apt install git -y

# Verificar instalaciones
docker --version
docker-compose --version
git --version
```

### 4.4 Clonar el repositorio

```bash
# Ir al directorio home
cd ~

# Clonar tu repositorio
git clone https://github.com/Derck23/evaluacionU2U3.git

# Entrar al directorio
cd evaluacionU2U3

# Hacer ejecutable el script de Blue-Green
chmod +x scripts/blue-green-deploy.sh
```

### 4.5 Configurar el firewall

```bash
# Permitir SSH, HTTP y HTTPS
ufw allow 22/tcp
ufw allow 80/tcp
ufw allow 443/tcp

# Habilitar firewall
ufw enable

# Verificar estado
ufw status
```

### 4.6 Primera ejecución manual

```bash
# Construir e iniciar contenedores
docker-compose up -d

# Ver logs
docker-compose logs -f

# Verificar que funciona
curl http://localhost/health
```

Deberías ver: `{"status":"healthy",...}`

---

## Paso 5: Probar el Pipeline de CI/CD

### 5.1 Hacer un cambio y push

```powershell
# En tu máquina local, hacer un pequeño cambio
# Por ejemplo, editar README.md

git add .
git commit -m "Test: Probar pipeline CI/CD"
git push origin main
```

### 5.2 Ver el pipeline en acción

1. Ve a tu repositorio en GitHub
2. Click en la pestaña **Actions**
3. Verás el workflow "CI/CD Pipeline" ejecutándose
4. Click en él para ver los detalles

**Fases que verás:**
- ✅ **Test**: Ejecuta los tests con Jest
- ✅ **Build**: Construye y sube imagen Docker
- ✅ **Deploy**: Despliega con Blue-Green en el VPS

### 5.3 Verificar el despliegue

```powershell
# Desde tu máquina local
curl http://TU_IP_VPS/health

# O abrir en navegador
# http://TU_IP_VPS
```

---

## Paso 6: Verificación Final

### 6.1 Verificar que todo funciona

**En el navegador:**
```
http://TU_IP_VPS
```

Deberías ver el dashboard visual.

**Probar la API:**
```powershell
# Health check
curl http://TU_IP_VPS/health

# Obtener usuarios
curl http://TU_IP_VPS/api/users

# Crear usuario
curl -X POST http://TU_IP_VPS/api/users `
  -H "Content-Type: application/json" `
  -d '{\"name\":\"Test User\",\"email\":\"test@example.com\"}'
```

### 6.2 Ver logs en el VPS

```bash
# Conectar al VPS
ssh root@TU_IP_VPS

# Ver logs de la aplicación
docker logs evaluacion-app

# Ver logs de Nginx
docker logs evaluacion-nginx

# Ver todos los contenedores
docker ps
```

---

## Paso 7: Probar Blue-Green Deployment

### 7.1 Hacer un cambio en el código

```powershell
# Editar algo visible, por ejemplo en src/index.js
# Cambiar la versión en la respuesta de '/'

git add .
git commit -m "Update: Cambiar versión a 1.0.1"
git push origin main
```

### 7.2 Ver el Blue-Green en acción

1. Ve a **Actions** en GitHub
2. Observa el job "Blue-Green Deployment"
3. Verás los logs del script ejecutándose:
   - Detecta entorno activo
   - Despliega en entorno inactivo
   - Verifica health check
   - Cambia tráfico en Nginx
   - Detiene entorno antiguo

### 7.3 Verificar Zero Downtime

```powershell
# En otra terminal, ejecutar este loop mientras se despliega
while ($true) { 
    curl http://TU_IP_VPS/health -UseBasicParsing | Select-Object StatusCode
    Start-Sleep -Seconds 2
}
```

Deberías ver `StatusCode: 200` durante todo el despliegue (sin errores).

---

## 🔧 Troubleshooting

### Error: "Permission denied (publickey)"
```powershell
# Verificar que la clave está en GitHub Secrets
# Verificar que la clave pública está en el VPS
ssh root@TU_IP_VPS
cat ~/.ssh/authorized_keys
```

### Error: "docker: command not found" en el VPS
```bash
# Reinstalar Docker
curl -fsSL https://get.docker.com -o get-docker.sh
sh get-docker.sh
```

### Pipeline falla en Build
- Verifica DOCKER_USERNAME y DOCKER_PASSWORD en GitHub Secrets
- Verifica que puedes hacer login: `docker login`

### No puedo conectarme al VPS
```bash
# Verificar firewall
ufw status

# Verificar que Docker está corriendo
systemctl status docker

# Reiniciar contenedores
docker-compose down
docker-compose up -d
```

### El sitio no carga en el navegador
```bash
# Verificar Nginx
docker logs evaluacion-nginx

# Verificar app
docker logs evaluacion-app

# Reiniciar todo
docker-compose restart
```

---

## 📊 Comandos Útiles

### En tu máquina local:

```powershell
# Ver estado de Git
git status

# Ver remotes
git remote -v

# Ver logs de commits
git log --oneline

# Push forzado (cuidado!)
git push -f origin main
```

### En el VPS:

```bash
# Ver contenedores corriendo
docker ps

# Ver logs en tiempo real
docker-compose logs -f

# Reiniciar aplicación
docker-compose restart app

# Reiniciar todo
docker-compose down && docker-compose up -d

# Limpiar todo Docker
docker system prune -a

# Actualizar código
cd ~/evaluacionU2U3
git pull origin main
docker-compose up -d --build
```

---

## ✅ Checklist Final

- [ ] Código subido a GitHub
- [ ] Secrets configurados en GitHub
- [ ] SSH funcionando con el VPS
- [ ] Docker instalado en el VPS
- [ ] Repositorio clonado en el VPS
- [ ] Firewall configurado
- [ ] Primera ejecución manual exitosa
- [ ] Pipeline de CI/CD ejecutado correctamente
- [ ] Sitio accesible desde el navegador
- [ ] Blue-Green deployment probado
- [ ] Zero downtime verificado

---

## 🎯 Próximos Pasos

1. **Dominio personalizado** (opcional):
   - Comprar dominio
   - Apuntar DNS al VPS
   - Configurar SSL con Let's Encrypt

2. **Monitoreo** (opcional):
   - Agregar logs centralizados
   - Configurar alertas

3. **Seguridad** (recomendado):
   - Cambiar puerto SSH
   - Configurar fail2ban
   - Actualizar regularmente

¡Tu proyecto está listo para producción! 🚀
