# 🤖 Servidor de IA - PC Maintenance Optimizer

Este es el servidor de IA que proporciona análisis inteligente y recomendaciones para la aplicación de escritorio PC Maintenance Optimizer.

## 🌐 Despliegue

### Opciones de Despliegue

1. **Easypanel** (Recomendado) - Ver [EASYPANEL_DEPLOYMENT.md](EASYPANEL_DEPLOYMENT.md)
2. **Docker** - Usar `docker-compose.yml`
3. **Local** - Ejecutar directamente con Python

## 🚀 Inicio Rápido

### Opción 1: Docker Compose (Más Fácil)

```bash
# 1. Configurar variables de entorno
copy .env.example .env
# Edita .env y agrega tus API keys de Groq

# 2. Iniciar servidor
docker-compose up -d

# 3. Verificar
curl http://localhost:5000/health
```

### Opción 2: Docker Manual

```bash
# 1. Construir imagen
docker build -t pc-optimizer-ai .

# 2. Ejecutar contenedor
docker run -d \
  --name pc-optimizer-ai \
  -p 5000:5000 \
  -e GROQ_KEY_1="tu-key-1" \
  -e GROQ_KEY_2="tu-key-2" \
  pc-optimizer-ai

# 3. Verificar
curl http://localhost:5000/health
```

### Opción 3: Local (Desarrollo)

```bash
# 1. Instalar dependencias
pip install -r requirements.txt

# 2. Configurar variables de entorno
setx GROQ_KEY_1 "tu-key-1"
setx GROQ_KEY_2 "tu-key-2"

# 3. Iniciar servidor
python src/ai/ai_server.py
```

## 📡 API Endpoints

### Health Check
```bash
GET /health
```

Respuesta:
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

### Análisis del Sistema
```bash
GET /api/analyze
```

Retorna métricas y análisis del sistema.

### Recomendaciones Inteligentes
```bash
POST /api/recommendations
Content-Type: application/json

{
  "analysis": {
    "cpu_usage": 85,
    "ram_usage": 90,
    "disk_usage": 75
  }
}
```

### Chat con IA
```bash
POST /api/chat
Content-Type: application/json

{
  "message": "¿Cómo optimizo mi PC?",
  "context": {
    "cpu_usage": 85,
    "ram_usage": 90
  }
}
```

### Explicar Acción
```bash
POST /api/explain
Content-Type: application/json

{
  "action": "clean_temp_files",
  "context": {
    "temp_size": "2.5 GB"
  }
}
```

### Predecir Impacto
```bash
POST /api/predict-impact
Content-Type: application/json

{
  "action": "disable_startup_apps",
  "current_state": {
    "startup_apps": 15,
    "boot_time": 45
  }
}
```

### Estadísticas de Groq
```bash
GET /api/groq-stats
```

### Resetear Keys Fallidas
```bash
POST /api/groq-reset
```

## 🔧 Configuración

### Variables de Entorno

| Variable | Descripción | Requerido |
|----------|-------------|-----------|
| `GROQ_KEY_1` | Primera API key de Groq | Sí |
| `GROQ_KEY_2` | Segunda API key de Groq | No |
| `GROQ_KEY_3` | Tercera API key de Groq | No |
| `GROQ_KEY_4` | Cuarta API key de Groq | No |
| `GROQ_KEY_5` | Quinta API key de Groq | No |
| `GROQ_KEY_6` | Sexta API key de Groq | No |
| `GROQ_KEY_7` | Séptima API key de Groq | No |
| `FLASK_ENV` | Entorno (development/production) | No |
| `PORT` | Puerto del servidor (default: 5000) | No |

### Obtener API Keys

1. Ve a https://console.groq.com/
2. Crea una cuenta gratuita
3. Genera API keys en la sección "API Keys"
4. Copia las keys y configúralas como variables de entorno

## 🔄 Sistema de Rotación de Keys

El servidor incluye rotación automática de API keys:

- **Rotación automática**: Si una key alcanza el límite, rota a la siguiente
- **Failover inteligente**: Keys fallidas se marcan y se saltan
- **Tracking de uso**: Contador de éxitos/errores por key
- **Modo fallback**: Si todas las keys fallan, usa respuestas basadas en reglas

Ver estadísticas:
```bash
curl http://localhost:5000/api/groq-stats
```

Resetear keys fallidas:
```bash
curl -X POST http://localhost:5000/api/groq-reset
```

## 📊 Monitoreo

### Logs

Ver logs en tiempo real:
```bash
# Docker Compose
docker-compose logs -f

# Docker
docker logs -f pc-optimizer-ai

# Local
# Los logs se guardan en logs/
```

### Métricas

El servidor expone métricas en `/health` y `/api/groq-stats`.

## 🐛 Solución de Problemas

### Servidor no inicia

**Error**: `Port 5000 already in use`
```bash
# Cambiar puerto
docker run -p 5001:5000 ...
# O configurar variable PORT
```

**Error**: `No API keys found`
```bash
# Verificar variables de entorno
docker exec pc-optimizer-ai env | grep GROQ
```

### API Keys no funcionan

**Error**: `Invalid API key`
- Verifica que las keys sean válidas en https://console.groq.com/
- Asegúrate de copiar las keys completas sin espacios

**Error**: `Rate limit exceeded`
- El sistema rotará automáticamente
- Agrega más keys para mayor capacidad

### Errores de IA

**Error**: `All keys failed`
- Verifica conexión a internet
- Resetea keys fallidas: `curl -X POST http://localhost:5000/api/groq-reset`
- Revisa estadísticas: `curl http://localhost:5000/api/groq-stats`

## 🔐 Seguridad

### Producción

Para producción, considera:

1. **HTTPS**: Usa un proxy reverso (Nginx, Caddy) o Easypanel
2. **Rate Limiting**: Limita requests por IP
3. **Authentication**: Agrega API keys o JWT
4. **CORS**: Configura orígenes permitidos
5. **Secrets**: Usa gestores de secretos (no variables de entorno en código)

### Ejemplo con Rate Limiting

```python
from flask_limiter import Limiter

limiter = Limiter(
    app,
    key_func=lambda: request.remote_addr,
    default_limits=["100 per hour", "10 per minute"]
)

@app.route('/api/chat', methods=['POST'])
@limiter.limit("20 per minute")
def chat():
    # ...
```

## 📈 Escalado

### Horizontal

Ejecuta múltiples instancias:
```bash
docker-compose up --scale ai-server=3
```

### Vertical

Aumenta recursos:
```yaml
services:
  ai-server:
    deploy:
      resources:
        limits:
          cpus: '2'
          memory: 2G
```

## 🧪 Testing

### Pruebas Locales

```bash
# Windows
test-docker.bat

# O con Docker Compose
test-docker-compose.bat
```

### Pruebas de Endpoints

```bash
# Health check
curl http://localhost:5000/health

# Chat
curl -X POST http://localhost:5000/api/chat \
  -H "Content-Type: application/json" \
  -d '{"message": "Hola"}'

# Análisis
curl http://localhost:5000/api/analyze
```

## 📚 Documentación Adicional

- [Despliegue en Easypanel](EASYPANEL_DEPLOYMENT.md)
- [Configuración de API Keys](CONFIGURACION_API_KEYS.md)
- [Sistema de Rotación de Keys](GROQ_KEYS_INFO.md)
- [Documentación Principal](README.md)

## 🤝 Contribuir

¿Encontraste un bug? ¿Tienes una mejora?

1. Fork el repositorio
2. Crea una rama: `git checkout -b feature/mejora`
3. Commit: `git commit -m "Agregar mejora"`
4. Push: `git push origin feature/mejora`
5. Abre un Pull Request

## 📄 Licencia

MIT License - Ver [LICENSE](LICENSE)

---

**¿Necesitas ayuda?** Abre un [issue](https://github.com/daveymena/mantenimiento/issues)
