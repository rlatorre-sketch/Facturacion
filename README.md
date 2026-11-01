# Microservicio de Facturación (Caso 02 - TalentoYa) — Pipeline CI/CD (EP2 DOY0101)

Repositorio correspondiente a la **Evaluación Parcial N°2** de la asignatura **Ingeniería DevOps (DOY0101)**. Este proyecto implementa un pipeline CI/CD automatizado de punta a punta en **GitHub Actions** para un microservicio desarrollado en **Java 21 con Spring Boot 3.3.5**, integrando contenerización optimizada, pruebas automatizadas, análisis de seguridad con bloqueo (*Security Gate*), despliegue continuo trazable y orquestación de contenedores.

---

## 1. Descripción del Microservicio y Ejecución Local

El microservicio `facturacion-svc` gestiona la emisión, consulta y cálculo de facturas (incluyendo validación de ítems, cálculo de IVA y persistencia en base de datos en memoria H2), exponiendo una API REST documentada con OpenAPI/Swagger.

### Requisitos previos
* JDK 21 y Maven 3.9+ (para ejecución directa) o Docker y Docker Compose (para ejecución en contenedores).

### Comandos de ejecución local
```bash
# Ejecutar pruebas unitarias y validación de cobertura localmente
mvn clean verify

# Levantar el entorno orquestado (2 réplicas) con Docker Compose
docker compose up -d --build

# Verificar estado de los contenedores y healthchecks
docker compose ps

# Detener el entorno
docker compose down
