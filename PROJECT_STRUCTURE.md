# 📂 Estructura del Proyecto

```
pc-maintenance-optimizer/
│
├── 📁 src/                          # Código fuente
│   ├── 📁 backend/                  # Backend (Node.js)
│   │   ├── 📁 scripts/              # Scripts PowerShell
│   │   │   ├── scan-system.ps1     # Escaneo del sistema
│   │   │   ├── optimize-system.ps1 # Optimización principal
│   │   │   ├── create-restore-point.ps1
│   │   │   ├── browser-cleanup.ps1 # Limpieza de navegadores
│   │   │   ├── disk-analyzer.ps1   # Análisis de disco
│   │   │   ├── process-manager.ps1 # Gestión de procesos
│   │   │   ├── scheduler.ps1       # Programación de tareas
│   │   │   └── get-logs.ps1        # Obtener logs
│   │   └── executor.js             # Ejecutor de scripts
│   │
│   ├── 📁 ui/                       # Frontend (Electron)
│   │   ├── index.html              # Interfaz de usuario
│   │   ├── renderer.js             # Lógica del frontend
│   │   └── styles.css              # Estilos CSS
│   │
│   ├── main.js                     # Proceso principal Electron
│   └── preload.js                  # Bridge IPC seguro
│
├── 📁 docs/                         # Documentación
│   ├── API.md                      # Documentación de API
│   ├── ARCHITECTURE.md             # Arquitectura del sistema
│   └── FAQ.md                      # Preguntas frecuentes
│
├── 📁 logs/                         # Logs (generado en runtime)
│   └── *.log                       # Archivos de log
│
├── 📁 .vscode/                      # Configuración VS Code
│   ├── settings.json
│   ├── launch.json                 # Debug config
│   └── extensions.json             # Extensiones recomendadas
│
├── 📄 package.json                  # Dependencias npm
├── 📄 config.json                   # Configuración de la app
├── 📄 .gitignore                    # Archivos ignorados por Git
├── 📄 .editorconfig                 # Configuración del editor
├── 📄 .npmrc                        # Configuración npm
│
├── 📖 README.md                     # Documentación principal
├── 📖 QUICKSTART.md                 # Inicio rápido
├── 📖 INSTALL.md                    # Guía de instalación
├── 📖 SECURITY.md                   # Guía de seguridad
├── 📖 TODO.md                       # Tareas pendientes
├── 📖 CHANGELOG.md                  # Historial de cambios
├── 📖 LICENSE                       # Licencia MIT
│
└── 🚀 run-as-admin.bat              # Script de inicio rápido
```

## Descripción de Componentes

### 🎨 Frontend (UI)
- **index.html**: Interfaz gráfica con opciones de optimización
- **renderer.js**: Manejo de eventos y comunicación con backend
- **styles.css**: Diseño moderno y responsive

### ⚙️ Backend
- **executor.js**: Ejecuta scripts PowerShell y gestiona logs
- **Scripts PowerShell**: Realizan las operaciones del sistema

### 🔧 Scripts PowerShell

| Script | Función | Parámetros |
|--------|---------|------------|
| `scan-system.ps1` | Escanea el sistema | `-DryRun` |
| `optimize-system.ps1` | Optimiza el sistema | `-DryRun`, `-CleanTemp`, `-OptimizeStartup`, `-OptimizeServices`, `-FreeMemory` |
| `create-restore-point.ps1` | Crea punto de restauración | `-DryRun` |
| `browser-cleanup.ps1` | Limpia cache de navegadores | `-DryRun`, `-Chrome`, `-Firefox`, `-Edge` |
| `disk-analyzer.ps1` | Analiza uso de disco | `-Drive` |
| `process-manager.ps1` | Gestiona procesos | `-Action`, `-DryRun` |
| `scheduler.ps1` | Programa tareas | `-Action`, `-Frequency`, `-Time` |
| `get-logs.ps1` | Lista logs recientes | `-DryRun` |

### 📚 Documentación

| Archivo | Contenido |
|---------|-----------|
| `README.md` | Introducción y características |
| `QUICKSTART.md` | Inicio rápido en 5 minutos |
| `INSTALL.md` | Guía detallada de instalación |
| `SECURITY.md` | Mejores prácticas de seguridad |
| `FAQ.md` | Preguntas frecuentes |
| `TODO.md` | Roadmap y tareas pendientes |
| `CHANGELOG.md` | Historial de versiones |
| `API.md` | Documentación técnica de API |
| `ARCHITECTURE.md` | Arquitectura del sistema |

### 🔒 Configuración

- **config.json**: Configuración de la aplicación
  - Blacklist de servicios críticos
  - Procesos protegidos
  - Configuración de logs
  - Opciones por defecto

- **.editorconfig**: Estilo de código consistente
- **.npmrc**: Configuración de npm
- **.gitignore**: Archivos excluidos de Git

### 🚀 Ejecución

- **run-as-admin.bat**: Ejecuta la app con permisos de administrador
- **npm start**: Inicia la aplicación
- **npm run dev**: Modo desarrollo

## Flujo de Archivos

```
Usuario interactúa con UI
    ↓
index.html + renderer.js
    ↓
preload.js (IPC Bridge)
    ↓
main.js (Electron Main Process)
    ↓
executor.js
    ↓
Scripts PowerShell (.ps1)
    ↓
Windows OS
    ↓
Logs guardados en logs/
```

## Tamaño Aproximado

- **Código fuente**: ~50 KB
- **Documentación**: ~100 KB
- **node_modules** (después de npm install): ~200 MB
- **Logs** (varía): 1-10 MB

## Archivos Generados en Runtime

- `logs/*.log` - Logs de operaciones
- `node_modules/` - Dependencias npm (después de `npm install`)
- `dist/` - Ejecutable compilado (después de `npm run build`)

## Archivos Importantes para Modificar

### Para personalizar la UI:
- `src/ui/index.html`
- `src/ui/styles.css`
- `src/ui/renderer.js`

### Para agregar funcionalidad:
- `src/backend/scripts/*.ps1` (nuevos scripts)
- `src/backend/executor.js` (agregar a scriptMap)
- `src/main.js` (agregar IPC handlers)
- `src/preload.js` (exponer APIs)

### Para configurar:
- `config.json` (blacklists, opciones)
- `package.json` (dependencias, scripts)

## Próximos Archivos (Roadmap)

- `tests/` - Tests unitarios
- `build/` - Configuración de build
- `assets/` - Iconos y recursos
- `locales/` - Traducciones
- `.github/` - CI/CD workflows
