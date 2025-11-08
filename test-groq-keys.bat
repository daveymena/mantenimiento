@echo off
echo ========================================
echo Probando API Keys de Groq
echo ========================================
echo.

cd /d "%~dp0"

REM Activar entorno virtual si existe
if exist "venv\Scripts\activate.bat" (
    call venv\Scripts\activate.bat
)

cd src\ai
python test_groq.py

pause
