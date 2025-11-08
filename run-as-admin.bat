@echo off
echo ========================================
echo PC Maintenance Optimizer
echo ========================================
echo.
echo Iniciando aplicacion...
echo.

cd /d "%~dp0"
npm start

if errorlevel 1 (
    echo.
    echo Error al iniciar la aplicacion.
    echo Asegurate de haber ejecutado: npm install
    pause
)
