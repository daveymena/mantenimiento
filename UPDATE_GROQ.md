# 🔄 Actualización: Groq Integrado

## ✅ Cambios Realizados

Se ha integrado completamente el sistema de IA con Groq, incluyendo:

### 1. Sistema de Rotación Automática de Keys

**Archivo**: `src/ai/groq_config.py`

- Gestor de 7 API keys de Groq
- Rotación automática cuando una key alcanza el límite
- Tracking de uso por key (éxitos, errores, última vez usada)
- Persistencia de estado en `logs/groq_keys_state.json`
- Sistema de failover inteligente

### 2. Integración con Asistente

**Archivo**: `src/ai/ai_assistant.py`

- Uso automático del key manager
- Reintentos automáticos (hasta 3 intentos)
- Fallback a modo reglas si todas las keys fallan
- Logs detallados de rotaciones

### 3. Endpoints de Monitoreo

**Archivo**: `src/ai/ai_server.py`

Nuevos endpoints:
- `GET /api/groq-stats` - Estadísticas de uso
- `POST /api/groq-reset` - Resetear keys fallidas
- `GET /health` - Ahora incluye info de Groq

### 4. Script de Prueba

**Archivo**: `src/ai/test_groq.py`

- Prueba todas las keys automáticamente
- Verifica cuáles funcionan
- Prueba el sistema de rotación
- Muestra estadísticas

**Ejecutar**: `test-groq-keys.bat`

### 5. Documentación

**Archivos**:
- `GROQ_KEYS_INFO.md` - Guía completa de las keys
- `AI_SETUP.md` - Actualizado con info de Groq
- `README.md` - Menciona las 7 keys

## 🚀 Cómo Usar

### Inicio Rápido

1. **Instalar dependencias** (si no lo hiciste):
```cmd
pip install -r requirements.txt
```

2. **Iniciar servidor de IA**:
```cmd
start-ai-server.bat
```

3. **Iniciar aplicación**:
```cmd
npm start
```

4. **Usar el chat de IA** en la aplicación

### Verificar que Funciona

1. **Probar las keys**:
```cmd
test-groq-keys.bat
```

Deberías ver:
```
Probando key 1/7: ...KmiTZ
  ✓ Funciona - Respuesta: OK

Probando key 2/7: ...VJp2
  ✓ Funciona - Respuesta: OK

...

Keys funcionando: 7/7
```

2. **Ver estadísticas**:
```cmd
curl http://localhost:5000/api/groq-stats
```

3. **Health check**:
```cmd
curl http://localhost:5000/health
```

Deberías ver:
```json
{
  "status": "ok",
  "service": "AI Maintenance Engine",
  "provider": "groq",
  "groq_stats": {
    "total_keys": 7,
    "current_key_index": 0,
    "failed_keys_count": 0
  }
}
```

## 📊 Capacidad Total

Con 7 keys de Groq:

| Métrica | Por Key | Total (7 keys) |
|---------|---------|----------------|
| Requests/minuto | 30 | **210** |
| Requests/día | 14,400 | **100,800** |
| Tokens/minuto | 6,000 | **42,000** |

**Más que suficiente para uso personal e incluso equipos pequeños.**

## 🔄 Flujo de Rotación

```
Usuario: "Mi PC va lenta"
    ↓
Intenta con Key 1
    ↓
¿Rate limit? → Sí
    ↓
Marca Key 1 como fallida
    ↓
Rota automáticamente a Key 2
    ↓
Intenta con Key 2
    ↓
¿Éxito? → Sí → ✓ Responde al usuario
```

## 🛠️ Comandos Útiles

### Probar todas las keys
```cmd
test-groq-keys.bat
```

### Ver estadísticas
```cmd
curl http://localhost:5000/api/groq-stats
```

### Resetear keys fallidas
```cmd
curl -X POST http://localhost:5000/api/groq-reset
```

### Ver logs de rotación
```cmd
type logs\groq_keys_state.json
```

## 🐛 Solución de Problemas

### "No module named 'groq_config'"

Asegúrate de estar en el directorio correcto:
```cmd
cd src\ai
python ai_server.py
```

O usa el script:
```cmd
start-ai-server.bat
```

### Todas las keys fallan

1. Verifica conexión a internet
2. Ejecuta `test-groq-keys.bat`
3. Resetea keys: `curl -X POST http://localhost:5000/api/groq-reset`

### Chat responde con reglas en lugar de IA

Esto significa que todas las keys están temporalmente agotadas. El sistema usa modo Fallback automáticamente. Espera unos minutos y vuelve a intentar.

## 📝 Archivos Modificados

```
src/ai/
├── groq_config.py          ← NUEVO: Gestor de keys
├── ai_assistant.py         ← MODIFICADO: Integración con Groq
├── ai_server.py            ← MODIFICADO: Nuevos endpoints
└── test_groq.py            ← NUEVO: Script de prueba

Raíz:
├── test-groq-keys.bat      ← NUEVO: Ejecutar pruebas
├── GROQ_KEYS_INFO.md       ← NUEVO: Documentación
├── UPDATE_GROQ.md          ← NUEVO: Este archivo
├── AI_SETUP.md             ← MODIFICADO: Info de Groq
└── README.md               ← MODIFICADO: Menciona 7 keys
```

## ✅ Checklist de Verificación

- [ ] Dependencias instaladas (`pip install -r requirements.txt`)
- [ ] Servidor de IA inicia sin errores
- [ ] `test-groq-keys.bat` muestra keys funcionando
- [ ] Health check responde con info de Groq
- [ ] Chat en la aplicación funciona
- [ ] Rotación automática funciona (probar con rate limit)

## 🎯 Próximos Pasos

1. **Usar la aplicación** normalmente
2. **Monitorear uso** con `/api/groq-stats`
3. **Reportar problemas** si alguna key falla consistentemente
4. **Disfrutar** del asistente de IA sin preocuparte por límites

## 🔒 Seguridad

**⚠️ Importante**: Las API keys están en el código para facilitar el uso.

**Para producción**:
1. Mueve las keys a variables de entorno
2. No subas el código a repositorios públicos sin remover las keys
3. Considera rotar las keys periódicamente

Ver [GROQ_KEYS_INFO.md](GROQ_KEYS_INFO.md) sección "Seguridad" para más detalles.

---

**¿Preguntas?** Consulta [GROQ_KEYS_INFO.md](GROQ_KEYS_INFO.md) o [AI_SETUP.md](AI_SETUP.md)
