# 🚀 EMPIEZA AQUÍ

## Instalación en 3 Pasos

### 1️⃣ Instalar Node.js y Python

**Node.js** (para la aplicación):
- Descarga: https://nodejs.org/
- Instala versión LTS
- Verifica: `node --version`

**Python** (para IA):
- Descarga: https://www.python.org/
- Instala versión 3.9+
- Marca "Add Python to PATH"
- Verifica: `python --version`

### 2️⃣ Instalar Dependencias

```cmd
# Dependencias de Node.js
npm install

# Dependencias de Python (IA)
pip install -r requirements.txt
```

### 3️⃣ Ejecutar

**Terminal 1 - Servidor de IA**:
```cmd
start-ai-server.bat
```

**Terminal 2 - Aplicación Principal**:
```cmd
npm start
```

O usa el archivo `run-as-admin.bat` (clic derecho → Ejecutar como administrador)

## ✅ Verificación Rápida

1. Abre http://localhost:5000/health (debe decir "ok")
2. La aplicación debe abrir automáticamente
3. Verás "🤖 Servidor de IA conectado" en los logs

## 🎯 Primer Uso

1. **Haz clic en "🧠 Analizar con IA"**
   - La IA escaneará tu sistema
   - Verás recomendaciones priorizadas

2. **Prueba el chat**
   - Escribe: "Mi PC va lenta"
   - La IA te responderá con sugerencias

3. **Crea un Restore Point**
   - Clic en "💾 Crear Restore Point"
   - Esto protege tu sistema

4. **Aplica optimizaciones**
   - Primero en modo "Dry Run" (simulación)
   - Luego en modo "Real" si estás conforme

## 📚 Documentación

- **[README.md](README.md)** - Documentación completa
- **[QUICKSTART.md](QUICKSTART.md)** - Guía rápida de uso
- **[AI_SETUP.md](AI_SETUP.md)** - Configuración de IA
- **[SECURITY.md](SECURITY.md)** - Seguridad y mejores prácticas
- **[FAQ.md](docs/FAQ.md)** - Preguntas frecuentes

## 🤖 Características de IA

### Análisis Inteligente
- Detecta problemas automáticamente
- Prioriza por impacto real
- Predice mejoras antes de aplicar

### Asistente Conversacional
Pregunta cosas como:
- "Mi PC va muy lenta"
- "Necesito espacio en disco"
- "Optimiza para juegos"
- "¿Qué servicios puedo desactivar?"

### Modos Inteligentes
- **Gaming**: Máximo rendimiento
- **Diseño**: Para Photoshop, Premiere, etc.
- **Trabajo**: Balance rendimiento/eficiencia
- **Ahorro**: Reduce consumo de energía

## ⚠️ Importante

1. **Ejecuta como Administrador** para funcionalidad completa
2. **Crea Restore Points** antes de optimizaciones importantes
3. **Usa Dry Run** primero para ver qué cambios se aplicarían
4. **Lee los logs** después de cada operación

## 🆘 Problemas Comunes

### "Python no está instalado"
→ Instala Python desde https://www.python.org/

### "node no se reconoce"
→ Instala Node.js desde https://nodejs.org/

### "No se puede ejecutar scripts"
→ Ejecuta en PowerShell como Admin:
```powershell
Set-ExecutionPolicy RemoteSigned -Scope CurrentUser
```

### "Servidor de IA no disponible"
→ Ejecuta `start-ai-server.bat` primero

### "Access Denied"
→ Ejecuta CMD como Administrador

## 🎓 Tutoriales

### Limpieza Básica (Sin IA)
1. Escanear Sistema
2. Crear Restore Point
3. Marcar "Limpiar Temporales"
4. Modo Dry Run → Ver qué se limpiará
5. Modo Real → Aplicar limpieza

### Optimización con IA
1. Analizar con IA
2. Leer recomendaciones
3. Preguntar al chat si tienes dudas
4. Aplicar sugerencias de la IA

### Modo Gaming
1. Chat: "Optimiza para juegos"
2. Seguir instrucciones de la IA
3. Aplicar optimizaciones sugeridas

## 🔧 Configuración Opcional

### API de OpenAI (Mejor IA)
```cmd
setx OPENAI_API_KEY "tu-api-key"
```
Edita `src/ai/ai_server.py`:
```python
assistant = AIAssistant(provider="openai")
```

### API de Groq (Más rápido)
```cmd
setx GROQ_API_KEY "tu-api-key"
```
Edita `src/ai/ai_server.py`:
```python
assistant = AIAssistant(provider="groq")
```

### Sin API (Gratis, Offline)
Por defecto usa modo "fallback" - no requiere configuración.

## 📊 Estructura del Proyecto

```
pc-maintenance-optimizer/
├── src/
│   ├── ai/                  # 🤖 Motor de IA
│   │   ├── ai_server.py     # Servidor Flask
│   │   ├── ai_engine.py     # Análisis inteligente
│   │   └── ai_assistant.py  # Asistente conversacional
│   ├── backend/             # Scripts PowerShell
│   │   └── scripts/         # Optimizaciones del sistema
│   └── ui/                  # Interfaz Electron
│       ├── index.html
│       ├── renderer.js
│       └── styles.css
├── docs/                    # Documentación
├── logs/                    # Logs de operaciones
├── package.json             # Dependencias Node.js
├── requirements.txt         # Dependencias Python
└── start-ai-server.bat      # Iniciar servidor IA
```

## 🎯 Próximos Pasos

1. ✅ Instala todo (Node.js + Python)
2. ✅ Ejecuta la aplicación
3. ✅ Prueba el análisis con IA
4. ✅ Crea un Restore Point
5. ✅ Aplica optimizaciones
6. 📖 Lee la documentación completa
7. ⭐ Dale una estrella en GitHub si te gusta

## 💡 Tips

- **Ejecuta semanalmente** para mantener tu PC óptima
- **Usa el chat de IA** cuando tengas dudas
- **Revisa los logs** para entender qué se hizo
- **Programa mantenimiento** automático con `scheduler.ps1`

## 🤝 Contribuir

¿Quieres mejorar el proyecto?
1. Lee [CONTRIBUTING.md](CONTRIBUTING.md)
2. Revisa [TODO.md](TODO.md) para tareas pendientes
3. Abre un Pull Request

## 📞 Soporte

- **Documentación**: Ver carpeta `docs/`
- **FAQ**: [docs/FAQ.md](docs/FAQ.md)
- **Issues**: Abre un issue en GitHub
- **Logs**: Revisa carpeta `logs/` para debugging

---

**¡Listo para empezar!** 🚀

Ejecuta `start-ai-server.bat` y luego `npm start`
