@echo off
echo ========================================
echo Prueba del Monitor de Salud Mejorado
echo ========================================
echo.

echo [1/2] Ejecutando Monitor Basico...
echo.
powershell -ExecutionPolicy Bypass -File "src/backend/scripts/health-monitor.ps1"

echo.
echo ========================================
echo.
echo [2/2] Ejecutando Verificacion Avanzada...
echo.
powershell -ExecutionPolicy Bypass -File "src/backend/scripts/advanced-health-check.ps1"

echo.
echo ========================================
echo Prueba completada!
echo.
echo NOTA: Para mejor acceso a datos, ejecuta como Administrador
echo.
pause
