# 🏗️ Arquitectura del Proyecto

## Visión General

PC Maintenance Optimizer es una aplicación de escritorio construida con Electron que ejecuta scripts PowerShell para optimizar y mantener sistemas Windows.

## Diagrama de Arquitectura

```
┌─────────────────────────────────────────────────────────┐
│                    FRONTEND (Electron)                   │
│  ┌─────────────┐  ┌──────────────┐  ┌────────────────┐ │
│  │  index.html │  │  renderer.js │  │   styles.css   │ │
│  │   (UI)      │◄─┤  (Logic)     │  │   (Styles)     │ │
│  └─────────────┘  └──────────────┘  └────────────────┘ │
│         │                  │                             │
│         └──────────────────┼─────────────────────────────┤
│                            │                             │
│                    ┌───────▼────────┐                    │
│                    │  preload.js    │                    │
│                    │  (IPC Bridge)  │                    │
│                    └───────┬────────┘                    │
└────────────────────────────┼──────────────────────────────┘
                             │
                    ┌────────▼────────┐
                    │    main.js      │
                    │ (Main Process)  │
                    └────────┬────────┘
                             │
┌────────────────────────────▼──────────────────────────────┐
│                    BACKEND (Node.js)                       │
│  ┌──────────────────────────────────────────────────────┐ │
│  │              executor.js                             │ │
│  │  (PowerShell Script Executor)                        │ │
│  └──────────────────┬───────────────────────────────────┘ │
│                     │                                      │
│  ┌──────────────────▼───────────────────────────────────┐ │
│  │           PowerShell Scripts                         │ │
│  │  ┌────────────┐  ┌────────────┐  ┌────────────────┐ │ │
│  │  │ scan-      │  │ optimize-  │  │ create-restore-│ │ │
│  │  │ system.ps1 │  │ system.ps1 │  │ point.ps1      │ │ │
│  │  └────────────┘  └────────────┘  └────────────────┘ │ │
│  │  ┌────────────┐  ┌────────────┐  ┌────────────────┐ │ │
│  │  │ browser-   │  │ disk-      │  │ process-       │ │ │
│  │  │ cleanup.ps1│  │ analyzer.ps1│  │ manager.ps1    │ │ │
│  │  └────────────┘  └────────────┘  └────────────────┘ │ │
│  └──────────────────────────────────────────────────────┘ │
└───────────────────────────────────────────────────────────┘
                             │
                    ┌────────▼────────┐
                    │  Windows OS     │
                    │  (System APIs)  │
                    └─────────────────┘
```

## Componentes Principales

### 1. Frontend (Renderer Process)

**Archivos**: `src/ui/`

- **index.html**: Estructura de la interfaz de usuario
- **renderer.js**: Lógica del frontend, manejo de eventos
- **styles.css**: Estilos visuales

**Responsabilidades**:
- Mostrar la interfaz al usuario
- Capturar interacciones (clicks, selecciones)
- Enviar comandos al backend vía IPC
- Mostrar resultados y logs

### 2. IPC Bridge (Preload Script)

**Archivo**: `src/preload.js`

**Responsabilidades**:
- Exponer APIs seguras al renderer
- Aislar el renderer del proceso principal
- Prevenir acceso directo a Node.js desde el frontend

**APIs Expuestas**:
```javascript
window.api.scanSystem()
window.api.optimizeSystem(options)
window.api.createRestorePoint()
window.api.getLogs()
```

### 3. Main Process

**Archivo**: `src/main.js`

**Responsabilidades**:
- Crear y gestionar ventanas de Electron
- Manejar IPC handlers
- Coordinar ejecución de scripts
- Gestión del ciclo de vida de la app

### 4. Backend Executor

**Archivo**: `src/backend/executor.js`

**Responsabilidades**:
- Ejecutar scripts PowerShell
- Capturar stdout/stderr
- Gestionar logs
- Manejar errores de ejecución

**Funciones Principales**:
```javascript
executeScript(action, dryRun, options)
ensureLogsDir()
```

### 5. PowerShell Scripts

**Directorio**: `src/backend/scripts/`

#### scan-system.ps1
- Escanea archivos temporales
- Lista apps de inicio
- Enumera servicios activos
- Reporta uso de memoria

#### optimize-system.ps1
- Limpia temporales
- Optimiza servicios
- Gestiona startup apps
- Libera memoria

#### create-restore-point.ps1
- Crea puntos de restauración
- Verifica System Protection

#### browser-cleanup.ps1
- Limpia cache de navegadores
- Soporta Chrome, Firefox, Edge

#### disk-analyzer.ps1
- Analiza uso de disco
- Identifica carpetas grandes

#### process-manager.ps1
- Lista procesos con alto uso
- Cierra procesos no críticos

#### scheduler.ps1
- Crea tareas programadas
- Gestiona Task Scheduler

## Flujo de Datos

### Escaneo del Sistema

```
Usuario → Click "Escanear"
    ↓
renderer.js → window.api.scanSystem()
    ↓
preload.js → ipcRenderer.invoke('scan-system')
    ↓
main.js → ipcMain.handle('scan-system')
    ↓
executor.js → executeScript('scan', false)
    ↓
PowerShell → scan-system.ps1
    ↓
Windows OS → Recopila información
    ↓
PowerShell → Retorna JSON
    ↓
executor.js → Captura output, guarda log
    ↓
main.js → Retorna resultado
    ↓
renderer.js → Muestra resultados en UI
```

### Optimización

```
Usuario → Selecciona opciones + Click "Optimizar"
    ↓
renderer.js → window.api.optimizeSystem(options)
    ↓
preload.js → ipcRenderer.invoke('optimize-system', options)
    ↓
main.js → ipcMain.handle('optimize-system')
    ↓
executor.js → executeScript('optimize', dryRun, options)
    ↓
PowerShell → optimize-system.ps1 con parámetros
    ↓
Windows OS → Aplica cambios (si no es dry run)
    ↓
PowerShell → Retorna log de operaciones
    ↓
executor.js → Guarda log en archivo
    ↓
renderer.js → Muestra log en UI
```

## Seguridad

### Context Isolation
- El renderer no tiene acceso directo a Node.js
- Solo APIs específicas expuestas vía preload

### Permisos
- Requiere elevación a Administrador
- Scripts validan permisos antes de ejecutar

### Validación
- Blacklist de servicios críticos
- Confirmación antes de cambios reales
- Dry run por defecto

## Logs y Auditoría

**Ubicación**: `logs/`

**Formato**: `{action}-{timestamp}.log`

**Contenido**:
- Exit code del script
- Output completo (stdout)
- Errores (stderr)
- Timestamp

## Extensibilidad

### Agregar Nuevo Script

1. Crear `nuevo-script.ps1` en `src/backend/scripts/`
2. Agregar entrada en `executor.js`:
```javascript
const scriptMap = {
  'nuevo': 'nuevo-script.ps1'
};
```
3. Agregar IPC handler en `main.js`:
```javascript
ipcMain.handle('nuevo-action', async () => {
  return await executeScript('nuevo', false);
});
```
4. Exponer API en `preload.js`:
```javascript
nuevoAction: () => ipcRenderer.invoke('nuevo-action')
```
5. Usar en `renderer.js`:
```javascript
await window.api.nuevoAction();
```

### Agregar Nueva Funcionalidad UI

1. Agregar HTML en `index.html`
2. Agregar estilos en `styles.css`
3. Agregar lógica en `renderer.js`
4. Conectar con backend si es necesario

## Dependencias

### Producción
- `electron`: Framework de la aplicación
- `node-powershell`: Ejecución de scripts PowerShell

### Desarrollo
- `electron-builder`: Compilación de ejecutables (opcional)

## Performance

### Optimizaciones
- Scripts ejecutan en procesos separados (no bloquean UI)
- Logs limitados a últimas 10 entradas
- Cache de resultados de escaneo

### Limitaciones
- Limpieza de temporales puede tardar en sistemas grandes
- Algunos servicios requieren reinicio para cambios

## Testing

### Manual
- Dry run para todas las operaciones
- Logs detallados para debugging

### Futuro
- Tests unitarios con Jest
- Tests de integración
- CI/CD pipeline

## Deployment

### Desarrollo
```cmd
npm install
npm start
```

### Producción
```cmd
npm run build
```

Genera ejecutable en `dist/`

## Roadmap Técnico

- [ ] Migrar a TypeScript
- [ ] Agregar tests automatizados
- [ ] Implementar auto-updater
- [ ] Mejorar manejo de errores
- [ ] Agregar telemetría (opcional)
- [ ] Soporte multi-plataforma (Linux, macOS)
