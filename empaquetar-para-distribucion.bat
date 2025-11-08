@echo off
echo ========================================
echo  Empaquetador Final de Distribución
echo ========================================
echo.

REM Verificar que existan los ejecutables
if not exist "dist\PC-Maintenance-Optimizer-Setup-2.0.0.exe" (
    echo ERROR: No se encontró el instalador
    echo Ejecuta primero: build-installer.bat
    pause
    exit /b 1
)

if not exist "dist\PC-Maintenance-Optimizer-Portable.exe" (
    echo ERROR: No se encontró la versión portable
    echo Ejecuta primero: build-installer.bat
    pause
    exit /b 1
)

echo [1/5] Creando carpeta de distribución...
if exist "distribucion" rmdir /s /q distribucion
mkdir distribucion
mkdir distribucion\Instalador
mkdir distribucion\Portable
mkdir distribucion\Documentacion

echo.
echo [2/5] Copiando ejecutables...
copy "dist\PC-Maintenance-Optimizer-Setup-2.0.0.exe" "distribucion\Instalador\" >nul
copy "dist\PC-Maintenance-Optimizer-Portable.exe" "distribucion\Portable\" >nul

echo.
echo [3/5] Copiando documentación...
copy "INSTRUCCIONES_USUARIO_FINAL.md" "distribucion\Documentacion\INSTRUCCIONES.md" >nul
copy "README.md" "distribucion\Documentacion\" >nul
copy "LICENSE" "distribucion\Documentacion\" >nul
copy "CHANGELOG.md" "distribucion\Documentacion\" >nul 2>nul

echo.
echo [4/5] Creando archivos README...

REM README para instalador
(
echo ========================================
echo  PC Maintenance Optimizer - Instalador
echo ========================================
echo.
echo INSTRUCCIONES:
echo.
echo 1. Ejecutar PC-Maintenance-Optimizer-Setup-2.0.0.exe
echo 2. Hacer clic derecho ^> "Ejecutar como administrador"
echo 3. Seguir el asistente de instalación
echo 4. Lanzar desde el acceso directo del escritorio
echo.
echo REQUISITOS:
echo - Windows 10/11 ^(64-bit^)
echo - Permisos de administrador
echo.
echo TAMAÑO: ~80 MB
echo.
echo Para más información, consulta:
echo Documentacion\INSTRUCCIONES.md
echo.
) > "distribucion\Instalador\LEEME.txt"

REM README para portable
(
echo ========================================
echo  PC Maintenance Optimizer - Portable
echo ========================================
echo.
echo INSTRUCCIONES:
echo.
echo 1. Copiar PC-Maintenance-Optimizer-Portable.exe a cualquier ubicación
echo 2. Hacer clic derecho ^> "Ejecutar como administrador"
echo 3. ¡Listo! No requiere instalación
echo.
echo VENTAJAS:
echo - No requiere instalación
echo - Funciona desde USB
echo - No deja rastros en el sistema
echo - Portable entre PCs
echo.
echo REQUISITOS:
echo - Windows 10/11 ^(64-bit^)
echo - Permisos de administrador
echo.
echo TAMAÑO: ~150 MB
echo.
echo Para más información, consulta:
echo ..\Documentacion\INSTRUCCIONES.md
echo.
) > "distribucion\Portable\LEEME.txt"

REM README principal
(
echo ========================================
echo  PC Maintenance Optimizer v2.0.0
echo ========================================
echo.
echo Aplicación de mantenimiento y optimización para Windows
echo.
echo CONTENIDO:
echo.
echo 1. Instalador\
echo    - PC-Maintenance-Optimizer-Setup-2.0.0.exe
echo    - Instalador completo con asistente
echo    - Recomendado para uso permanente
echo.
echo 2. Portable\
echo    - PC-Maintenance-Optimizer-Portable.exe
echo    - Versión portable sin instalación
echo    - Ideal para USB o uso temporal
echo.
echo 3. Documentacion\
echo    - INSTRUCCIONES.md - Guía completa del usuario
echo    - README.md - Información del proyecto
echo    - LICENSE - Licencia MIT
echo    - CHANGELOG.md - Historial de cambios
echo.
echo ELIGE TU VERSIÓN:
echo.
echo ¿Primera vez o uso permanente?
echo   ^> Usa el INSTALADOR
echo.
echo ¿Uso temporal o múltiples PCs?
echo   ^> Usa la versión PORTABLE
echo.
echo REQUISITOS:
echo - Windows 10 o 11 ^(64-bit^)
echo - 4 GB RAM mínimo
echo - 500 MB espacio en disco
echo - Permisos de administrador
echo.
echo CARACTERÍSTICAS:
echo - Limpieza de archivos temporales
echo - Optimización de RAM
echo - Análisis de seguridad
echo - Monitor de salud del sistema
echo - Optimización de privacidad
echo - Modo gaming
echo - Actualizador de drivers
echo - Sistema de respaldo
echo.
echo SOPORTE:
echo - Consulta Documentacion\INSTRUCCIONES.md
echo - Reporta problemas en GitHub
echo.
echo ¡Gracias por usar PC Maintenance Optimizer!
echo.
echo Versión: 2.0.0
echo Fecha: 2025
echo Licencia: MIT
echo.
) > "distribucion\LEEME.txt"

echo.
echo [5/5] Creando archivo ZIP...
powershell -Command "& {Compress-Archive -Path 'distribucion\*' -DestinationPath 'PC-Maintenance-Optimizer-v2.0.0-Windows.zip' -Force}"

if %ERRORLEVEL% EQU 0 (
    echo.
    echo ========================================
    echo  EMPAQUETADO COMPLETADO
    echo ========================================
    echo.
    echo Archivos generados:
    echo.
    echo 1. Carpeta "distribucion\" con:
    echo    - Instalador/
    echo    - Portable/
    echo    - Documentacion/
    echo    - LEEME.txt
    echo.
    echo 2. PC-Maintenance-Optimizer-v2.0.0-Windows.zip
    echo    - Archivo ZIP listo para distribuir
    echo    - Tamaño: ~150 MB
    echo.
    echo ========================================
    echo  LISTO PARA DISTRIBUIR
    echo ========================================
    echo.
    echo Puedes compartir:
    echo - El archivo ZIP completo, o
    echo - Solo el instalador, o
    echo - Solo la versión portable
    echo.
    echo Presiona cualquier tecla para abrir la carpeta...
    pause >nul
    explorer .
) else (
    echo.
    echo ERROR: No se pudo crear el archivo ZIP
    echo Pero la carpeta "distribucion\" está lista
    pause
)
