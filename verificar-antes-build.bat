@echo off
echo ========================================
echo  Verificación Pre-Build
echo ========================================
echo.

set ERROR_COUNT=0

REM Verificar Node.js
echo [1/8] Verificando Node.js...
where node >nul 2>nul
if %ERRORLEVEL% NEQ 0 (
    echo [X] ERROR: Node.js no está instalado
    echo     Descarga desde: https://nodejs.org/
    set /a ERROR_COUNT+=1
) else (
    node --version
    echo [OK] Node.js encontrado
)
echo.

REM Verificar npm
echo [2/8] Verificando npm...
where npm >nul 2>nul
if %ERRORLEVEL% NEQ 0 (
    echo [X] ERROR: npm no está instalado
    set /a ERROR_COUNT+=1
) else (
    npm --version
    echo [OK] npm encontrado
)
echo.

REM Verificar package.json
echo [3/8] Verificando package.json...
if not exist "package.json" (
    echo [X] ERROR: package.json no encontrado
    set /a ERROR_COUNT+=1
) else (
    echo [OK] package.json encontrado
)
echo.

REM Verificar src/main.js
echo [4/8] Verificando src/main.js...
if not exist "src\main.js" (
    echo [X] ERROR: src\main.js no encontrado
    set /a ERROR_COUNT+=1
) else (
    echo [OK] src\main.js encontrado
)
echo.

REM Verificar src/preload.js
echo [5/8] Verificando src/preload.js...
if not exist "src\preload.js" (
    echo [X] ERROR: src\preload.js no encontrado
    set /a ERROR_COUNT+=1
) else (
    echo [OK] src\preload.js encontrado
)
echo.

REM Verificar src/ui/index.html
echo [6/8] Verificando src/ui/index.html...
if not exist "src\ui\index.html" (
    echo [X] ERROR: src\ui\index.html no encontrado
    set /a ERROR_COUNT+=1
) else (
    echo [OK] src\ui\index.html encontrado
)
echo.

REM Verificar carpeta build
echo [7/8] Verificando carpeta build...
if not exist "build" (
    echo [!] ADVERTENCIA: Carpeta build no existe, creando...
    mkdir build
)
echo [OK] Carpeta build lista
echo.

REM Verificar icono
echo [8/8] Verificando icono...
if not exist "build\icon.ico" (
    echo [!] ADVERTENCIA: build\icon.ico no encontrado
    echo     La aplicación usará el icono por defecto de Electron
    echo     Ejecuta crear-icono.bat para crear uno personalizado
) else (
    echo [OK] Icono encontrado
)
echo.

REM Resumen
echo ========================================
echo  RESUMEN
echo ========================================
if %ERROR_COUNT% EQU 0 (
    echo [OK] Todo listo para construir
    echo.
    echo Puedes ejecutar:
    echo - build-installer.bat (instalador + portable)
    echo - build-portable-only.bat (solo portable)
    echo.
) else (
    echo [X] Se encontraron %ERROR_COUNT% errores
    echo     Corrige los errores antes de continuar
    echo.
)

pause
