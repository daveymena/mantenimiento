@echo off
echo ========================================
echo Prueba de Correcciones Aplicadas
echo ========================================
echo.

echo [1/2] Probando Optimizador de Gaming (Dry Run)...
echo.
powershell -ExecutionPolicy Bypass -File "src/backend/scripts/gaming-optimizer.ps1" -DryRun "true"

echo.
echo ========================================
echo.

echo [2/2] Probando Gestor de Drivers (list)...
echo.
powershell -ExecutionPolicy Bypass -File "src/backend/scripts/driver-manager.ps1" -Action "list"

echo.
echo ========================================
echo Prueba completada!
echo.
echo NOTA: Para probar el optimizador de gaming en modo real,
echo       ejecuta como Administrador y usa -DryRun "false"
echo.
pause
