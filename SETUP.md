# 🛠️ Setup Completo

## Instalación Automática

### Windows (Recomendado)

1. **Descargar e instalar Node.js**
   - Ve a: https://nodejs.org/
   - Descarga la versión LTS (Long Term Support)
   - Ejecuta el instalador
   - Marca "Add to PATH" durante la instalación

2. **Verificar instalación**
   ```cmd
   node --version
   npm --version
   ```

3. **Clonar o descargar el proyecto**
   ```cmd
   git clone https://github.com/tu-usuario/pc-maintenance-optimizer.git
   cd pc-maintenance-optimizer
   ```

4. **Instalar dependencias**
   ```cmd
   npm install
   ```

5. **Ejecutar**
   - Opción A: Doble clic en `run-as-admin.bat` (clic derecho → Ejecutar como administrador)
   - Opción B: CMD como admin → `npm start`

## Instalación Manual

### 1. Node.js

**Verificar si ya está instalado**:
```cmd
node --version
```

Si no está instalado:
1. Descarga desde https://nodejs.org/
2. Instala (versión LTS recomendada)
3. Reinicia CMD

### 2. Dependencias del Proyecto

```cmd
cd pc-maintenance-optimizer
npm install
```

Esto instalará:
- `electron@^27.0.0` - Framework de la aplicación
- `node-powershell@^5.0.1` - Para ejecutar scripts PowerShell

### 3. Configurar PowerShell

Si obtienes error "No se puede ejecutar scripts":

```powershell
# Abre PowerShell como Administrador
Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope CurrentUser
```

### 4. Habilitar System Protection (Opcional pero recomendado)

Para que funcionen los Restore Points:

1. Presiona `Win + Pause` o busca "Sistema"
2. Clic en "Protección del sistema"
3. Selecciona tu disco C:
4. Clic en "Configurar"
5. Marca "Activar protección del sistema"
6. Ajusta el espacio (5-10% recomendado)
7. Clic en "Aceptar"

## Verificación de Instalación

### Test Rápido

```cmd
# 1. Verificar Node.js
node --version
npm --version

# 2. Verificar dependencias
npm list --depth=0

# 3. Iniciar app
npm start
```

### Test de Scripts PowerShell

```powershell
# Test de escaneo (dry run)
powershell -ExecutionPolicy Bypass -File src\backend\scripts\scan-system.ps1 -DryRun $true
```

Si ves output sin errores, ¡todo está bien!

## Solución de Problemas

### Error: "node no se reconoce"

**Causa**: Node.js no está en el PATH

**Solución**:
1. Reinstala Node.js
2. Marca "Add to PATH" durante instalación
3. Reinicia CMD/PowerShell

### Error: "Cannot find module 'electron'"

**Causa**: Dependencias no instaladas

**Solución**:
```cmd
npm install
```

### Error: "No se puede ejecutar scripts"

**Causa**: ExecutionPolicy de PowerShell

**Solución**:
```powershell
Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope CurrentUser
```

### Error: "Access Denied"

**Causa**: Sin permisos de administrador

**Solución**:
- Ejecuta CMD como Administrador
- O usa `run-as-admin.bat` con clic derecho → Ejecutar como administrador

### Error: "ENOENT: no such file or directory"

**Causa**: Ruta incorrecta

**Solución**:
```cmd
cd C:\ruta\al\proyecto\pc-maintenance-optimizer
npm start
```

## Configuración Avanzada

### Cambiar Puerto (si aplica en futuras versiones)

Edita `config.json`:
```json
{
  "port": 3000
}
```

### Personalizar Blacklist de Servicios

Edita `config.json`:
```json
{
  "optimization": {
    "services": {
      "blacklist": [
        "wuauserv",
        "WinDefend",
        "MiServicioPersonalizado"
      ]
    }
  }
}
```

### Cambiar Ubicación de Logs

Edita `config.json`:
```json
{
  "logging": {
    "path": "C:\\MisLogs"
  }
}
```

## Actualización

### Actualizar Dependencias

```cmd
npm update
```

### Actualizar a Nueva Versión

```cmd
git pull origin main
npm install
npm start
```

## Desinstalación

### Completa

```cmd
# 1. Eliminar tarea programada (si existe)
powershell -ExecutionPolicy Bypass -File src\backend\scripts\scheduler.ps1 -Action remove

# 2. Eliminar carpeta
cd ..
rmdir /s /q pc-maintenance-optimizer
```

### Solo Dependencias

```cmd
rmdir /s /q node_modules
```

## Instalación en Múltiples PCs

### Opción 1: Clonar en cada PC

```cmd
git clone https://github.com/tu-usuario/pc-maintenance-optimizer.git
cd pc-maintenance-optimizer
npm install
```

### Opción 2: Copiar carpeta (sin node_modules)

1. Copia la carpeta del proyecto (sin `node_modules`)
2. En cada PC:
```cmd
cd pc-maintenance-optimizer
npm install
```

### Opción 3: Compilar ejecutable (futuro)

```cmd
npm install --save-dev electron-builder
npm run build
```

Distribuye el `.exe` de la carpeta `dist/`

## Requisitos del Sistema

### Mínimos
- Windows 10 (1809+) o Windows 11
- 2 GB RAM
- 500 MB espacio en disco
- Node.js 16+

### Recomendados
- Windows 11
- 4 GB RAM
- 1 GB espacio en disco
- Node.js 18+ LTS
- SSD

## Configuración de Desarrollo

### VS Code

1. Instala VS Code: https://code.visualstudio.com/
2. Abre la carpeta del proyecto
3. Instala extensiones recomendadas (VS Code te lo sugerirá)
4. F5 para debug

### Extensiones Recomendadas

- PowerShell (ms-vscode.powershell)
- ESLint (dbaeumer.vscode-eslint)
- Prettier (esbenp.prettier-vscode)

## Próximos Pasos

1. Lee [QUICKSTART.md](QUICKSTART.md) para uso básico
2. Revisa [README.md](README.md) para características completas
3. Consulta [FAQ.md](docs/FAQ.md) para preguntas comunes
4. Explora [API.md](docs/API.md) para desarrollo

---

**¿Problemas con la instalación?** Abre un issue en GitHub con:
- Versión de Windows
- Versión de Node.js
- Mensaje de error completo
- Logs relevantes
