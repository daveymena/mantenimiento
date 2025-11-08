# 🔑 Información de API Keys de Groq

## Configuración Automática

El proyecto incluye **7 API keys de Groq** pre-configuradas con sistema de rotación automática.

### API Keys Incluidas

⚠️ **IMPORTANTE**: Las API keys deben configurarse mediante variables de entorno.

```bash
# Configura tus propias API keys de Groq
setx GROQ_KEY_1 "tu-api-key-1"
setx GROQ_KEY_2 "tu-api-key-2"
setx GROQ_KEY_3 "tu-api-key-3"
# ... hasta 7 keys
```

Para obtener API keys gratuitas de Groq:
1. Visita https://console.groq.com/
2. Crea una cuenta gratuita
3. Genera tus API keys en la sección "API Keys"

## Características del Sistema

### ✅ Rotación Automática
- Cuando una key alcanza el límite de rate, automáticamente rota a la siguiente
- Si una key falla, se marca y se salta en futuras rotaciones
- Sistema de reintentos (3 intentos por defecto)

### 📊 Tracking de Uso
- Contador de éxitos por key
- Contador de errores por key
- Última vez que se usó cada key
- Estado de keys fallidas

### 🔄 Failover Inteligente
- Si todas las keys fallan, usa modo Fallback (respuestas basadas en reglas)
- Reseteo automático de keys fallidas después de un tiempo
- Logs detallados de cada rotación

## Comandos Útiles

### Probar Todas las Keys

```cmd
test-groq-keys.bat
```

Esto probará cada key y mostrará:
- ✓ Keys funcionando
- ✗ Keys con error
- Resumen de disponibilidad

### Ver Estadísticas de Uso

```cmd
curl http://localhost:5000/api/groq-stats
```

Respuesta:
```json
{
  "success": true,
  "stats": {
    "total_keys": 7,
    "current_key_index": 2,
    "failed_keys_count": 0,
    "key_usage": {
      "gsk_AE4a...": {
        "success_count": 15,
        "error_count": 0,
        "last_used": "2025-11-06T15:30:45"
      }
    }
  }
}
```

### Resetear Keys Fallidas

```cmd
curl -X POST http://localhost:5000/api/groq-reset
```

Esto limpia la lista de keys marcadas como fallidas.

### Ver Estado en Health Check

```cmd
curl http://localhost:5000/health
```

Respuesta:
```json
{
  "status": "ok",
  "service": "AI Maintenance Engine",
  "provider": "groq",
  "groq_stats": {
    "total_keys": 7,
    "current_key_index": 2,
    "failed_keys_count": 0
  }
}
```

## Flujo de Rotación

```
Usuario hace pregunta
    ↓
Intenta con Key 1
    ↓
¿Éxito? → Sí → ✓ Responde
    ↓
    No (Rate limit / Error)
    ↓
Marca Key 1 como fallida
    ↓
Rota a Key 2
    ↓
Intenta con Key 2
    ↓
¿Éxito? → Sí → ✓ Responde
    ↓
    No
    ↓
Rota a Key 3
    ↓
... (hasta 3 reintentos)
    ↓
Si todas fallan → Modo Fallback
```

## Límites de Groq

### Tier Gratuito (por key)
- **Requests por minuto**: 30
- **Requests por día**: 14,400
- **Tokens por minuto**: 6,000

### Con 7 Keys
- **Requests por minuto**: 210 (30 × 7)
- **Requests por día**: 100,800 (14,400 × 7)
- **Tokens por minuto**: 42,000 (6,000 × 7)

**Más que suficiente para uso personal e incluso pequeños equipos.**

## Archivos Relacionados

- `src/ai/groq_config.py` - Gestor de keys
- `src/ai/ai_assistant.py` - Integración con asistente
- `src/ai/test_groq.py` - Script de prueba
- `logs/groq_keys_state.json` - Estado persistente

## Logs

El sistema guarda logs en:
- `logs/groq_keys_state.json` - Estado de keys (índice actual, fallidas, uso)
- `logs/ai_history.json` - Historial de conversaciones

## Solución de Problemas

### Todas las keys fallan

1. **Verificar conexión a internet**
2. **Probar keys manualmente**:
   ```cmd
   test-groq-keys.bat
   ```
3. **Resetear keys fallidas**:
   ```cmd
   curl -X POST http://localhost:5000/api/groq-reset
   ```
4. **Revisar logs del servidor**

### Una key específica no funciona

El sistema automáticamente la saltará y usará la siguiente. No requiere acción manual.

### Rate limit alcanzado

El sistema rotará automáticamente a la siguiente key disponible.

### Modo Fallback activado

Si ves respuestas basadas en reglas en lugar de IA:
1. Todas las keys están agotadas temporalmente
2. Espera unos minutos y vuelve a intentar
3. O resetea las keys fallidas

## Seguridad

### ⚠️ Importante

- Las API keys están en el código para facilitar el uso
- **NO subas este código a repositorios públicos** sin remover las keys
- Para producción, usa variables de entorno
- Considera rotar las keys periódicamente

### Para Producción

Edita `src/ai/groq_config.py`:

```python
# En lugar de hardcodear las keys
self.api_keys = [
    os.getenv('GROQ_KEY_1'),
    os.getenv('GROQ_KEY_2'),
    # ...
]
```

Y configura variables de entorno:
```cmd
setx GROQ_KEY_1 "tu-key-1"
setx GROQ_KEY_2 "tu-key-2"
```

## Monitoreo

### Ver uso en tiempo real

```python
from groq_config import groq_key_manager

# Ver estadísticas
stats = groq_key_manager.get_stats()
print(stats)

# Ver key actual
current = groq_key_manager.get_current_key()
print(f"Key actual: ...{current[-10:]}")
```

### Dashboard (futuro)

Planeamos agregar un dashboard web para visualizar:
- Uso por key
- Tasa de éxito/error
- Gráficos de uso en el tiempo
- Alertas de límites

## Preguntas Frecuentes

### ¿Puedo agregar más keys?

Sí, edita `src/ai/groq_config.py` y agrega a la lista `self.api_keys`.

### ¿Puedo usar solo algunas keys?

Sí, comenta o elimina las que no quieras usar de la lista.

### ¿Qué pasa si una key expira?

El sistema la marcará como fallida y usará las demás. Actualiza la key en el código.

### ¿Puedo usar OpenAI en lugar de Groq?

Sí, edita `src/ai/ai_server.py`:
```python
assistant = AIAssistant(provider="openai", api_key="tu-openai-key")
```

### ¿Funciona sin API keys?

Sí, el sistema tiene modo Fallback con respuestas basadas en reglas. No es tan inteligente pero funciona offline.

---

**¿Problemas con las keys?** Ejecuta `test-groq-keys.bat` para diagnosticar.
