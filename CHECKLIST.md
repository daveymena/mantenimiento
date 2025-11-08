# ✅ Checklist de Instalación y Verificación

## Pre-requisitos

### Software Necesario

- [ ] **Node.js** instalado (v16+)
  ```cmd
  node --version
  ```
  Si no: https://nodejs.org/

- [ ] **Python** instalado (v3.9+)
  ```cmd
  python --version
  ```
  Si no: https://www.python.org/

- [ ] **npm** disponible
  ```cmd
  npm --version
  ```

- [ ] **pip** disponible
  ```cmd
  pip --version
  ```

### Permisos

- [ ] Cuenta con privilegios de **Administrador**
- [ ] **PowerShell** puede ejecutar scripts
  ```powershell
  Get-ExecutionPolicy
  ```
  Si es "Restricted", ejecuta:
  ```powershell
  Set-ExecutionPolicy RemoteSigned -Scope CurrentUser
  ```

- [ ] **System Protection** habilitado (opcional pero recomendado)
  - Win + Pause → Protección del sistema → Configurar

## Instalación

### Paso 1: Dependencias Node.js

- [ ] Ejecutar en la carpeta del proyecto:
  ```cmd
  npm install
  ```

- [ ] Verificar instalación:
  ```cmd
  npm list --depth=0
  ```
  Debe mostrar:
  - electron@^27.0.0
  - node-powershell@^5.0.1

### Paso 2: Dependencias Python

- [ ] Ejecutar:
  ```cmd
  pip install -r requirements.txt
  ```

- [ ] Verificar instalación:
  ```cmd
  pip list
  ```
  Debe incluir:
  - psutil
  - flask
  - flask-cors
  - requests
  - openai

### Paso 3: Configuración (Opcional)

- [ ] **API de OpenAI** (opcional):
  ```cmd
  setx OPENAI_API_KEY "tu-api-key"
  ```

- [ ] **API de Groq** (opcional):
  ```cmd
  setx GROQ_API_KEY "tu-api-key"
  ```

- [ ] Editar `src/ai/ai_server.py` si usas API:
  ```python
  assistant = AIAssistant(provider="openai")  # o "groq"
  ```

## Primera Ejecución

### Terminal 1: Servidor de IA

- [ ] Ejecutar:
  ```cmd
  start-ai-server.bat
  ```

- [ ] Verificar que inicie sin errores

- [ ] Verificar endpoint:
  ```cmd
  curl http://localhost:5000/health
  ```
  Debe responder: `{"status":"ok"}`

### Terminal 2: Aplicación Principal

- [ ] Ejecutar como Administrador:
  ```cmd
  npm start
  ```
  O usar `run-as-admin.bat`

- [ ] Verificar que la ventana se abra

- [ ] Verificar logs en la app:
  - ✓ Aplicación iniciada correctamente
  - 🤖 Servidor de IA conectado

## Verificación de Funcionalidad

### Funciones Básicas

- [ ] **Escanear Sistema**
  - Clic en "🔍 Escanear Sistema"
  - Debe mostrar resultados (temporales, apps, servicios, memoria)

- [ ] **Crear Restore Point**
  - Clic en "💾 Crear Restore Point"
  - Debe completarse sin errores
  - Verificar en Windows: "Crear un punto de restauración"

- [ ] **Modo Dry Run**
  - Marcar "Limpiar Temporales"
  - Modo "Simulación"
  - Clic en "✨ Optimizar Ahora"
  - Debe mostrar qué se haría sin aplicar cambios

- [ ] **Logs**
  - Verificar que aparezcan mensajes en "Registro de Actividad"
  - Verificar archivos en carpeta `logs/`

### Funciones de IA

- [ ] **Análisis con IA**
  - Clic en "🧠 Analizar con IA"
  - Debe mostrar recomendaciones priorizadas
  - Verificar colores según prioridad (rojo, naranja, amarillo, verde)

- [ ] **Chat con IA**
  - Escribir: "Mi PC va lenta"
  - Presionar Enter o clic en "Enviar"
  - Debe responder con sugerencias

- [ ] **Predicción de Impacto**
  - Verificar que las recomendaciones muestren "Impacto: high/medium/low"

### Optimizaciones Reales (Con precaución)

⚠️ **Solo después de crear Restore Point**

- [ ] **Limpiar Temporales**
  - Marcar "Limpiar Temporales"
  - Modo "Ejecutar Cambios Reales"
  - Confirmar
  - Verificar logs de limpieza

- [ ] **Liberar Memoria**
  - Marcar "Liberar Memoria"
  - Ejecutar
  - Verificar en Task Manager que la RAM se libere

## Verificación de Archivos

### Estructura del Proyecto

- [ ] Carpeta `src/` existe
  - [ ] `src/ai/` con archivos Python
  - [ ] `src/backend/` con executor.js
  - [ ] `src/backend/scripts/` con archivos .ps1
  - [ ] `src/ui/` con HTML/CSS/JS

- [ ] Carpeta `docs/` con documentación

- [ ] Carpeta `logs/` se crea automáticamente

- [ ] Archivos raíz:
  - [ ] package.json
  - [ ] requirements.txt
  - [ ] README.md
  - [ ] START_HERE.md
  - [ ] run-as-admin.bat
  - [ ] start-ai-server.bat

### Scripts PowerShell

Verificar que existan en `src/backend/scripts/`:

- [ ] scan-system.ps1
- [ ] optimize-system.ps1
- [ ] create-restore-point.ps1
- [ ] browser-cleanup.ps1
- [ ] disk-analyzer.ps1
- [ ] process-manager.ps1
- [ ] scheduler.ps1
- [ ] get-logs.ps1

### Archivos de IA

Verificar que existan en `src/ai/`:

- [ ] ai_server.py
- [ ] ai_engine.py
- [ ] ai_assistant.py
- [ ] __init__.py

## Tests Manuales

### Test 1: Escaneo Completo

1. [ ] Abrir app
2. [ ] Escanear sistema
3. [ ] Verificar resultados coherentes
4. [ ] Verificar que no haya errores en logs

### Test 2: IA Básica

1. [ ] Analizar con IA
2. [ ] Verificar recomendaciones
3. [ ] Chat: "Hola"
4. [ ] Verificar respuesta

### Test 3: Optimización Dry Run

1. [ ] Marcar todas las opciones
2. [ ] Modo Dry Run
3. [ ] Optimizar
4. [ ] Verificar que no se apliquen cambios reales

### Test 4: Restore Point

1. [ ] Crear Restore Point
2. [ ] Verificar en Windows que se creó
3. [ ] Nombre debe ser "PCMaintenance-BeforeOptimization"

### Test 5: Optimización Real

⚠️ **Con Restore Point creado**

1. [ ] Marcar "Limpiar Temporales"
2. [ ] Modo Real
3. [ ] Confirmar
4. [ ] Verificar limpieza en logs
5. [ ] Verificar espacio liberado

## Solución de Problemas

### Problema: Servidor de IA no inicia

- [ ] Verificar Python instalado
- [ ] Verificar dependencias: `pip list`
- [ ] Revisar puerto 5000 libre
- [ ] Ver logs en terminal del servidor

### Problema: App no inicia

- [ ] Verificar Node.js instalado
- [ ] Ejecutar como Administrador
- [ ] Reinstalar dependencias: `npm install`
- [ ] Ver logs en terminal

### Problema: No crea Restore Point

- [ ] Verificar System Protection habilitado
- [ ] Verificar espacio en disco
- [ ] Ejecutar como Administrador
- [ ] Ver logs de error

### Problema: Chat no responde

- [ ] Verificar servidor IA corriendo
- [ ] Verificar http://localhost:5000/health
- [ ] Ver consola del navegador (F12)
- [ ] Revisar logs del servidor

## Checklist de Seguridad

- [ ] **Siempre** crear Restore Point antes de optimizaciones
- [ ] **Siempre** usar Dry Run primero
- [ ] **Nunca** deshabilitar servicios críticos
- [ ] **Revisar** logs después de cada operación
- [ ] **Mantener** backups de datos importantes

## Checklist de Mantenimiento

### Diario
- [ ] Revisar uso de recursos en la app

### Semanal
- [ ] Escanear sistema
- [ ] Limpiar temporales
- [ ] Revisar recomendaciones de IA

### Mensual
- [ ] Optimización completa
- [ ] Crear Restore Point
- [ ] Limpiar logs antiguos
- [ ] Revisar servicios

## Documentación Leída

- [ ] [START_HERE.md](START_HERE.md) - Inicio rápido
- [ ] [README.md](README.md) - Documentación principal
- [ ] [QUICKSTART.md](QUICKSTART.md) - Guía de 5 minutos
- [ ] [AI_SETUP.md](AI_SETUP.md) - Configuración de IA
- [ ] [SECURITY.md](SECURITY.md) - Guía de seguridad
- [ ] [FAQ.md](docs/FAQ.md) - Preguntas frecuentes

## Configuración Avanzada (Opcional)

- [ ] Configurar API de OpenAI/Groq
- [ ] Personalizar blacklist de servicios en `config.json`
- [ ] Programar mantenimiento automático con `scheduler.ps1`
- [ ] Configurar VS Code para desarrollo

## Estado Final

- [ ] ✅ Todo instalado correctamente
- [ ] ✅ Servidor de IA funcionando
- [ ] ✅ App principal funcionando
- [ ] ✅ Funciones básicas verificadas
- [ ] ✅ Funciones de IA verificadas
- [ ] ✅ Restore Point creado
- [ ] ✅ Documentación leída
- [ ] ✅ Listo para usar

---

## Verificación de Groq (Nuevo)

- [ ] **Probar keys de Groq**:
```cmd
test-groq-keys.bat
```

- [ ] **Verificar que al menos 5 keys funcionan**

- [ ] **Ver estadísticas**:
```cmd
curl http://localhost:5000/api/groq-stats
```

- [ ] **Probar chat con IA** en la aplicación

- [ ] **Verificar rotación automática** (opcional)

---

**Fecha de verificación**: _______________

**Notas adicionales**:
_________________________________
_________________________________
_________________________________

**¡Felicidades! Tu PC Maintenance Optimizer con IA está listo para usar.** 🎉
