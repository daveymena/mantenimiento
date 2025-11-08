# 🚀 Despliegue en Easypanel

Esta guía te ayudará a desplegar el **Servidor de IA** de PC Maintenance Optimizer en Easypanel.

## ⚠️ Nota Importante

Esta aplicación es principalmente una **aplicación de escritorio para Windows**. Lo que se despliega en Easypanel es solo el **servidor de IA** que la aplicación de escritorio consume.

## 📋 Requisitos Previos

1. Cuenta en Easypanel
2. API Keys de Groq (gratuitas en https://console.groq.com/)
3. Repositorio en GitHub (ya configurado)

## 🔧 Pasos de Despliegue

### 1. Preparar el Repositorio

El repositorio ya está configurado con:
- ✅ `Dockerfile` - Configuración de Docker
- ✅ `docker-compose.yml` - Para pruebas locales
- ✅ `.dockerignore` - Archivos a excluir
- ✅ `easypanel.yml` - Configuración de Easypanel

### 2. Configurar en Easypanel

#### Opción A: Usando la Interfaz Web

1. **Accede a Easypanel**
   - Ve a tu panel de Easypanel
   - Click en "Create Project"

2. **Conectar Repositorio**
   - Selecciona "GitHub"
   - Autoriza Easypanel a acceder a tu repositorio
   - Selecciona: `daveymena/mantenimiento`
   - Branch: `main`

3. **Configurar Build**
   - Build Type: `Dockerfile`
   - Dockerfile Path: `Dockerfile`
   - Context: `/`

4. **Configurar Variables de Entorno**
   
   Agrega estas variables en la sección "Environment":
   ```
   GROQ_KEY_1=tu-primera-api-key
   GROQ_KEY_2=tu-segunda-api-key
   GROQ_KEY_3=tu-tercera-api-key
   GROQ_KEY_4=tu-cuarta-api-key
   GROQ_KEY_5=tu-quinta-api-key
   GROQ_KEY_6=tu-sexta-api-key
   GROQ_KEY_7=tu-septima-api-key
   FLASK_ENV=production
   PORT=5000
   ```

5. **Configurar Puerto**
   - Port: `5000`
   - Protocol: `HTTP`

6. **Configurar Dominio**
   - Agrega un dominio personalizado o usa el subdominio de Easypanel
   - Ejemplo: `pc-optimizer-ai.tu-dominio.com`

7. **Deploy**
   - Click en "Deploy"
   - Espera a que el build termine (2-3 minutos)

#### Opción B: Usando CLI

```bash
# Instalar Easypanel CLI
npm install -g @easypanel/cli

# Login
easypanel login

# Deploy
easypanel deploy --config easypanel.yml
```

### 3. Verificar Despliegue

Una vez desplegado, verifica que funcione:

```bash
# Health check
curl https://tu-dominio.com/health

# Debería retornar:
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

### 4. Probar Endpoints

```bash
# Chat con IA
curl -X POST https://tu-dominio.com/api/chat \
  -H "Content-Type: application/json" \
  -d '{"message": "¿Cómo optimizo mi PC?"}'

# Análisis del sistema (simulado)
curl https://tu-dominio.com/api/analyze

# Estadísticas de Groq
curl https://tu-dominio.com/api/groq-stats
```

## 🔄 Actualizar Despliegue

Cada vez que hagas push a GitHub, Easypanel puede redesplegar automáticamente:

1. **Configurar Webhook** (en Easypanel)
   - Ve a Settings > Webhooks
   - Copia la URL del webhook
   
2. **Agregar Webhook en GitHub**
   - Ve a tu repositorio en GitHub
   - Settings > Webhooks > Add webhook
   - Pega la URL de Easypanel
   - Content type: `application/json`
   - Events: `Just the push event`

Ahora cada push a `main` desplegará automáticamente.

## 🔧 Configuración Avanzada

### Escalado

En Easypanel, puedes escalar el servicio:
- Replicas: 1-10 instancias
- CPU: 0.5-4 cores
- RAM: 512MB-8GB

Recomendado para producción:
- Replicas: 2
- CPU: 1 core
- RAM: 1GB

### Logs

Ver logs en tiempo real:
```bash
easypanel logs pc-optimizer-ai --follow
```

O en la interfaz web: Project > Logs

### Monitoreo

Easypanel incluye métricas automáticas:
- CPU usage
- Memory usage
- Network traffic
- Request count
- Response time

### Backup

Los logs se guardan en volumen persistente:
```yaml
volumes:
  - ./logs:/app/logs
```

## 🔐 Seguridad

### Variables de Entorno

✅ **Correcto**: Usar variables de entorno en Easypanel
❌ **Incorrecto**: Hardcodear API keys en el código

### HTTPS

Easypanel proporciona HTTPS automático con Let's Encrypt.

### Rate Limiting

Considera agregar rate limiting para producción:

```python
from flask_limiter import Limiter

limiter = Limiter(
    app,
    key_func=lambda: request.remote_addr,
    default_limits=["100 per hour"]
)
```

## 🐛 Solución de Problemas

### Build Falla

**Error**: `requirements.txt not found`
- Verifica que `requirements.txt` esté en la raíz del repo

**Error**: `Python version mismatch`
- El Dockerfile usa Python 3.11, verifica compatibilidad

### Aplicación No Inicia

**Error**: `Port already in use`
- Verifica que el puerto 5000 esté disponible
- Cambia la variable `PORT` si es necesario

**Error**: `No API keys found`
- Verifica que las variables de entorno estén configuradas
- Revisa los logs: `easypanel logs pc-optimizer-ai`

### API Keys No Funcionan

**Error**: `Invalid API key`
- Verifica que las keys sean válidas en https://console.groq.com/
- Asegúrate de copiar las keys completas
- No incluyas espacios al inicio o final

**Error**: `Rate limit exceeded`
- El sistema rotará automáticamente a la siguiente key
- Verifica estadísticas: `curl https://tu-dominio.com/api/groq-stats`

## 📊 Monitoreo de Producción

### Health Checks

Easypanel ejecuta health checks automáticos:
```yaml
healthcheck:
  test: ["CMD", "curl", "-f", "http://localhost:5000/health"]
  interval: 30s
  timeout: 10s
  retries: 3
```

### Alertas

Configura alertas en Easypanel para:
- Servicio caído
- Alto uso de CPU/RAM
- Errores frecuentes

### Métricas Personalizadas

Endpoint de estadísticas:
```bash
curl https://tu-dominio.com/api/groq-stats
```

Retorna:
```json
{
  "success": true,
  "stats": {
    "total_keys": 7,
    "current_key_index": 2,
    "failed_keys_count": 0,
    "key_usage": {
      "gsk_...": {
        "success_count": 150,
        "error_count": 2,
        "last_used": "2025-11-08T15:30:00"
      }
    }
  }
}
```

## 🔄 Conectar Aplicación de Escritorio

Una vez desplegado, actualiza la aplicación de escritorio para usar el servidor remoto:

En `src/backend/executor.js`:
```javascript
const AI_SERVER_URL = process.env.AI_SERVER_URL || 'https://tu-dominio.com';

async function analyzeWithAI() {
    const response = await fetch(`${AI_SERVER_URL}/api/analyze`);
    return await response.json();
}
```

## 💰 Costos

### Easypanel
- Plan básico: ~$5-10/mes
- Incluye: SSL, dominio, monitoreo

### Groq API
- Tier gratuito: 0$/mes
- 30 req/min por key
- Con 7 keys: 210 req/min gratis

**Total estimado**: $5-10/mes

## 📚 Recursos

- [Documentación de Easypanel](https://easypanel.io/docs)
- [Groq API Docs](https://console.groq.com/docs)
- [Docker Best Practices](https://docs.docker.com/develop/dev-best-practices/)

## 🆘 Soporte

¿Problemas con el despliegue?
- Issues: https://github.com/daveymena/mantenimiento/issues
- Easypanel Support: https://easypanel.io/support

---

## ✅ Checklist de Despliegue

- [ ] Obtener API keys de Groq
- [ ] Crear proyecto en Easypanel
- [ ] Conectar repositorio GitHub
- [ ] Configurar variables de entorno
- [ ] Configurar puerto (5000)
- [ ] Agregar dominio personalizado
- [ ] Deploy inicial
- [ ] Verificar health check
- [ ] Probar endpoints
- [ ] Configurar webhook para auto-deploy
- [ ] Configurar alertas
- [ ] Actualizar aplicación de escritorio con URL del servidor

¡Listo para producción! 🚀
