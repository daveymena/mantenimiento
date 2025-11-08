# 🤖 Características de IA

## Visión General

PC Maintenance Optimizer integra inteligencia artificial para hacer el mantenimiento más inteligente, automático y efectivo.

## Arquitectura de IA

```
┌─────────────────────────────────────────┐
│         Frontend (Electron)             │
│  ┌──────────────┐  ┌─────────────────┐ │
│  │ AI Analysis  │  │   AI Chat       │ │
│  │   Panel      │  │   Assistant     │ │
│  └──────┬───────┘  └────────┬────────┘ │
└─────────┼────────────────────┼──────────┘
          │                    │
          │   HTTP REST API    │
          │                    │
┌─────────▼────────────────────▼──────────┐
│      AI Server (Flask/Python)           │
│  ┌──────────────┐  ┌─────────────────┐ │
│  │  AI Engine   │  │  AI Assistant   │ │
│  │  (Analysis)  │  │  (Chat)         │ │
│  └──────┬───────┘  └────────┬────────┘ │
└─────────┼────────────────────┼──────────┘
          │                    │
┌─────────▼────────────────────▼──────────┐
│         System Analysis (psutil)        │
│    CPU | RAM | Disk | Processes         │
└─────────────────────────────────────────┘
```

## Componentes de IA

### 1. AI Engine (ai_engine.py)

Motor de análisis y decisiones inteligentes.

**Funciones principales**:

#### `analyze_system()`
Analiza el sistema en tiempo real:
- CPU: uso, cores, frecuencia
- Memoria: uso, disponible, total
- Disco: uso, espacio libre
- Procesos pesados: top 10 por CPU/RAM
- Temperaturas (si disponible)

**Ejemplo de output**:
```json
{
  "cpu": {
    "percent": 45,
    "count": 8,
    "freq": 3600
  },
  "memory": {
    "percent": 72,
    "available_gb": 4.5,
    "total_gb": 16
  },
  "heavy_processes": [
    {"name": "chrome.exe", "cpu": 15.2, "memory": 8.5}
  ]
}
```

#### `get_intelligent_recommendations()`
Genera recomendaciones priorizadas:

**Criterios de decisión**:
- CPU > 80% → Optimizar procesos (prioridad alta)
- RAM > 85% → Liberar memoria (prioridad alta)
- RAM > 70% → Liberar memoria (prioridad media)
- Disco > 90% → Limpiar disco (prioridad crítica)
- Disco > 80% → Limpiar disco (prioridad alta)
- Procesos pesados > 5 → Gestionar procesos (prioridad media)

**Ejemplo de recomendación**:
```json
{
  "priority": "high",
  "category": "memory",
  "action": "free_memory",
  "message": "Memoria al 85%. Solo 2.4 GB disponibles.",
  "impact": "high"
}
```

#### `predict_optimization_impact()`
Predice el impacto de cada acción:

| Acción | Espacio Liberado | Mejora % | Tiempo |
|--------|------------------|----------|--------|
| clean_disk | 2.5 GB | 5% | 3 min |
| free_memory | 15% RAM | 20% | 1 min |
| optimize_processes | 25% CPU | 30% | 2 min |
| optimize_services | 10% RAM | 15% | 2 min |

#### `generate_maintenance_plan()`
Crea un plan completo de mantenimiento:
- Ordena recomendaciones por prioridad
- Calcula impacto total
- Estima tiempo total
- Determina nivel de urgencia

### 2. AI Assistant (ai_assistant.py)

Asistente conversacional inteligente.

**Proveedores soportados**:

#### OpenAI (gpt-3.5-turbo)
- Mejor calidad de respuestas
- Contexto completo del sistema
- ~$0.002 por conversación
- Requiere API key

#### Groq (mixtral-8x7b)
- Más rápido que OpenAI
- Gratis en tier básico
- Buena calidad
- Requiere API key

#### Fallback (Reglas)
- Sin API key necesaria
- Totalmente gratis
- Respuestas basadas en patrones
- Funciona offline

**Intenciones detectadas**:

| Palabras clave | Intención | Respuesta |
|----------------|-----------|-----------|
| lento, lag, tarda | Rendimiento | Analiza RAM/CPU y sugiere optimizaciones |
| espacio, disco, lleno | Almacenamiento | Sugiere limpieza de disco |
| juego, gaming, fps | Gaming | Modo alto rendimiento |
| diseño, photoshop | Diseño | Optimización para creativos |
| seguro, backup | Seguridad | Restore points y backups |

**Ejemplo de conversación**:

```
Usuario: Mi PC va muy lenta cuando abro Chrome

Asistente: Detecté que tu memoria RAM está al 85%. 
Chrome está usando 3.2 GB de RAM.

Recomendaciones:
1. 🧹 Liberar memoria RAM
2. 🗑️ Limpiar cache de Chrome
3. ⚙️ Cerrar pestañas innecesarias

¿Quieres que ejecute estas optimizaciones?
```

### 3. AI Server (ai_server.py)

Servidor Flask que expone la funcionalidad de IA.

**Endpoints**:

```
GET  /api/analyze              - Analiza el sistema
POST /api/recommendations      - Obtiene recomendaciones
GET  /api/maintenance-plan     - Plan completo
POST /api/chat                 - Chat con asistente
POST /api/explain              - Explica una acción
POST /api/predict-impact       - Predice impacto
GET  /health                   - Health check
```

## Casos de Uso

### Caso 1: PC Lenta

**Usuario**: "Mi PC va muy lenta"

**IA analiza**:
- CPU: 85% (alto)
- RAM: 90% (crítico)
- Procesos pesados: Chrome (3GB), Discord (500MB)

**IA recomienda**:
1. Cerrar Chrome y Discord (impacto: 30%)
2. Liberar memoria RAM (impacto: 20%)
3. Limpiar temporales (impacto: 5%)

**Resultado esperado**: 55% de mejora

### Caso 2: Poco Espacio en Disco

**Usuario**: "Me queda poco espacio"

**IA analiza**:
- Disco: 92% usado (crítico)
- Temporales: 3.5 GB
- Cache navegadores: 2.1 GB
- Carpetas grandes: Downloads (15 GB)

**IA recomienda**:
1. Limpiar temporales (libera 3.5 GB)
2. Limpiar cache (libera 2.1 GB)
3. Revisar Downloads (potencial 15 GB)

**Resultado esperado**: 5.6 GB liberados inmediatamente

### Caso 3: Optimizar para Gaming

**Usuario**: "Quiero jugar mejor"

**IA configura**:
1. Plan de energía: Alto Rendimiento
2. Cierra procesos en segundo plano
3. Libera máxima RAM posible
4. Desactiva servicios no críticos
5. Prioriza procesos de juegos

**Resultado esperado**: 30-40% mejora en FPS

## Ventajas de la IA

### vs Mantenimiento Manual

| Aspecto | Manual | Con IA |
|---------|--------|--------|
| Análisis | Usuario decide | IA detecta automáticamente |
| Priorización | No hay | Por impacto real |
| Predicción | No | Sí, antes de aplicar |
| Explicación | Técnica | Lenguaje natural |
| Personalización | No | Aprende de uso |

### Beneficios Clave

1. **Automatización**: No necesitas saber qué optimizar
2. **Inteligencia**: Decisiones basadas en datos reales
3. **Seguridad**: Nunca toca servicios críticos
4. **Explicación**: Entiendes qué hace y por qué
5. **Predicción**: Sabes el impacto antes de aplicar

## Configuración Avanzada

### Cambiar Umbrales

En `ai_engine.py`:

```python
# CPU
if analysis['cpu']['percent'] > 80:  # Cambiar a 70 para ser más agresivo

# RAM
if analysis['memory']['percent'] > 85:  # Cambiar a 75

# Disco
if analysis['disk']['percent'] > 90:  # Cambiar a 80
```

### Personalizar Respuestas

En `ai_assistant.py`, método `_chat_fallback()`:

```python
elif any(word in message_lower for word in ['personalizado']):
    return "Tu respuesta personalizada"
```

### Agregar Nuevas Métricas

En `ai_engine.py`, método `analyze_system()`:

```python
# Agregar análisis de red
network = psutil.net_io_counters()
analysis['network'] = {
    'bytes_sent': network.bytes_sent,
    'bytes_recv': network.bytes_recv
}
```

## Privacidad y Seguridad

### Datos Locales
- Todo el análisis se hace localmente
- No se envía información a internet (excepto con OpenAI/Groq)
- Logs guardados en `logs/ai_history.json`

### Con API Externa (OpenAI/Groq)
- Solo se envía el mensaje del usuario
- Contexto del sistema (opcional)
- No se envían archivos ni datos sensibles
- API keys en variables de entorno

### Recomendaciones
- Usa modo Fallback para máxima privacidad
- Revisa logs regularmente
- No compartas API keys
- Usa variables de entorno para keys

## Limitaciones Actuales

1. **Predicción**: Basada en promedios, no en tu sistema específico
2. **Aprendizaje**: No aprende de acciones pasadas (próximamente)
3. **Modelos locales**: No implementado aún (Ollama próximamente)
4. **Detección de anomalías**: Básica, se mejorará

## Roadmap de IA

### Corto Plazo (1-2 meses)
- [ ] Integración con Ollama (modelos locales)
- [ ] Aprendizaje de patrones de uso
- [ ] Mejores predicciones basadas en historial

### Medio Plazo (3-6 meses)
- [ ] Detección de anomalías avanzada
- [ ] Predicción de fallos
- [ ] Optimización automática programada
- [ ] Modos personalizables por usuario

### Largo Plazo (6+ meses)
- [ ] Modelo propio entrenado en datos de mantenimiento
- [ ] Recomendaciones por tipo de uso (gaming, diseño, etc.)
- [ ] Integración con telemetría (opcional)
- [ ] Comunidad de modelos compartidos

## Contribuir

¿Quieres mejorar la IA?

1. **Mejora los umbrales**: Prueba diferentes valores
2. **Agrega intenciones**: Nuevos patrones de detección
3. **Mejora predicciones**: Algoritmos más precisos
4. **Integra modelos**: Ollama, LLaMA, Mistral
5. **Documenta**: Casos de uso y ejemplos

Ver [CONTRIBUTING.md](../CONTRIBUTING.md) para más detalles.

---

**¿Preguntas sobre IA?** Consulta [AI_SETUP.md](../AI_SETUP.md) o abre un issue.
