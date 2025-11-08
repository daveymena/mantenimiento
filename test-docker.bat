@echo off
echo ========================================
echo  Probando Servidor de IA con Docker
echo ========================================
echo.

REM Verificar Docker
where docker >nul 2>nul
if %ERRORLEVEL% NEQ 0 (
    echo [X] ERROR: Docker no está instalado
    echo.
    echo Instala Docker Desktop desde:
    echo https://www.docker.com/products/docker-desktop
    pause
    exit /b 1
)

echo [OK] Docker encontrado
echo.

echo [1/4] Construyendo imagen Docker...
docker build -t pc-optimizer-ai .
if %ERRORLEVEL% NEQ 0 (
    echo [X] ERROR: Fallo al construir imagen
    pause
    exit /b 1
)

echo.
echo [2/4] Deteniendo contenedor anterior (si existe)...
docker stop pc-optimizer-ai-test 2>nul
docker rm pc-optimizer-ai-test 2>nul

echo.
echo [3/4] Iniciando contenedor...
docker run -d ^
  --name pc-optimizer-ai-test ^
  -p 5000:5000 ^
  -e GROQ_KEY_1=%GROQ_KEY_1% ^
  -e GROQ_KEY_2=%GROQ_KEY_2% ^
  -e GROQ_KEY_3=%GROQ_KEY_3% ^
  -e FLASK_ENV=development ^
  pc-optimizer-ai

if %ERRORLEVEL% NEQ 0 (
    echo [X] ERROR: Fallo al iniciar contenedor
    pause
    exit /b 1
)

echo.
echo [4/4] Esperando que el servidor inicie...
timeout /t 5 >nul

echo.
echo ========================================
echo  Servidor Iniciado
echo ========================================
echo.
echo URL: http://localhost:5000
echo.
echo Probando health check...
curl http://localhost:5000/health
echo.
echo.
echo ========================================
echo  Comandos Útiles
echo ========================================
echo.
echo Ver logs:
echo   docker logs -f pc-optimizer-ai-test
echo.
echo Detener servidor:
echo   docker stop pc-optimizer-ai-test
echo.
echo Reiniciar servidor:
echo   docker restart pc-optimizer-ai-test
echo.
echo Eliminar contenedor:
echo   docker rm -f pc-optimizer-ai-test
echo.
echo ========================================
echo.
pause
