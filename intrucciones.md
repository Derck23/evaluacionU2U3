# Evaluación: Arquitectura de Despliegue, Pruebas y Monitoreo

Este proyecto consiste en la implementación de una arquitectura de software robusta que integra pruebas automatizadas, contenerización, servidores web, estrategias de despliegue avanzadas y monitoreo de infraestructura en tiempo real.

**Modalidad:** Grupal  
**Entorno Requerido:** VPS con pipelines configurados.

---

## 📋 Instrucciones Generales

1.  **Trabajo en Equipo:** Actividad exclusiva para los equipos definidos en clase.
2.  **Proyecto Base:** Se utiliza un proyecto capaz de demostrar la aplicación correcta de las herramientas.
3.  **Evidencia de Funcionamiento:** El proyecto es funcional. Se debe demostrar en tiempo real:
    * Cambios de infraestructura reflejados correctamente.
    * Pruebas pasando.
    * Contenedores levantados.
    * Gráficas de monitoreo activas.

---

## 🚀 Rúbrica y Requisitos Técnicos

La evaluación es acumulativa según el nivel de complejidad implementado:

### 🥉 1. Nivel Satisfactorio (Requisito Base)
Para aprobar, se debe cumplir con la siguiente infraestructura:

* **Pruebas de Integración (Supertest):**
    * Implementación de una suite que valide los endpoints principales de la API.
    * **Requisito:** Al menos 3 pruebas de test.
* **Contenerización (Docker):**
    * Implementación de Docker con *Container Registry* o alguna implementación de build.
* **Servidor Web (Nginx):**
    * Configuración de Nginx como Proxy Inverso para gestionar las peticiones hacia la aplicación.

### 🥈 2. Nivel Destacado (Intermedio)
*Incluye todo lo del Nivel Satisfactorio, más:*

* **Estrategia Blue-Green Deployment:**
    * Mecanismo (script o configuración) para tener dos entornos (Blue/Green).
    * Switch automatizado del tráfico entre ellos usando Nginx.
    * **Requisito:** Sin tiempo de inactividad (*Zero Downtime*).

### 🥇 3. Nivel Autónomo (Avanzado)
*Incluye todo lo del Nivel Destacado, más:*

* **Observabilidad (Prometheus + Grafana):**
    * Despliegue de un servidor Grafana conectado a Prometheus.
* **Dashboard:**
    * Configuración de un panel en Grafana.
    * Monitoreo de métricas vitales de los contenedores Docker (CPU, memoria, estado de contenedores, etc.).

---

## 📄 Entregables

El equipo debe subir a la plataforma los siguientes elementos:

### 1. Documento de Reporte (PDF)
Un documento técnico que detalle el procedimiento realizado, incluyendo:

* **Portada:** Nombres de todos los integrantes.
* **Explicación de la Arquitectura:** Diagrama breve de la comunicación entre servicios.
* **Evidencia paso a paso:** Capturas de pantalla comentadas y *snippets* de código clave (Docker, Nginx, Tests).
* **Comprobación de resultados:**
    * ✅ Captura de tests pasando exitosamente.
    * ✅ Captura del funcionamiento del Proxy Inverso.
    * ✅ *(Si aplica)* Evidencia del cambio de entorno Blue-Green.
    * ✅ *(Si aplica)* Capturas del Dashboard de Grafana con datos reales.

---

## 🛠 Comandos del Proyecto (Ejemplo)

```bash
# Ejecutar pruebas
npm test

# Levantar contenedores
docker-compose up -d

# Ejecutar script de despliegue
./deploy.sh