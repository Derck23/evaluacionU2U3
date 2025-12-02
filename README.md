# Evaluación DevOps - Unidades 2 y 3

Proyecto de evaluación DevOps implementando pruebas de integración, containerización con Docker, proxy inverso con Nginx y estrategia de Blue-Green Deployment.

## 📋 Requisitos Implementados

### ✅ Nivel Satisfactorio (Base)

1. **Pruebas de Integración (Supertest)** ⭐
   - Suite completa de pruebas con Jest y Supertest
   - 9 pruebas automatizadas que validan todos los endpoints
   - Cobertura de código: **100%** (Statements, Branches, Functions, Lines)
   - Tests incluyen validaciones de éxito y manejo de errores
   - Ejecución automática en CI/CD pipeline

2. **Contenerización (Docker)** ⭐
   - Dockerfile multi-stage optimizado con Node.js 18 Alpine
   - Imagen registrada en Docker Hub: `derck23/evaluacion-devops`
   - Docker Compose para orquestación multi-contenedor
   - Health checks configurados en todos los servicios
   - Variables de entorno y networking configurado
   - Volúmenes para persistencia de datos

3. **Servidor Web (Nginx)** ⭐
   - Nginx Alpine configurado como Proxy Inverso
   - Gestión de peticiones HTTP hacia la aplicación backend
   - Configuración optimizada: gzip, caching, worker_processes
   - Proxy headers correctamente configurados
   - Load balancing preparado para entornos Blue/Green
   - Logs de acceso y errores

### 🌟 Nivel Destacado (Intermedio)

4. **Estrategia Blue-Green Deployment** ⭐
   - Script Bash automatizado (`blue-green-deploy.sh`) para despliegue sin downtime
   - Dos entornos idénticos (Blue/Green) que permiten switch instantáneo
   - Health checks exhaustivos antes de cambiar tráfico
   - Rollback automático en caso de fallo (con logs detallados)
   - **Zero Downtime** garantizado mediante reconfiguración dinámica de Nginx
   - Detención segura del entorno antiguo tras validación
   - Compatible con Docker Compose y orquestadores

## 🎯 Características Adicionales

- ✅ **CI/CD Pipeline** completo con GitHub Actions (3 stages: test, build, deploy)
- ✅ **Frontend Dashboard** para demostración visual de la API
- ✅ **Documentación completa** (README, DEPLOYMENT, QUICKSTART)
- ✅ **Despliegue en VPS** (Digital Ocean) con acceso público
- ✅ **Manejo de errores** robusto en toda la aplicación
- ✅ **Logs estructurados** para debugging y monitoreo
- ✅ **Security best practices**: usuario no-root en Docker, secrets en GitHub

## 🚀 Tecnologías Utilizadas

- **Backend**: Node.js 18 + Express 4.18
- **Testing**: Jest 29 + Supertest 6 (100% coverage)
- **Containerización**: Docker 24 + Docker Compose v2
- **Proxy Inverso**: Nginx Alpine (última versión)
- **CI/CD**: GitHub Actions con pipeline multi-stage
- **Container Registry**: Docker Hub
- **VPS**: Digital Ocean Ubuntu 22.04 LTS
- **Deployment**: Blue-Green Strategy con Bash scripting
- **Frontend**: HTML5 + CSS3 + JavaScript (Vanilla)

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
# Tests con cobertura
npm test

# Tests en modo watch (desarrollo)
npm test -- --watch

# Ver reporte de cobertura en navegador
npm test -- --coverage
# Abrir: coverage/lcov-report/index.html
```

### Tests incluidos (9 tests en total)

1. ✅ **GET /** - Devuelve frontend HTML correctamente
2. ✅ **GET /api** - Información de la API en JSON
3. ✅ **GET /health** - Health check del servidor
4. ✅ **GET /api/users** - Lista de usuarios (array)
5. ✅ **GET /api/users/:id** - Usuario específico por ID
6. ✅ **GET /api/users/:id** - Error 404 para usuario inexistente
7. ✅ **POST /api/users** - Crear usuario con datos válidos
8. ✅ **POST /api/users** - Validación de campos requeridos (400)
9. ✅ **Ruta no encontrada** - Error 404 general

### Cobertura de código

**Resultado: 100% en todas las métricas** 🎯

| Métrica    | Cobertura | Detalles |
|-----------|-----------|----------|
| Statements | 100%     | 48/48    |
| Branches   | 100%     | 12/12    |
| Functions  | 100%     | 9/9      |
| Lines      | 100%     | 48/48    |

### Tecnología de testing

- **Framework**: Jest 29 (test runner y assertions)
- **HTTP Testing**: Supertest 6 (para integration tests)
- **Assertions**: expect() de Jest para validaciones
- **Mocking**: No necesario (tests de integración real)

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

## ✅ Evidencia de Cumplimiento de Requisitos

### 1. Supertest (Mínimo 3 pruebas) ✓
- **Implementado**: 9 pruebas de integración
- **Ubicación**: `src/index.test.js`
- **Cobertura**: 100%
- **Comando**: `npm test`

### 2. Docker + Container Registry ✓
- **Dockerfile**: Multi-stage optimizado
- **Docker Compose**: Orquestación de app + nginx
- **Registry**: Docker Hub (`derck23/evaluacion-devops`)
- **Tags**: `:latest` y `:sha-commit`

### 3. Nginx como Proxy Inverso ✓
- **Configuración**: `nginx/conf.d/default.conf`
- **Puerto**: 80 → 3000 (proxy pass)
- **Features**: gzip, headers, load balancing preparado

### 4. Blue-Green Deployment ✓
- **Script**: `scripts/blue-green-deploy.sh`
- **Automatización**: GitHub Actions pipeline
- **Zero Downtime**: Validado mediante health checks
- **Rollback**: Automático en caso de fallo

## 🌐 Demo en Producción

- **URL**: http://164.92.107.83
- **API Health**: http://164.92.107.83/health
- **Repositorio**: https://github.com/Derck23/evaluacionU2U3
- **Docker Hub**: https://hub.docker.com/r/derck23/evaluacion-devops
- **CI/CD**: GitHub Actions (ver `.github/workflows/ci-cd.yml`)

## 📝 Notas para Evaluación

- **Pruebas**: Se ejecutan automáticamente en cada push (ver Actions)
- **Docker**: Imágenes disponibles públicamente en Docker Hub
- **Nginx**: Configuración personalizada en carpeta `nginx/`
- **Blue-Green**: Script ejecutable con logs detallados del proceso
- **Documentación**: README completo + DEPLOYMENT.md + QUICKSTART.md
- **Cobertura**: 100% en todos los aspectos del código

## 👥 Autor

**Derck23**
- GitHub: [@Derck23](https://github.com/Derck23)
- Proyecto: Evaluación DevOps - Unidades 2 y 3

## 📄 Licencia

ISC
