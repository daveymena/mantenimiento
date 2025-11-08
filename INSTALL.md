# 📦 Guía de Instalación

## Requisitos del Sistema

### Windows
- Windows 10 (versión 1809 o superior) o Windows 11
- Node.js v16.x o superior
- npm v7.x o superior
- PowerShell 5.1 o superior
- 4 GB RAM mínimo
- 500 MB espacio en disco

### Permisos
- Cuenta con privilegios de Administrador
- System Protection habilitado (para Restore Points)

## Instalación Paso a Paso

### 1. Instalar Node.js

Si no tienes Node.js instalado:

1. Descarga desde: https://nodejs.org/
2. Ejecuta el instalador
3. Verifica la instalación:

```cmd
node --version
npm --version
```

### 2. Descargar el Proyecto

Opción A - Con Git:
```cmd
git clone https://github.com/tu-usuario/pc-maintenance-optimizer.git
cd pc-maintenance-optimizer
```

Opción B - Descarga directa:
1. Descarga el ZIP del proyecto
2. Extrae en una carpeta
3. Abre CMD en esa carpeta

### 3. Instalar Dependencias

```cmd
npm install
```

Esto instalará:
- Electron (framework de la app)
- node-powershell (para ejecutar scripts)

### 4. Verificar Instalación

```cmd
npm start
```

Si todo está correcto, se abrirá la aplicación.

## Habilitar System Protection

Para que funcionen los Restore Points:

1. Presiona `Win + Pause` o busca "Sistema"
2. Clic en "Protección del sistema"
3. Selecciona tu disco C:
4. Clic en "Configurar"
5. Marca "Activar protección del sistema"
6. Ajusta el espacio (recomendado: 5-10%)
7. Clic en "Aceptar"

## Ejecutar como Administrador

### Método 1 - Desde CMD
```cmd
# Abre CMD como Administrador (clic derecho > Ejecutar como administrador)
cd ruta\al\proyecto
npm start
```

### Método 2 - Crear Acceso Directo
1. Crea un archivo `run-as-admin.bat`:
```batch
@echo off
cd /d "%~dp0"
npm start
pause
```
2. Clic derecho > Propiedades > Avanzadas
3. Marca "Ejecutar como administrador"

## Solución de Problemas

### Error: "No se puede ejecutar scripts"

Si PowerShell bloquea la ejecución:

```powershell
# Abre PowerShell como Administrador
Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope CurrentUser
```

### Error: "node no se reconoce"

Node.js no está en el PATH:
1. Reinstala Node.js
2. Marca la opción "Add to PATH"
3. Reinicia CMD

### Error: "Cannot find module 'electron'"

```cmd
npm install
```

### La app no tiene permisos

Asegúrate de ejecutar CMD como Administrador antes de `npm start`

### Restore Points no funcionan

1. Verifica que System Protection esté habilitado
2. Asegúrate de tener espacio en disco
3. Revisa los logs en la carpeta `logs/`

## Desinstalación

```cmd
# Elimina la carpeta del proyecto
rmdir /s /q pc-maintenance-optimizer

# Opcional: limpia cache de npm
npm cache clean --force
```

## Actualización

```cmd
cd pc-maintenance-optimizer
git pull
npm install
npm start
```

## Compilar Ejecutable (Opcional)

Para crear un .exe distribuible:

1. Instala electron-builder:
```cmd
npm install --save-dev electron-builder
```

2. Agrega a `package.json`:
```json
"scripts": {
  "build": "electron-builder"
},
"build": {
  "appId": "com.pcmaintenance.optimizer",
  "win": {
    "target": "nsis",
    "icon": "src/assets/icon.ico"
  }
}
```

3. Compila:
```cmd
npm run build
```

El ejecutable estará en `dist/`

## Soporte

Si tienes problemas:
1. Revisa los logs en `logs/`
2. Verifica los requisitos del sistema
3. Consulta SECURITY.md para configuración
4. Abre un issue en GitHub
