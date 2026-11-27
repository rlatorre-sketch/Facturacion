#!/usr/bin/env bash
set -uo pipefail

echo "============================================================"
echo " AUDITORIA AUTOMATIZADA DE CUMPLIMIENTO DEVSECOPS (IE5/IE6)"
echo "============================================================"

FAILURES=0

pass() { echo "  [PASS] $1"; }
fail() { echo "  [FAIL] $1"; FAILURES=$((FAILURES + 1)); }

# 1. Seguridad en Contenedor (Dockerfile)
echo ""
echo "[1/5] Auditando seguridad del Dockerfile..."
if grep -Eq "^USER[[:space:]]+[^root]" Dockerfile; then
  pass "Dockerfile ejecuta el contenedor con usuario sin privilegios (no-root)."
else
  fail "Dockerfile no define un usuario no-root (USER)."
fi

if grep -Eq "^HEALTHCHECK" Dockerfile; then
  pass "Dockerfile incluye HEALTHCHECK nativo."
else
  fail "Dockerfile no define HEALTHCHECK."
fi

# 2. Cumplimiento de Manifiestos Kubernetes (IE2)
echo ""
echo "[2/5] Auditando manifiestos Kubernetes (k8s/)..."
if grep -q "readinessProbe:" k8s/deployment.yaml && grep -q "livenessProbe:" k8s/deployment.yaml; then
  pass "k8s/deployment.yaml define readinessProbe y livenessProbe."
else
  fail "Faltan sondas de salud (readinessProbe / livenessProbe) en k8s/deployment.yaml."
fi

if grep -q "runAsNonRoot: true" k8s/deployment.yaml && grep -q "limits:" k8s/deployment.yaml; then
  pass "k8s/deployment.yaml aplica runAsNonRoot y limites de recursos (CPU/RAM)."
else
  fail "k8s/deployment.yaml debe incluir securityContext.runAsNonRoot y resources.limits."
fi

if grep -q "prometheus.io/scrape" k8s/deployment.yaml && [ -f "k8s/hpa.yaml" ]; then
  pass "Anotaciones de Prometheus y auto-escalado (HPA) presentes."
else
  fail "Faltan anotaciones de Prometheus o manifiesto k8s/hpa.yaml."
fi

# 3. Configuracion de Observabilidad y Dashboards (IE1 / IE3)
echo ""
echo "[3/5] Auditando configuracion de observabilidad..."
if grep -q "prometheus" src/main/resources/application.yml && grep -q "spring-boot-starter-actuator" pom.xml; then
  pass "Actuator y Micrometer Prometheus configurados en el microservicio."
else
  fail "Falta configuracion de Actuator o Prometheus en pom.xml / application.yml."
fi

if [ -f "observability/prometheus.yml" ] && [ -f "observability/cloudwatch-dashboard.json" ] && [ -f "observability/grafana-dashboard.json" ]; then
  pass "Configuracion de Prometheus y dashboards (CloudWatch + Grafana) presentes."
else
  fail "Faltan archivos requeridos dentro de observability/."
fi

# 4. Gobernanza de Dependencias y Politicas de Seguridad
echo ""
echo "[4/5] Auditando gobernanza de seguridad..."
if [ -f ".github/dependabot.yml" ] && [ -f ".snyk" ]; then
  pass "Politicas de Dependabot (.github/dependabot.yml) y Snyk (.snyk) presentes."
else
  fail "Falta .github/dependabot.yml o archivo de politica .snyk."
fi

# 5. Prevencion de Fuga de Credenciales y Secretos
echo ""
echo "[5/5] Escaneando posibles credenciales hardcodeadas..."
if [ -f "secrets.txt" ]; then
  fail "CRITICO: El archivo secrets.txt fue subido al repositorio."
else
  pass "No existe archivo secrets.txt versionado en el repositorio."
fi

if grep -rnE "AKIA[0-9A-Z]{16}|aws_secret_access_key[[:space:]]*=[[:space:]]*[A-Za-z0-9/+=]{20,}" . \
  --exclude-dir=.git --exclude-dir=target --exclude="auditoria-cumplimiento.sh" >/dev/null 2>&1; then
  fail "CRITICO: Se detectaron posibles credenciales AWS expuestas en el codigo."
else
  pass "Sin credenciales AWS hardcodeadas en el repositorio."
fi

echo ""
echo "============================================================"
if [ "$FAILURES" -eq 0 ]; then
  echo " RESULTADO AUDITORIA: APROBADA (0 incumplimientos)"
  echo "============================================================"
  exit 0
else
  echo " RESULTADO AUDITORIA: RECHAZADA ($FAILURES incumplimiento(s))"
  echo " El pipeline se detiene para proteger el entorno productivo."
  echo "============================================================"
  exit 1
fi