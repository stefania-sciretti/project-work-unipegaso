@echo off
echo ==========================================
echo   Apice Clinic
echo ==========================================

:: Imposta Java 17 (JBR IntelliJ) come JAVA_HOME per Maven e per il runtime
set JAVA_HOME=C:\Program Files\JetBrains\IntelliJ IDEA 2021.3.1\jbr
set PATH=%JAVA_HOME%\bin;%PATH%

:: Ferma eventuali processi Java attivi
echo [1/4] Arresto processi Java precedenti...
taskkill /F /IM java.exe 2>nul
timeout /t 2 /nobreak >nul

:: Build del backend con Maven
echo [2/4] Build Backend (Maven)...
cd /d "%~dp0backend"
call mvn clean package -DskipTests -q
if errorlevel 1 (
    echo.
    echo [ERRORE] Build Maven fallita. Controlla i log sopra.
    pause
    exit /b 1
)
cd /d "%~dp0"
echo     Build completata con successo!

:: Avvia il backend Spring Boot
echo [3/4] Avvio Backend (porta 8080)...
start "Backend Spring Boot" cmd /k ""%JAVA_HOME%\bin\java.exe" -jar "%~dp0backend\target\clinica-sanitaria-1.0.0.jar" --spring.profiles.active=dev"

:: Attende che il backend si avvii
echo     Attendo avvio backend...
timeout /t 12 /nobreak >nul

:: Avvia il frontend Angular
echo [4/4] Avvio Frontend Angular (porta 4200)...
start "Frontend Angular" cmd /k "cd /d "%~dp0frontend" && npm run start"

echo.
echo ==========================================
echo   Servizi avviati!
echo   Backend:  http://localhost:8080
echo   Frontend: http://localhost:4200
echo   Swagger:  http://localhost:8080/swagger-ui.html
echo ==========================================
echo   Apri il browser su: http://localhost:4200
echo ==========================================
pause
