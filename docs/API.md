# 📡 API Documentation

## Frontend API (window.api)

Estas son las APIs expuestas al renderer process a través del preload script.

### scanSystem()

Escanea el sistema y recopila información sobre temporales, inicio, servicios y memoria.

**Uso**:
```javascript
const result = await window.api.scanSystem();
```

**Retorna**:
```javascript
{
  success: boolean,
  output: string,      // Output del script
  error: string,       // Errores si los hay
  logFile: string      // Ruta al archivo de log
}
```

**Output JSON** (parseado de output):
```javascript
{
  tempSize: number,           // MB de archivos temporales
  startupAppsCount: number,   // Cantidad de apps en inicio
  startupApps: Array,         // Lista de apps
  servicesCount: number,      // Servicios activos
  services: Array,            // Lista de servicios
  freeMemory: number,         // MB de memoria libre
  totalMemory: number         // MB de memoria total
}
```

---

### optimizeSystem(options)

Ejecuta optimizaciones del sistema según las opciones especificadas.

**Parámetros**:
```javascript
{
  dryRun: boolean,           // true = simulación, false = real
  cleanTemp: boolean,        // Limpiar temporales
  optimizeStartup: boolean,  // Optimizar inicio
  optimizeServices: boolean, // Optimizar servicios
  freeMemory: boolean        // Liberar memoria
}
```

**Uso**:
```javascript
const options = {
  dryRun: false,
  cleanTemp: true,
  optimizeStartup: false,
  optimizeServices: true,
  freeMemory: true
};

const result = await window.api.optimizeSystem(options);
```

**Retorna**:
```javascript
{
  success: boolean,
  output: string,
  error: string,
  logFile: string
}
```

---

### createRestorePoint()

Crea un punto de restauración del sistema.

**Uso**:
```javascript
const result = await window.api.createRestorePoint();
```

**Retorna**:
```javascript
{
  success: boolean,
  output: string,
  error: string,
  logFile: string
}
```

**Nota**: Requiere que System Protection esté habilitado.

---

### getLogs()

Obtiene la lista de logs recientes.

**Uso**:
```javascript
const result = await window.api.getLogs();
```

**Retorna**:
```javascript
{
  success: boolean,
  output: string,      // Lista de archivos de log
  error: string,
  logFile: string
}
```

---

## Backend API (executor.js)

### executeScript(action, dryRun, options)

Ejecuta un script PowerShell específico.

**Parámetros**:
- `action` (string): Nombre de la acción ('scan', 'optimize', 'restore-point', 'get-logs')
- `dryRun` (boolean): Si es true, ejecuta en modo simulación
- `options` (object): Opciones específicas del script

**Retorna**: Promise<Object>
```javascript
{
  success: boolean,
  output: string,
  error: string,
  logFile: string
}
```

**Ejemplo**:
```javascript
const { executeScript } = require('./backend/executor');

const result = await executeScript('scan', false);
console.log(result.output);
```

---

## PowerShell Scripts API

### scan-system.ps1

**Parámetros**:
```powershell
-DryRun [bool] = $true
```

**Output**: JSON con información del sistema

**Ejemplo**:
```powershell
powershell -ExecutionPolicy Bypass -File scan-system.ps1 -DryRun $false
```

---

### optimize-system.ps1

**Parámetros**:
```powershell
-DryRun [bool] = $true
-CleanTemp [bool] = $false
-OptimizeStartup [bool] = $false
-OptimizeServices [bool] = $false
-FreeMemory [bool] = $false
```

**Ejemplo**:
```powershell
powershell -ExecutionPolicy Bypass -File optimize-system.ps1 `
  -DryRun $false `
  -CleanTemp $true `
  -FreeMemory $true
```

---

### create-restore-point.ps1

**Parámetros**:
```powershell
-DryRun [bool] = $true
```

**Ejemplo**:
```powershell
powershell -ExecutionPolicy Bypass -File create-restore-point.ps1 -DryRun $false
```

---

### browser-cleanup.ps1

**Parámetros**:
```powershell
-DryRun [bool] = $true
-Chrome [bool] = $true
-Firefox [bool] = $true
-Edge [bool] = $true
```

**Ejemplo**:
```powershell
powershell -ExecutionPolicy Bypass -File browser-cleanup.ps1 `
  -DryRun $false `
  -Chrome $true `
  -Edge $true
```

---

### disk-analyzer.ps1

**Parámetros**:
```powershell
-Drive [string] = "C:"
```

**Ejemplo**:
```powershell
powershell -ExecutionPolicy Bypass -File disk-analyzer.ps1 -Drive "D:"
```

---

### process-manager.ps1

**Parámetros**:
```powershell
-Action [string] = "list"  # list | cleanup
-DryRun [bool] = $true
```

**Ejemplo**:
```powershell
powershell -ExecutionPolicy Bypass -File process-manager.ps1 `
  -Action "cleanup" `
  -DryRun $false
```

---

### scheduler.ps1

**Parámetros**:
```powershell
-Action [string] = "list"      # list | create | remove
-Frequency [string] = "daily"  # daily | weekly | monthly
-Time [string] = "02:00"
```

**Ejemplo**:
```powershell
# Crear tarea diaria a las 2 AM
powershell -ExecutionPolicy Bypass -File scheduler.ps1 `
  -Action "create" `
  -Frequency "daily" `
  -Time "02:00"

# Listar tarea
powershell -ExecutionPolicy Bypass -File scheduler.ps1 -Action "list"

# Eliminar tarea
powershell -ExecutionPolicy Bypass -File scheduler.ps1 -Action "remove"
```

---

## IPC Channels

### Main → Renderer

No hay comunicación directa de Main a Renderer en esta versión.

### Renderer → Main

Todos los canales usan `ipcRenderer.invoke()`:

- `'scan-system'`
- `'optimize-system'`
- `'create-restore-point'`
- `'get-logs'`

---

## Error Handling

Todos los métodos retornan un objeto con:
- `success`: boolean indicando si la operación fue exitosa
- `error`: string con mensaje de error si `success` es false
- `output`: string con la salida del script
- `logFile`: ruta al archivo de log generado

**Ejemplo de manejo de errores**:
```javascript
try {
  const result = await window.api.scanSystem();
  
  if (result.success) {
    console.log('Éxito:', result.output);
  } else {
    console.error('Error:', result.error);
  }
} catch (error) {
  console.error('Excepción:', error.message);
}
```

---

## Logs

Todos los logs se guardan en `logs/` con formato:
```
{action}-{timestamp}.log
```

**Ejemplo**: `scan-2025-11-06T14-30-45-123Z.log`

**Contenido**:
```
Exit Code: 0

Output:
[salida del script]

Errors:
[errores si los hay]
```

---

## Extensión de la API

Para agregar nuevos endpoints:

1. **Crear script PowerShell** en `src/backend/scripts/`
2. **Agregar a scriptMap** en `executor.js`
3. **Agregar IPC handler** en `main.js`
4. **Exponer en preload** en `preload.js`
5. **Usar en renderer** en `renderer.js`

**Ejemplo completo**:

```javascript
// 1. executor.js
const scriptMap = {
  'nuevo': 'nuevo-script.ps1'
};

// 2. main.js
ipcMain.handle('nuevo-action', async (event, params) => {
  return await executeScript('nuevo', params.dryRun, params);
});

// 3. preload.js
contextBridge.exposeInMainWorld('api', {
  nuevoAction: (params) => ipcRenderer.invoke('nuevo-action', params)
});

// 4. renderer.js
const result = await window.api.nuevoAction({ dryRun: true });
```
