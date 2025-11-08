# 🔧 PC Maintenance Optimizer

Aplicación de mantenimiento automático de PC con limpieza, optimización de recursos y programación de tareas.

## ⚡ Características

### 🤖 Inteligencia Artificial Integrada (Groq)
- **Análisis Inteligente**: IA analiza tu sistema y detecta problemas automáticamente
- **Recomendaciones Priorizadas**: Sugerencias basadas en impacto real
- **Asistente Conversacional**: Pregunta en lenguaje natural ("Mi PC va lenta")
- **Predicción de Impacto**: Sabe cuánto mejorará cada optimización
- **Modos Inteligentes**: Gaming, Diseño, Trabajo, Ahorro de energía
- **7 API Keys de Groq**: Con rotación automática para máxima disponibilidad

### 🛠️ Mantenimiento Tradicional
- **Limpieza de Temporales**: Elimina archivos temporales y cache del sistema
- **Optimización de Inicio**: Gestiona aplicaciones que se ejecutan al arranque
- **Gestión de Servicios**: Detiene servicios no críticos para liberar recursos
- **Liberación de Memoria**: Optimiza el uso de RAM
- **Restore Points**: Crea puntos de restauración antes de cambios importantes
- **Modo Dry Run**: Simula cambios sin aplicarlos realmente
- **Logs Detallados**: Registro completo de todas las operaciones

## 🚀 Instalación

### Requisitos Previos

- Node.js (v16 o superior)
- Python 3.9+ (para funcionalidad de IA)
- Windows 10/11
- Permisos de Administrador

### Instalación Rápida

1. **Instalar dependencias de Node.js**:
```cmd
npm install
```

2. **Instalar dependencias de Python (IA)**:
```cmd
pip install -r requirements.txt
```

3. **Iniciar servidor de IA**:
```cmd
start-ai-server.bat
```

4. **Iniciar aplicación** (en otra terminal):
```cmd
npm start
```

### Sin IA (Solo mantenimiento básico)

Si no quieres usar IA, solo ejecuta:
```cmd
npm start
```

La app funcionará sin las características de IA.

## ⚠️ IMPORTANTE - Seguridad

- **Siempre ejecuta como Administrador** para funcionalidad completa
- **Crea un Restore Point** antes de ejecutar optimizaciones reales
- **Usa Modo Dry Run** primero para ver qué cambios se aplicarían
- Los logs se guardan en la carpeta `logs/` para auditoría

## 📖 Uso

### 🤖 Modo IA (Recomendado)

1. **Análisis Inteligente**: Haz clic en "🧠 Analizar con IA"
   - La IA escanea tu sistema
   - Detecta problemas automáticamente
   - Prioriza recomendaciones por impacto

2. **Chat con Asistente**: Pregunta en lenguaje natural
   - "Mi PC va muy lenta"
   - "Necesito espacio en disco"
   - "Optimiza para juegos"
   - La IA responde y sugiere acciones

3. **Aplicar Recomendaciones**: Sigue las sugerencias de la IA

### 🛠️ Modo Manual

1. **Escanear Sistema**: Clic en "🔍 Escanear Sistema"
2. **Crear Restore Point**: "💾 Crear Restore Point"
3. **Seleccionar Optimizaciones**: Marca las opciones deseadas
4. **Elegir Modo**: Dry Run o Real
5. **Optimizar**: "✨ Optimizar Ahora"

## 📁 Estructura del Proyecto

```
pc-maintenance-optimizer/
├── src/
│   ├── main.js              # Proceso principal de Electron
│   ├── preload.js           # Bridge seguro entre renderer y main
│   ├── ui/
│   │   ├── index.html       # Interfaz de usuario
│   │   ├── styles.css       # Estilos
│   │   └── renderer.js      # Lógica del frontend
│   └── backend/
│       ├── executor.js      # Ejecutor de scripts PowerShell
│       └── scripts/
│           ├── scan-system.ps1
│           ├── optimize-system.ps1
│           ├── create-restore-point.ps1
│           └── get-logs.ps1
├── logs/                    # Logs de operaciones
├── package.json
└── README.md
```

## 🛠️ Scripts PowerShell

### scan-system.ps1
Escanea el sistema y recopila información sobre temporales, inicio, servicios y memoria.

### optimize-system.ps1
Ejecuta optimizaciones según los parámetros:
- `-CleanTemp`: Limpia archivos temporales
- `-OptimizeStartup`: Gestiona apps de inicio
- `-OptimizeServices`: Detiene servicios no críticos
- `-FreeMemory`: Libera memoria y ajusta plan de energía
- `-DryRun`: Modo simulación

### create-restore-point.ps1
Crea un punto de restauración del sistema.

## 🔒 Seguridad y Limitaciones

### Servicios Protegidos (Blacklist)
Estos servicios NUNCA se tocan:
- Windows Update (wuauserv)
- Windows Defender (WinDefend)
- Firewall (MpsSvc, BFE)
- DHCP, DNS Cache
- Event Log

### Servicios Seguros para Detener
- Tablet Input Service
- Fax
- Xbox Services (si no usas Xbox)

### Recomendaciones
- Prueba primero en una VM o equipo de prueba
- Lee los logs después de cada operación
- Mantén backups regulares
- No deshabilites servicios que no conozcas

## 🚧 Próximas Características IA

- [ ] Modelos locales con Ollama (100% offline)
- [ ] Aprendizaje de patrones de uso
- [ ] Detección de anomalías
- [ ] Predicción de fallos
- [ ] Optimización automática programada
- [ ] Modos inteligentes personalizables

## 🚧 Próximas Características Generales

- [ ] Programación automática (Task Scheduler)
- [ ] Soporte para Linux y macOS
- [ ] Análisis de rendimiento antes/después
- [ ] Whitelist/Blacklist personalizable desde UI
- [ ] Reversión automática de cambios
- [ ] Notificaciones de mantenimiento

## 📝 Licencia

MIT License - Úsalo bajo tu propio riesgo

## ⚠️ Disclaimer

Esta aplicación modifica configuraciones del sistema. El autor no se hace responsable de:
- Pérdida de datos
- Inestabilidad del sistema
- Problemas de compatibilidad
- Cualquier daño derivado del uso

**USA BAJO TU PROPIO RIESGO Y SIEMPRE CON BACKUPS**
