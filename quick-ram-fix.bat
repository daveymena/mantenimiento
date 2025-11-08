@echo off
echo ========================================
echo Solucion Rapida de RAM
echo ========================================
echo.

cd /d "%~dp0"

echo Tu RAM esta al 86.7%% (solo 1.82 GB libres)
echo.
echo Este script liberara RAM agresivamente
echo.
echo ADVERTENCIA: Cerrara aplicaciones no criticas
echo.
pause

echo.
echo [1/3] Limpiando memoria agresivamente...
powershell -ExecutionPolicy Bypass -File src\backend\scripts\aggressive-memory-cleaner.ps1 -DryRun false

echo.
echo [2/3] Cerrando procesos pesados...
powershell -ExecutionPolicy Bypass -File src\backend\scripts\process-killer.ps1 -DryRun false -MinMemoryMB 300

echo.
echo [3/3] Verificando resultado...
powershell -Command "Get-CimInstance Win32_OperatingSystem | Select-Object @{Name='RAM Libre (GB)';Expression={[math]::Round($_.FreePhysicalMemory/1MB,2)}}, @{Name='RAM Total (GB)';Expression={[math]::Round($_.TotalVisibleMemorySize/1MB,2)}}"

echo.
echo ========================================
echo Limpieza completada
echo ========================================
echo.
echo Si aun tienes problemas:
echo 1. Cierra navegadores con muchas pestañas
echo 2. Reinicia el sistema
echo 3. Considera agregar mas RAM
echo.

pause
