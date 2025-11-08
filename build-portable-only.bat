@echo off
echo ========================================
echo  Construyendo Versión Portable
echo ========================================
echo.

REM Verificar Node.js
where node >nul 2>nul
if %ERRORLEVEL% NEQ 0 (
    echo ERROR: Node.js no está instalado
    pause
    exit /b 1
)

echo [1/3] Verificando dependencias...
if not exist "node_modules" (
    call npm install
)

echo.
echo [2/3] Instalando electron-builder...
call npm install --save-dev electron-builder

echo.
echo [3/3] Construyendo versión portable...
call npm run build:portable

if %ERRORLEVEL% EQU 0 (
    echo.
    echo ========================================
    echo  BUILD COMPLETADO
    echo ========================================
    echo.
    echo Archivo generado: dist\PC-Maintenance-Optimizer-Portable.exe
    echo.
    echo Este archivo es completamente portable y no requiere instalación.
    echo Puedes copiarlo a cualquier PC con Windows y ejecutarlo directamente.
    echo.
    pause
    explorer dist
) else (
    echo.
    echo ERROR: Fallo al construir la versión portable
    pause
)
