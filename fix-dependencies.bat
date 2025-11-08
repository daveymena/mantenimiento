@echo off
echo ========================================
echo Solucionando Conflictos de Dependencias
echo ========================================
echo.

cd /d "%~dp0"

echo Actualizando pip...
python -m pip install --upgrade pip

echo.
echo Instalando dependencias con --upgrade...
pip install --upgrade -r requirements.txt

echo.
echo Verificando instalacion...
pip list | findstr "psutil flask requests openai"

echo.
echo ========================================
echo Dependencias actualizadas
echo ========================================
echo.
echo Si aun hay conflictos, son de otros paquetes
echo y no afectaran esta aplicacion.
echo.

pause
