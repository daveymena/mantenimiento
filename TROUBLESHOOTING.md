# 🔧 Solución de Problemas

## Problemas Comunes y Soluciones

### 1. Conflictos de Dependencias de Python

**Síntoma**:
```
ERROR: pip's dependency resolver does not currently take into account all the packages...
coqui-tts-trainer 0.3.1 requires numpy>=1.25.2; python_version < "3.12", but you have numpy 1.24.3
```

**Causa**: Tienes otros paquetes Python instalados que tienen requisitos conflictivos.

**Solución**:

**Opción A - Actualizar dependencias (Recomendado)**:
```cmd
fix-dependencies.bat
```

**Opción B - Usar entorno virtual**:
```cmd
# Crear entorno virtual
python -m venv venv

# Activar (Windows CMD)
venv\Scripts\activate.bat

# Activar (PowerShell)
venv\Scripts\Activate.ps1

# Instalar dependencias
pip install -r requirements.txt
```

**Opción C - Ignorar conflictos**:
Los conflictos mostrados son de otros paquetes (coqui-tts, gradio, etc.) que NO afectan esta aplicación. Puedes ignorarlos de forma segura.

---

### 2. Script no se ejecuta en PowerShell

**Síntoma**:
```
start-ai-server.bat : El término 'start-ai-server.bat' no se reconoce...
```

**Causa**: PowerShell no ejecuta scripts del directorio actual sin `.\`

**Solución**:

En PowerShell, usa:
```powershell
.\start-ai-server.bat
```

O cambia a CMD:
```cmd
cmd
start-ai-server.bat
```

---

### 3. Error de GPU en Electron

**Síntoma**:
```
[24056:1106/100646.852:ERROR:gpu_process_host.cc(991)] GPU process exited unexpectedly: exit_code=-1073740791
```

**Causa**: Electron intenta usar aceleración por hardware pero falla (común en VMs o GPUs antiguas).

**Solución**:

**Opción A - Deshabilitar aceleración GPU**:

Edita `src/main.js`, agrega al inicio:
```javascript
app.disableHardwareAcceleration();
```

**Opción B - Ignorar**:
Este error NO afecta la funcionalidad. La app funciona correctamente sin GPU.

**Opción C - Actualizar drivers**:
Actualiza los drivers de tu tarjeta gráfica.

---

### 4. Servidor de IA no inicia

**Síntoma**:
```
ModuleNotFoundError: No module named 'flask'
```

**Solución**:
```cmd
pip install -r requirements.txt
```

Si persiste:
```cmd
python -m pip install flask flask-cors psutil requests openai
```

---

### 5. Puerto 5000 ocupado

**Síntoma**:
```
OSError: [WinError 10048] Solo se permite un uso de cada dirección de socket
```

**Solución**:

**Opción A - Cerrar proceso**:
```cmd
netstat -ano | findstr :5000
taskkill /PID [número] /F
```

**Opción B - Cambiar puerto**:

Edita `src/ai/ai_server.py`:
```python
app.run(host='0.0.0.0', port=5001, debug=True)
```

Y `src/ui/renderer.js`:
```javascript
const AI_SERVER_URL = 'http://localhost:5001';
```

---

### 6. Keys de Groq no funcionan

**Síntoma**:
Chat responde con reglas en lugar de IA inteligente.

**Solución**:

1. **Verificar conexión a internet**
2. **Probar keys**:
```cmd
.\test-groq-keys.bat
```

3. **Resetear keys fallidas**:
```cmd
curl -X POST http://localhost:5000/api/groq-reset
```

4. **Ver logs**:
```cmd
type logs\groq_keys_state.json
```

---

### 7. Aplicación no inicia

**Síntoma**:
```
Error: Cannot find module 'electron'
```

**Solución**:
```cmd
npm install
```

Si persiste:
```cmd
rmdir /s /q node_modules
del package-lock.json
npm install
```

---

### 8. Permisos denegados

**Síntoma**:
```
Access Denied
```

**Solución**:

Ejecuta CMD o PowerShell como Administrador:
1. Busca "CMD" o "PowerShell"
2. Clic derecho → "Ejecutar como administrador"
3. Navega al proyecto: `cd C:\ruta\al\proyecto`
4. Ejecuta los comandos

---

### 9. Restore Point no se crea

**Síntoma**:
```
No se pudo crear restore point
```

**Solución**:

1. **Habilitar System Protection**:
   - Win + Pause → "Protección del sistema"
   - Selecciona disco C:
   - "Configurar" → "Activar protección del sistema"

2. **Verificar espacio**:
   - Necesitas al menos 300 MB libres

3. **Ejecutar como Administrador**

---

### 10. Chat no responde

**Síntoma**:
El chat no muestra respuestas.

**Solución**:

1. **Verificar servidor IA**:
```cmd
curl http://localhost:5000/health
```

2. **Ver consola del navegador**:
   - F12 en la app
   - Buscar errores en "Console"

3. **Reiniciar servidor**:
   - Ctrl+C en terminal del servidor
   - `.\start-ai-server.bat`

---

## Comandos de Diagnóstico

### Verificar Instalación

```cmd
# Node.js
node --version
npm --version

# Python
python --version
pip --version

# Dependencias Node
npm list --depth=0

# Dependencias Python
pip list | findstr "flask psutil requests openai"
```

### Verificar Servicios

```cmd
# Servidor IA
curl http://localhost:5000/health

# Estadísticas Groq
curl http://localhost:5000/api/groq-stats

# Probar keys
.\test-groq-keys.bat
```

### Limpiar y Reinstalar

```cmd
# Limpiar Node
rmdir /s /q node_modules
del package-lock.json
npm install

# Limpiar Python (entorno virtual)
rmdir /s /q venv
python -m venv venv
venv\Scripts\activate
pip install -r requirements.txt
```

---

## Logs Útiles

### Ubicación de Logs

- **Aplicación**: `logs/*.log`
- **Groq Keys**: `logs/groq_keys_state.json`
- **IA History**: `logs/ai_history.json`

### Ver Logs

```cmd
# Últimos logs
dir logs /o-d

# Ver log específico
type logs\scan-2025-11-06T14-30-45.log

# Ver estado de Groq
type logs\groq_keys_state.json
```

---

## Problemas Específicos de Windows

### Execution Policy (PowerShell)

**Síntoma**:
```
No se puede cargar el archivo porque la ejecución de scripts está deshabilitada
```

**Solución**:
```powershell
Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope CurrentUser
```

### PATH no configurado

**Síntoma**:
```
'python' no se reconoce como un comando interno o externo
```

**Solución**:
1. Reinstala Python
2. Marca "Add Python to PATH"
3. Reinicia CMD/PowerShell

### Firewall bloquea servidor

**Síntoma**:
Servidor inicia pero no responde.

**Solución**:
1. Windows Defender Firewall
2. "Permitir una aplicación"
3. Busca "Python" y marca ambas casillas

---

## Entorno Virtual (Recomendado para Producción)

### Crear y Usar

```cmd
# Crear
python -m venv venv

# Activar (CMD)
venv\Scripts\activate.bat

# Activar (PowerShell)
venv\Scripts\Activate.ps1

# Instalar
pip install -r requirements.txt

# Desactivar
deactivate
```

### Ventajas

- ✅ Sin conflictos con otros paquetes
- ✅ Versiones específicas garantizadas
- ✅ Fácil de limpiar y recrear

---

## Contacto y Soporte

Si ninguna solución funciona:

1. **Revisa documentación**:
   - [FAQ.md](docs/FAQ.md)
   - [INSTALL.md](INSTALL.md)
   - [SETUP.md](SETUP.md)

2. **Recopila información**:
   - Versión de Windows
   - Versión de Python y Node.js
   - Mensaje de error completo
   - Logs relevantes

3. **Abre un issue** con toda la información

---

## Checklist de Diagnóstico

Antes de reportar un problema, verifica:

- [ ] Node.js instalado (`node --version`)
- [ ] Python instalado (`python --version`)
- [ ] Dependencias instaladas (`npm install`, `pip install -r requirements.txt`)
- [ ] Ejecutando como Administrador
- [ ] Puerto 5000 libre
- [ ] Firewall no bloquea
- [ ] Conexión a internet (para Groq)
- [ ] Logs revisados
- [ ] Documentación consultada

---

**¿Problema no listado?** Consulta [FAQ.md](docs/FAQ.md) o abre un issue.
