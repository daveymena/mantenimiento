@echo off
echo ========================================
echo  Creador de Icono para la Aplicación
echo ========================================
echo.

if not exist "build" mkdir build

echo Este script te ayudará a crear el icono de la aplicación.
echo.
echo Opciones:
echo 1. Usar un archivo PNG existente
echo 2. Descargar un icono de ejemplo
echo 3. Crear icono básico con PowerShell
echo.

set /p opcion="Elige una opción (1-3): "

if "%opcion%"=="1" goto usar_png
if "%opcion%"=="2" goto descargar
if "%opcion%"=="3" goto crear_basico

echo Opción inválida
pause
exit /b 1

:usar_png
echo.
echo Arrastra tu archivo PNG aquí y presiona Enter:
set /p png_path=
if not exist %png_path% (
    echo ERROR: Archivo no encontrado
    pause
    exit /b 1
)
echo.
echo Para convertir PNG a ICO, usa una herramienta online:
echo - https://convertio.co/es/png-ico/
echo - https://www.icoconverter.com/
echo.
echo Después guarda el archivo como: build\icon.ico
echo.
pause
exit /b 0

:descargar
echo.
echo Descargando icono de ejemplo...
powershell -Command "& {Invoke-WebRequest -Uri 'https://raw.githubusercontent.com/electron/electron/main/shell/browser/resources/win/electron.ico' -OutFile 'build\icon.ico'}"
if %ERRORLEVEL% EQU 0 (
    echo ¡Icono descargado exitosamente!
    echo Ubicación: build\icon.ico
) else (
    echo ERROR: No se pudo descargar el icono
    echo Usa la opción 1 o 3
)
pause
exit /b 0

:crear_basico
echo.
echo Creando icono básico...
powershell -Command "& {Add-Type -AssemblyName System.Drawing; $bmp = New-Object System.Drawing.Bitmap(256, 256); $g = [System.Drawing.Graphics]::FromImage($bmp); $g.Clear([System.Drawing.Color]::Blue); $font = New-Object System.Drawing.Font('Arial', 72, [System.Drawing.FontStyle]::Bold); $brush = New-Object System.Drawing.SolidBrush([System.Drawing.Color]::White); $g.DrawString('PC', $font, $brush, 50, 80); $g.Dispose(); $bmp.Save('build\icon.png', [System.Drawing.Imaging.ImageFormat]::Png); $bmp.Dispose()}"
echo.
echo Icono básico creado: build\icon.png
echo.
echo NOTA: Necesitas convertir PNG a ICO usando:
echo - https://convertio.co/es/png-ico/
echo.
echo Después guarda como: build\icon.ico
pause
exit /b 0
