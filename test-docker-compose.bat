@echo off
echo ========================================
echo  Probando con Docker Compose
echo ========================================
echo.

REM Verificar Docker Compose
where docker-compose >nul 2>nul
if %ERRORLEVEL% NEQ 0 (
    echo [X] ERROR: Docker Compose no está instalado
    pause
    exit /b 1
)

echo [OK] Docker Compose encontrado
echo.

echo Iniciando servicios...
docker-compose up -d

if %ERRORLEVEL% NEQ 0 (
    echo [X] ERROR: Fallo al iniciar servicios
    pause
    exit /b 1
)

echo.
echo Esperando que el servidor inicie...
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
echo Ver logs en tiempo real:
echo   docker-compose logs -f
echo.
echo Detener servicios:
echo   docker-compose down
echo.
echo ========================================
echo.
pause
