# 🚀 Quick Start - Comandos Rápidos

## Subir a GitHub (Primera vez)

```powershell
git init
git remote add origin https://github.com/Derck23/evaluacionU2U3.git
git add .
git commit -m "Initial commit"
git branch -M main
git push -u origin main
```

## Subir cambios

```powershell
git add .
git commit -m "Descripción del cambio"
git push origin main
```

## Generar y copiar SSH Key

```powershell
# Generar
ssh-keygen -t ed25519 -C "tu@email.com"

# Ver clave PÚBLICA (para el VPS)
Get-Content ~/.ssh/id_ed25519.pub

# Copiar clave PRIVADA (para GitHub Secret)
Get-Content ~/.ssh/id_ed25519 | Set-Clipboard
```

## Conectar al VPS

```powershell
ssh root@TU_IP_VPS
```

## Setup VPS (ejecutar en el VPS)

```bash
# Instalar todo
curl -fsSL https://get.docker.com | sh
apt install docker-compose git -y

# Clonar proyecto
cd ~
git clone https://github.com/Derck23/evaluacionU2U3.git
cd evaluacionU2U3
chmod +x scripts/blue-green-deploy.sh

# Iniciar
docker-compose up -d

# Ver logs
docker-compose logs -f
```

## Secrets de GitHub

| Secret | Valor | Dónde obtenerlo |
|--------|-------|-----------------|
| `DOCKER_USERNAME` | tu_usuario | Tu usuario de Docker Hub |
| `DOCKER_PASSWORD` | token_o_password | Docker Hub → Settings → Security |
| `VPS_HOST` | 123.456.789.0 | IP de tu VPS en Digital Ocean |
| `VPS_USERNAME` | root | Usuario SSH (normalmente root) |
| `VPS_SSH_KEY` | -----BEGIN...---- | `Get-Content ~/.ssh/id_ed25519` |
| `VPS_PORT` | 22 | Puerto SSH (normalmente 22) |

## Verificar que funciona

```powershell
# Health check
curl http://TU_IP_VPS/health

# Ver frontend
# Abrir navegador en: http://TU_IP_VPS
```

## Comandos útiles en el VPS

```bash
# Ver contenedores
docker ps

# Ver logs
docker logs evaluacion-app
docker logs evaluacion-nginx

# Reiniciar
docker-compose restart

# Actualizar
git pull origin main
docker-compose up -d --build

# Limpiar
docker system prune -a
```

## Probar Blue-Green manualmente

```bash
# En el VPS
cd ~/evaluacionU2U3
./scripts/blue-green-deploy.sh TU_USUARIO/evaluacion-devops:latest
```

## Ver el pipeline en GitHub

1. Ve a: https://github.com/Derck23/evaluacionU2U3/actions
2. Click en el último workflow
3. Ver los logs de cada fase

---

**Para guía detallada completa, ver [DEPLOYMENT.md](./DEPLOYMENT.md)**
