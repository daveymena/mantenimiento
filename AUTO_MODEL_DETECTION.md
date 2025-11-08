# 🤖 Detección Automática de Modelos

## ✅ Nueva Funcionalidad Implementada

El sistema ahora **detecta automáticamente** cuando un modelo de Groq no está disponible y prueba con otros modelos.

## 🎯 Cómo Funciona

### Detección Automática en Tiempo Real

Cuando el chat intenta usar un modelo y recibe error:

```
⚠️ Error de Groq: The model 'mixtral-8x7b-32768' has been decommissioned
```

El sistema automáticamente:
1. ✅ Detecta que el modelo no está disponible
2. ✅ Prueba con el siguiente modelo de la lista
3. ✅ Continúa hasta encontrar uno que funcione
4. ✅ Si ninguno funciona, usa modo Fallback

### Lista de Modelos (Orden de Preferencia)

```python
1. llama-3.1-70b-versatile      # Recomendado (balance calidad/velocidad)
2. llama-3.2-90b-text-preview   # Más potente
3. llama-3.1-8b-instant         # Más rápido
4. mixtral-8x7b-32768           # Legacy (por si vuelve)
```

## 🔍 Detectar Modelos Disponibles Manualmente

### Ejecutar Script de Detección

```cmd
detect-models.bat
```

O manualmente:
```cmd
cd src\ai
python auto_detect_models.py
```

### Resultado Esperado

```
🔍 Detectando modelos disponibles en Groq...

Probando: llama-3.1-70b-versatile... ✅ Disponible
Probando: llama-3.2-90b-text-preview... ✅ Disponible
Probando: llama-3.1-8b-instant... ✅ Disponible
Probando: mixtral-8x7b-32768... ❌ Descontinuado

==================================================
✅ Modelos disponibles: 3
  - llama-3.1-70b-versatile
  - llama-3.2-90b-text-preview
  - llama-3.1-8b-instant

❌ Modelos descontinuados: 1
  - mixtral-8x7b-32768
==================================================

💡 Recomendación: Usa 'llama-3.1-70b-versatile' como modelo principal
```

## 🔄 Flujo de Failover Automático

```
Usuario: "Hola"
    ↓
Intenta con: llama-3.1-70b-versatile
    ↓
¿Funciona? → Sí → ✅ Responde
    ↓
    No (modelo descontinuado)
    ↓
Intenta con: llama-3.2-90b-text-preview
    ↓
¿Funciona? → Sí → ✅ Responde
    ↓
    No
    ↓
Intenta con: llama-3.1-8b-instant
    ↓
¿Funciona? → Sí → ✅ Responde
    ↓
    No (todos fallaron)
    ↓
Modo Fallback (respuestas basadas en reglas)
```

## 📊 Comparación de Modelos

| Modelo | Tamaño | Velocidad | Calidad | Estado |
|--------|--------|-----------|---------|--------|
| llama-3.1-70b-versatile | 70B | ⚡⚡⚡ | ⭐⭐⭐⭐ | ✅ Activo |
| llama-3.2-90b-text-preview | 90B | ⚡⚡ | ⭐⭐⭐⭐⭐ | ✅ Activo |
| llama-3.1-8b-instant | 8B | ⚡⚡⚡⚡⚡ | ⭐⭐⭐ | ✅ Activo |
| mixtral-8x7b-32768 | 47B | ⚡⚡⚡ | ⭐⭐⭐⭐ | ❌ Descontinuado |

## 🛠️ Configuración Manual (Opcional)

Si quieres forzar un modelo específico, edita `src/ai/ai_assistant.py`:

```python
available_models = [
    "llama-3.2-90b-text-preview",  # Cambia el orden
    "llama-3.1-70b-versatile",
    "llama-3.1-8b-instant"
]
```

## 🔧 Archivos Creados/Modificados

### Nuevos Archivos

1. **`detect-models.bat`** - Script para detectar modelos disponibles
2. **`src/ai/auto_detect_models.py`** - Lógica de detección
3. **`AUTO_MODEL_DETECTION.md`** - Esta documentación

### Archivos Modificados

1. **`src/ai/ai_assistant.py`**:
   - Lista de modelos disponibles
   - Detección automática de modelos descontinuados
   - Failover automático entre modelos
   - Logs informativos

## ✅ Ventajas

1. **Automático**: No requiere intervención manual
2. **Resiliente**: Si un modelo falla, prueba con otro
3. **Actualizable**: Fácil agregar nuevos modelos a la lista
4. **Informativo**: Logs claros de qué modelo se está usando
5. **Fallback**: Siempre funciona, incluso sin modelos disponibles

## 🚀 Uso

### No Requiere Configuración

El sistema funciona automáticamente. Solo:

1. **Reinicia el servidor de IA**:
```cmd
.\start-ai-server.bat
```

2. **Usa el chat normalmente**

El sistema detectará y usará el mejor modelo disponible.

### Verificar Qué Modelo Está Usando

En los logs del servidor verás:
```
🤖 Usando Groq con key: ...KmiTZ
⚠️ Modelo 'mixtral-8x7b-32768' no disponible, probando siguiente...
✅ Usando modelo: llama-3.1-70b-versatile
```

## 🐛 Solución de Problemas

### Todos los modelos fallan

Si ves:
```
❌ Ningún modelo de Groq disponible, usando fallback
```

**Causas posibles**:
1. Sin conexión a internet
2. Keys de Groq inválidas
3. Groq está caído (raro)

**Solución**:
```cmd
# Probar keys
.\test-groq-keys.bat

# Detectar modelos
detect-models.bat

# Verificar conexión
curl https://api.groq.com
```

### Quiero usar un modelo específico

Edita `src/ai/ai_assistant.py` y pon tu modelo preferido primero en la lista.

## 📝 Logs Útiles

El sistema genera logs informativos:

```
⚠️ Modelo 'mixtral-8x7b-32768' no disponible, probando siguiente...
✅ Usando modelo: llama-3.1-70b-versatile
🔄 Rotando API key: ...KmiTZ → ...VJp2 (Razón: rate_limit)
```

---

**¡El sistema ahora es completamente automático y resiliente!** 🎉

No necesitas preocuparte por modelos descontinuados, el sistema se adapta automáticamente.
