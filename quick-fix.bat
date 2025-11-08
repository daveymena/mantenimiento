@echo off
echo ========================================
echo Solucion Rapida de Problemas
echo ========================================
echo.

cd /d "%~dp0"

echo [1/4] Actualizando pip...
python -m pip install --upgrade pip --quiet

echo [2/4] Instalando dependencias Python...
pip install --upgrade psutil flask flask-cors requests openai httpx --quiet

echo [3/4] Verificando Node.js...
npm install --silent

echo [4/4] Probando keys de Groq...
cd src\ai
python -c "from groq_config import groq_key_manager; print(f'Keys disponibles: {len(groq_key_manager.api_keys)}')"
cd ..\..

echo.
echo ========================================
echo Solucion completada
echo ========================================
echo.
echo Ahora puedes ejecutar:
echo   1. .\start-ai-server.bat  (en PowerShell)
echo   2. npm start              (en otra terminal)
echo.

pause
