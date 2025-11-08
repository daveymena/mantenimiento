@echo off
echo ========================================
echo Iniciando Servidor de IA
echo ========================================
echo.

cd /d "%~dp0"

REM Verificar si Python está instalado
python --version >nul 2>&1
if errorlevel 1 (
    echo Error: Python no esta instalado
    echo Descarga Python desde: https://www.python.org/
    pause
    exit /b 1
)

REM Instalar dependencias si es necesario
if not exist "venv\" (
    echo Creando entorno virtual...
    python -m venv venv
    call venv\Scripts\activate.bat
    echo Instalando dependencias...
    pip install -r requirements.txt
) else (
    call venv\Scripts\activate.bat
)

echo.
echo Iniciando servidor de IA en http://localhost:5000
echo.

cd src\ai
python ai_server.py

pause
