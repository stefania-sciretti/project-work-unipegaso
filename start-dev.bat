@echo off
echo ==========================================
echo   CentroFitness Simona ^& Luca - DEV
echo ==========================================

:: Ferma eventuali processi Java attivi
echo [1/3] Arresto processi Java precedenti...
taskkill /F /IM java.exe 2>nul
timeout /t 2 /nobreak >nul

:: Avvia il backend Spring Boot con Java 17
echo [2/3] Avvio Backend (porta 8080)...
set JAVA_HOME=C:\Program Files\JetBrains\IntelliJ IDEA 2021.3.1\jbr
start "Backend Spring Boot" cmd /k ""%JAVA_HOME%\bin\java.exe" -jar "%~dp0backend\target\clinica-sanitaria-1.0.0.jar" --spring.profiles.active=dev"

:: Attende che il backend si avvii
echo     Attendo avvio backend...
timeout /t 12 /nobreak >nul

:: Avvia il frontend Angular
echo [3/3] Avvio Frontend Angular (porta 4200)...
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
