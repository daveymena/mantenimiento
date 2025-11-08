@echo off
title PC Maintenance Optimizer - Constructor Completo
color 0A

echo.
echo  ╔════════════════════════════════════════════════════════════╗
echo  ║                                                            ║
echo  ║     PC MAINTENANCE OPTIMIZER - CONSTRUCTOR COMPLETO        ║
echo  ║                                                            ║
echo  ║     Este script construirá todo automáticamente:          ║
echo  ║     1. Verificará requisitos                              ║
echo  ║     2. Instalará dependencias                             ║
echo  ║     3. Construirá instalador y portable                   ║
echo  ║     4. Empaquetará para distribución                      ║
echo  ║                                                            ║
echo  ╚════════════════════════════════════════════════════════════╝
echo.
echo  Tiempo estimado: 10-15 minutos
echo  Espacio necesario: ~1 GB
echo.
pause

cls
echo ========================================
echo  PASO 1/5: VERIFICACIÓN DE REQUISITOS
echo ========================================
echo.

REM Verificar Node.js
where node >nul 2>nul
if %ERRORLEVEL% NEQ 0 (
    echo [X] ERROR: Node.js no está instalado
    echo.
    echo Por favor instala Node.js desde:
    echo https://nodejs.org/
    echo.
    echo Después ejecuta este script nuevamente.
    pause
    exit /b 1
)

echo [OK] Node.js encontrado
node --version
echo.

REM Verificar npm
where npm >nul 2>nul
if %ERRORLEVEL% NEQ 0 (
    echo [X] ERROR: npm no está instalado
    pause
    exit /b 1
)

echo [OK] npm encontrado
npm --version
echo.

REM Verificar archivos principales
if not exist "package.json" (
    echo [X] ERROR: package.json no encontrado
    pause
    exit /b 1
)
echo [OK] package.json encontrado

if not exist "src\main.js" (
    echo [X] ERROR: src\main.js no encontrado
    pause
    exit /b 1
)
echo [OK] src\main.js encontrado

echo.
echo [OK] Todos los requisitos cumplidos
timeout /t 3 >nul

cls
echo ========================================
echo  PASO 2/5: INSTALACIÓN DE DEPENDENCIAS
echo ========================================
echo.

if not exist "node_modules" (
    echo Instalando dependencias por primera vez...
    echo Esto puede tardar varios minutos...
    echo.
    call npm install
    if %ERRORLEVEL% NEQ 0 (
        echo.
        echo [X] ERROR: Fallo al instalar dependencias
        pause
        exit /b 1
    )
) else (
    echo Dependencias ya instaladas, verificando...
    call npm install
)

echo.
echo Instalando electron-builder...
call npm install --save-dev electron-builder
if %ERRORLEVEL% NEQ 0 (
    echo.
    echo [X] ERROR: Fallo al instalar electron-builder
    pause
    exit /b 1
)

echo.
echo [OK] Dependencias instaladas correctamente
timeout /t 2 >nul

cls
echo ========================================
echo  PASO 3/5: VERIFICACIÓN DE ICONO
echo ========================================
echo.

if not exist "build" mkdir build

if not exist "build\icon.ico" (
    echo [!] ADVERTENCIA: No se encontró build\icon.ico
    echo.
    echo La aplicación usará el icono por defecto de Electron.
    echo.
    echo ¿Deseas crear un icono personalizado ahora?
    echo 1. Sí, crear icono básico
    echo 2. No, usar icono por defecto
    echo.
    set /p icono_opcion="Elige opción (1-2): "
    
    if "!icono_opcion!"=="1" (
        echo.
        echo Creando icono básico...
        REM Aquí podrías llamar a crear-icono.bat si lo deseas
        echo [!] Usa crear-icono.bat después para personalizar
    )
) else (
    echo [OK] Icono encontrado: build\icon.ico
)

echo.
timeout /t 2 >nul

cls
echo ========================================
echo  PASO 4/5: CONSTRUCCIÓN DE EJECUTABLES
echo ========================================
echo.
echo Este paso puede tardar 5-10 minutos...
echo Por favor, no cierres esta ventana.
echo.

REM Limpiar dist anterior
if exist "dist" (
    echo Limpiando builds anteriores...
    rmdir /s /q dist
)

echo.
echo [1/2] Construyendo instalador NSIS...
call npm run build:win
if %ERRORLEVEL% NEQ 0 (
    echo.
    echo [X] ERROR: Fallo al construir el instalador
    echo.
    echo Revisa los errores arriba y ejecuta:
    echo npm run build:win
    echo.
    pause
    exit /b 1
)

echo.
echo [2/2] Construyendo versión portable...
call npm run build:portable
if %ERRORLEVEL% NEQ 0 (
    echo.
    echo [!] ADVERTENCIA: Fallo al construir la versión portable
    echo Pero el instalador se construyó correctamente.
    echo.
)

echo.
echo [OK] Ejecutables construidos correctamente
timeout /t 2 >nul

cls
echo ========================================
echo  PASO 5/5: EMPAQUETADO PARA DISTRIBUCIÓN
echo ========================================
echo.

REM Verificar que existan los ejecutables
if not exist "dist\PC-Maintenance-Optimizer-Setup-2.0.0.exe" (
    echo [X] ERROR: No se encontró el instalador
    pause
    exit /b 1
)

echo Creando paquete de distribución...
echo.

REM Crear carpeta de distribución
if exist "distribucion" rmdir /s /q distribucion
mkdir distribucion
mkdir distribucion\Instalador
mkdir distribucion\Portable
mkdir distribucion\Documentacion

REM Copiar ejecutables
copy "dist\PC-Maintenance-Optimizer-Setup-2.0.0.exe" "distribucion\Instalador\" >nul
if exist "dist\PC-Maintenance-Optimizer-Portable.exe" (
    copy "dist\PC-Maintenance-Optimizer-Portable.exe" "distribucion\Portable\" >nul
)

REM Copiar documentación
copy "INSTRUCCIONES_USUARIO_FINAL.md" "distribucion\Documentacion\INSTRUCCIONES.md" >nul
copy "README.md" "distribucion\Documentacion\" >nul 2>nul
copy "LICENSE" "distribucion\Documentacion\" >nul 2>nul
copy "CHANGELOG.md" "distribucion\Documentacion\" >nul 2>nul

REM Crear READMEs
call empaquetar-para-distribucion.bat >nul 2>nul

echo [OK] Paquete de distribución creado
echo.

cls
echo.
echo  ╔════════════════════════════════════════════════════════════╗
echo  ║                                                            ║
echo  ║                  ✓ BUILD COMPLETADO                        ║
echo  ║                                                            ║
echo  ╚════════════════════════════════════════════════════════════╝
echo.
echo  ARCHIVOS GENERADOS:
echo  ═══════════════════════════════════════════════════════════
echo.
echo  📁 dist/
echo     ├─ PC-Maintenance-Optimizer-Setup-2.0.0.exe  (~80 MB)
echo     └─ PC-Maintenance-Optimizer-Portable.exe     (~150 MB)
echo.
echo  📁 distribucion/
echo     ├─ Instalador/
echo     │  ├─ PC-Maintenance-Optimizer-Setup-2.0.0.exe
echo     │  └─ LEEME.txt
echo     ├─ Portable/
echo     │  ├─ PC-Maintenance-Optimizer-Portable.exe
echo     │  └─ LEEME.txt
echo     ├─ Documentacion/
echo     │  ├─ INSTRUCCIONES.md
echo     │  ├─ README.md
echo     │  └─ LICENSE
echo     └─ LEEME.txt
echo.
echo  📦 PC-Maintenance-Optimizer-v2.0.0-Windows.zip  (~150 MB)
echo.
echo  ═══════════════════════════════════════════════════════════
echo.
echo  SIGUIENTE PASO:
echo  ═══════════════════════════════════════════════════════════
echo.
echo  1. Probar los ejecutables en dist/
echo  2. Distribuir el archivo ZIP o la carpeta "distribucion/"
echo  3. Compartir con usuarios finales
echo.
echo  OPCIONES DE DISTRIBUCIÓN:
echo  ═══════════════════════════════════════════════════════════
echo.
echo  • GitHub Releases (recomendado)
echo  • Google Drive / OneDrive
echo  • Servidor web propio
echo  • USB / CD
echo.
echo  ═══════════════════════════════════════════════════════════
echo.
echo  ¡Gracias por usar PC Maintenance Optimizer Builder!
echo.
echo  Presiona cualquier tecla para abrir la carpeta de distribución...
pause >nul

explorer distribucion

echo.
echo ¿Deseas abrir también la carpeta dist?
set /p abrir_dist="(S/N): "
if /i "%abrir_dist%"=="S" explorer dist

echo.
echo ¡Proceso completado!
echo.
pause
