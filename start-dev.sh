#!/bin/bash

echo "=========================================="
echo "  Apice Clinic"
echo "=========================================="

# Imposta Java 17 (JBR IntelliJ) come JAVA_HOME
export JAVA_HOME="/c/Program Files/JetBrains/IntelliJ IDEA 2021.3.1/jbr"
export PATH="$JAVA_HOME/bin:$PATH"

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Ferma eventuali processi Java attivi
echo "[1/4] Arresto processi Java precedenti..."
pkill -f "java" 2>/dev/null || true
sleep 2

# Build del backend con Maven
echo "[2/4] Build Backend (Maven)..."
cd "$SCRIPT_DIR/backend"
if ! mvn clean package -DskipTests -q; then
  echo ""
  echo "[ERRORE] Build Maven fallita. Controlla i log sopra."
  exit 1
fi
cd "$SCRIPT_DIR"
echo "    Build completata con successo!"

# Avvia il backend Spring Boot
echo "[3/4] Avvio Backend (porta 8080)..."
"$JAVA_HOME/bin/java" -jar "$SCRIPT_DIR/backend/apiceclinic-module/clinic/target/clinic-1.0.0.jar" --spring.profiles.active=dev &
BACKEND_PID=$!

# Attende che il backend si avvii
echo "    Attendo avvio backend..."
sleep 12

# Avvia il frontend Angular
echo "[4/4] Avvio Frontend Angular (porta 4200)..."
cd "$SCRIPT_DIR/frontend"
npm run start &
FRONTEND_PID=$!

echo ""
echo "=========================================="
echo "  Servizi avviati!"
echo "  Backend:  http://localhost:8080"
echo "  Frontend: http://localhost:4200"
echo "  Swagger:  http://localhost:8080/swagger-ui.html"
echo "=========================================="
echo "  Apri il browser su: http://localhost:4200"
echo "=========================================="
echo ""
echo "Premi CTRL+C per fermare tutti i servizi."

# Attende e gestisce CTRL+C per fermare tutto
cleanup() {
  echo 'Arresto servizi...'
  kill "$BACKEND_PID" "$FRONTEND_PID" 2>/dev/null
  exit 0
}
trap cleanup SIGINT SIGTERM
wait
