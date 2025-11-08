@echo off
echo ========================================
echo  PC Maintenance Optimizer - Builder
echo ========================================
echo.

REM Verificar si Node.js está instalado
where node >nul 2>nul
if %ERRORLEVEL% NEQ 0 (
    echo ERROR: Node.js no está instalado
    echo Por favor instala Node.js desde https://nodejs.org/
    pause
    exit /b 1
)

echo [1/5] Verificando dependencias...
if not exist "node_modules" (
    echo Instalando dependencias...
    call npm install
    if %ERRORLEVEL% NEQ 0 (
        echo ERROR: Fallo al instalar dependencias
        pause
        exit /b 1
    )
)

echo.
echo [2/5] Instalando electron-builder...
call npm install --save-dev electron-builder
if %ERRORLEVEL% NEQ 0 (
    echo ERROR: Fallo al instalar electron-builder
    pause
    exit /b 1
)

echo.
echo [3/5] Creando icono de la aplicación...
if not exist "build" mkdir build
if not exist "build\icon.ico" (
    echo Nota: No se encontró icon.ico, se usará el icono por defecto
)

echo.
echo [4/5] Construyendo instalador NSIS...
call npm run build:win
if %ERRORLEVEL% NEQ 0 (
    echo ERROR: Fallo al construir el instalador
    pause
    exit /b 1
)

echo.
echo [5/5] Construyendo versión portable...
call npm run build:portable
if %ERRORLEVEL% NEQ 0 (
    echo ADVERTENCIA: Fallo al construir la versión portable
)

echo.
echo ========================================
echo  BUILD COMPLETADO
echo ========================================
echo.
echo Los archivos generados están en la carpeta "dist":
echo - Instalador: PC-Maintenance-Optimizer-Setup-*.exe
echo - Portable: PC-Maintenance-Optimizer-Portable.exe
echo.
echo Presiona cualquier tecla para abrir la carpeta dist...
pause >nul
explorer dist
