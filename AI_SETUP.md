# 🤖 Configuración de IA

## Instalación Rápida

### 1. Instalar Python

Si no tienes Python instalado:
1. Descarga desde: https://www.python.org/ (versión 3.9+)
2. Durante la instalación, marca "Add Python to PATH"
3. Verifica: `python --version`

### 2. Instalar Dependencias de IA

```cmd
pip install -r requirements.txt
```

Esto instalará:
- `psutil` - Análisis del sistema
- `flask` - Servidor API
- `flask-cors` - CORS para Electron
- `requests` - HTTP client
- `openai` - API de OpenAI (opcional)

### 3. Iniciar Servidor de IA

**Opción A - Script automático**:
```cmd
start-ai-server.bat
```

**Opción B - Manual**:
```cmd
cd src\ai
python ai_server.py
```

El servidor iniciará en: http://localhost:5000

### 4. Iniciar Aplicación Principal

En otra terminal:
```cmd
npm start
```

## Configuración de Proveedores de IA

### ✅ Groq (Configurado por Defecto)

**Ya está listo para usar.** El proyecto incluye 7 API keys de Groq con rotación automática.

No requiere configuración. Solo inicia el servidor:
```cmd
start-ai-server.bat
```

Ver [GROQ_KEYS_INFO.md](GROQ_KEYS_INFO.md) para más detalles.

### Modo Fallback (Sin API - Gratis)

Si prefieres no usar APIs externas, cambia en `ai_server.py`:

```python
assistant = AIAssistant(provider="fallback")
```

Usa respuestas basadas en reglas. Funciona offline pero es menos inteligente.

### OpenAI (Recomendado para mejor calidad)

1. Obtén API key en: https://platform.openai.com/api-keys
2. Configura variable de entorno:

```cmd
setx OPENAI_API_KEY "tu-api-key-aqui"
```

3. Cambia el provider en `ai_server.py`:

```python
assistant = AIAssistant(provider="openai")
```

**Costo**: ~$0.002 por conversación (muy económico)

### Groq (✅ Configurado por Defecto - Recomendado)

**¡Ya está configurado!** El proyecto incluye 7 API keys de Groq con rotación automática.

**Características**:
- ✅ **7 API keys** pre-configuradas
- ✅ **Rotación automática** cuando una se agota
- ✅ **Más rápido** que OpenAI
- ✅ **Sin configuración** necesaria
- ✅ **Tracking de uso** por key
- ✅ **Failover inteligente** si una key falla

**Probar las keys**:
```cmd
test-groq-keys.bat
```

**Ver estadísticas**:
```cmd
curl http://localhost:5000/api/groq-stats
```

**Resetear keys fallidas**:
```cmd
curl -X POST http://localhost:5000/api/groq-reset
```

**Más información**: Ver [GROQ_KEYS_INFO.md](GROQ_KEYS_INFO.md)

**Ventajas**: 
- Más rápido que OpenAI
- 7 keys = 210 requests/min (vs 30 con una sola)
- Failover automático
- Sin configuración manual

### Modelo Local (Ollama - Totalmente Offline)

**Próximamente** - Integración con Ollama para modelos locales como LLaMA, Mistral, etc.

## Características de IA

### 🧠 Análisis Inteligente

- Monitoreo en tiempo real de CPU, RAM, disco
- Detección de procesos pesados
- Recomendaciones priorizadas por impacto
- Predicción de mejoras de rendimiento

### 💬 Asistente Conversacional

Pregunta cosas como:
- "Mi PC va muy lenta"
- "Necesito espacio en disco"
- "Optimiza para juegos"
- "¿Qué servicios puedo desactivar?"

### 📊 Predicción de Impacto

Antes de aplicar cambios, la IA predice:
- Espacio liberado
- Mejora de rendimiento (%)
- Tiempo estimado

### 🎯 Modos Inteligentes

- **Gaming**: Máximo rendimiento para juegos
- **Diseño**: Optimizado para Photoshop, Premiere, etc.
- **Ahorro**: Reduce consumo de energía
- **Trabajo**: Balance entre rendimiento y eficiencia

## API Endpoints

### GET /api/analyze
Analiza el sistema y retorna métricas

**Response**:
```json
{
  "success": true,
  "data": {
    "cpu": { "percent": 45, "count": 8 },
    "memory": { "percent": 72, "available_gb": 4.5 },
    "disk": { "percent": 65, "free_gb": 120 },
    "heavy_processes": [...]
  }
}
```

### POST /api/recommendations
Obtiene recomendaciones inteligentes

**Request**:
```json
{
  "analysis": { ... }
}
```

**Response**:
```json
{
  "success": true,
  "data": [
    {
      "priority": "high",
      "category": "memory",
      "action": "free_memory",
      "message": "Memoria al 85%. Recomiendo liberar RAM.",
      "impact": "high"
    }
  ]
}
```

### POST /api/chat
Chat con asistente IA

**Request**:
```json
{
  "message": "Mi PC va lenta",
  "context": { ... }
}
```

**Response**:
```json
{
  "success": true,
  "response": "Detecté que tu memoria RAM está al 85%..."
}
```

### POST /api/predict-impact
Predice impacto de una acción

**Request**:
```json
{
  "action": "clean_disk",
  "current_state": { ... }
}
```

**Response**:
```json
{
  "success": true,
  "impact": {
    "disk_freed_gb": 2.5,
    "performance_gain": 5,
    "time_minutes": 3
  }
}
```

## Solución de Problemas

### Error: "Python no está instalado"

Instala Python desde https://www.python.org/

### Error: "No module named 'flask'"

```cmd
pip install -r requirements.txt
```

### Error: "Address already in use"

El puerto 5000 está ocupado. Cambia el puerto en `ai_server.py`:

```python
app.run(host='0.0.0.0', port=5001, debug=True)
```

Y actualiza `AI_SERVER_URL` en `renderer.js`:

```javascript
const AI_SERVER_URL = 'http://localhost:5001';
```

### Servidor de IA no responde

1. Verifica que esté corriendo: http://localhost:5000/health
2. Revisa logs en la terminal del servidor
3. Verifica firewall de Windows

### Chat no funciona

1. Verifica que el servidor esté corriendo
2. Abre consola del navegador (F12) para ver errores
3. Prueba el endpoint manualmente:

```cmd
curl http://localhost:5000/api/chat -X POST -H "Content-Type: application/json" -d "{\"message\":\"test\"}"
```

## Personalización

### Cambiar System Prompt

Edita `ai_assistant.py`:

```python
self.system_prompt = """Tu prompt personalizado aquí..."""
```

### Agregar Nuevas Reglas de Fallback

En `ai_assistant.py`, método `_chat_fallback()`:

```python
elif any(word in message_lower for word in ['tu', 'palabras']):
    return "Tu respuesta personalizada"
```

### Ajustar Umbrales de Recomendaciones

En `ai_engine.py`, método `get_intelligent_recommendations()`:

```python
if analysis['cpu']['percent'] > 90:  # Cambiar umbral
    recommendations.append(...)
```

## Próximas Características

- [ ] Integración con Ollama (modelos locales)
- [ ] Aprendizaje de patrones de uso
- [ ] Recomendaciones personalizadas por usuario
- [ ] Detección de anomalías
- [ ] Predicción de fallos
- [ ] Optimización automática programada

## Costos Estimados

### OpenAI (gpt-3.5-turbo)
- ~$0.002 por conversación
- ~$0.10 por 50 conversaciones
- Muy económico para uso personal

### Groq (llama-3.1-70b-versatile) - ✅ Configurado
- **7 keys incluidas** con rotación automática
- Gratis en tier básico
- Más rápido que OpenAI
- Modelo actualizado (LLaMA 3.1 70B)
- Límite: 210 req/min (30 × 7 keys)
- 100,800 requests/día (14,400 × 7 keys)

### Fallback (Sin API)
- Totalmente gratis
- Sin límites
- Respuestas basadas en reglas

## Seguridad

- El servidor de IA corre localmente (localhost)
- No se envían datos a internet (excepto si usas OpenAI/Groq)
- API keys se guardan en variables de entorno
- Logs de IA en `logs/ai_history.json`

---

**¿Problemas?** Consulta [FAQ.md](docs/FAQ.md) o abre un issue en GitHub.
