@echo off
echo ========================================
echo Detectando Modelos Disponibles en Groq
echo ========================================
echo.

cd /d "%~dp0"

REM Activar entorno virtual si existe
if exist "venv\Scripts\activate.bat" (
    call venv\Scripts\activate.bat
)

cd src\ai
python auto_detect_models.py

cd ..\..

echo.
pause
