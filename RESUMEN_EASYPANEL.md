# ✅ Proyecto Preparado para Easypanel

## 🎉 ¡Completado!

Tu proyecto está listo para desplegarse en Easypanel.

## 📦 Archivos Creados

### Configuración de Docker
- ✅ `Dockerfile` - Imagen Docker del servidor de IA
- ✅ `docker-compose.yml` - Para pruebas locales
- ✅ `.dockerignore` - Archivos a excluir del build

### Configuración de Easypanel
- ✅ `easypanel.yml` - Configuración de despliegue

### Documentación
- ✅ `EASYPANEL_DEPLOYMENT.md` - Guía completa de despliegue
- ✅ `AI_SERVER_README.md` - Documentación del servidor de IA

### Scripts de Prueba
- ✅ `test-docker.bat` - Probar con Docker
- ✅ `test-docker-compose.bat` - Probar con Docker Compose

## ⚠️ Importante: Entender la Arquitectura

### Lo que SE PUEDE desplegar en Easypanel:
✅ **Servidor de IA** (Puerto 5000)
- API REST con endpoints de IA
- Sistema de rotación de API keys de Groq
- Análisis y recomendaciones inteligentes
- Chat conversacional

### Lo que NO se puede desplegar en Easypanel:
❌ **Aplicación de Escritorio Electron**
- Interfaz gráfica de Windows
- Scripts de PowerShell
- Optimizaciones del sistema
- Gestión de servicios de Windows

### Arquitectura Recomendada:

```
┌─────────────────────────────────────┐
│   PC del Usuario (Windows)          │
│                                     │
│  ┌──────────────────────────────┐  │
│  │  Aplicación de Escritorio    │  │
│  │  (Electron)                  │  │
│  │                              │  │
│  │  - Interfaz gráfica          │  │
│  │  - Scripts PowerShell        │  │
│  │  - Optimizaciones locales    │  │
│  └──────────┬───────────────────┘  │
│             │                       │
│             │ HTTP/HTTPS            │
└─────────────┼───────────────────────┘
              │
              │ Internet
              │
┌─────────────▼───────────────────────┐
│   Easypanel (Cloud)                 │
│                                     │
│  ┌──────────────────────────────┐  │
│  │  Servidor de IA              │  │
│  │  (Flask + Python)            │  │
│  │                              │  │
│  │  - API REST                  │  │
│  │  - Análisis con Groq         │  │
│  │  - Recomendaciones IA        │  │
│  │  - Chat inteligente          │  │
│  └──────────────────────────────┘  │
│                                     │
└─────────────────────────────────────┘
```

## 🚀 Pasos para Desplegar

### 1. Obtener API Keys de Groq

```
1. Ve a: https://console.groq.com/
2. Crea cuenta gratuita
3. Genera 7 API keys (recomendado)
4. Guárdalas en un lugar seguro
```

### 2. Desplegar en Easypanel

#### Opción A: Interfaz Web (Más Fácil)

```
1. Accede a tu panel de Easypanel
2. Click en "Create Project"
3. Conecta tu repositorio: daveymena/mantenimiento
4. Selecciona branch: main
5. Build Type: Dockerfile
6. Configura variables de entorno:
   - GROQ_KEY_1=tu-key-1
   - GROQ_KEY_2=tu-key-2
   - ... (hasta 7 keys)
   - FLASK_ENV=production
   - PORT=5000
7. Configura puerto: 5000
8. Agrega dominio (ej: pc-optimizer-ai.tu-dominio.com)
9. Click en "Deploy"
10. Espera 2-3 minutos
```

#### Opción B: CLI

```bash
# Instalar CLI
npm install -g @easypanel/cli

# Login
easypanel login

# Deploy
easypanel deploy --config easypanel.yml
```

### 3. Verificar Despliegue

```bash
# Health check
curl https://tu-dominio.com/health

# Debería retornar:
{
  "status": "ok",
  "service": "AI Maintenance Engine",
  "provider": "groq"
}
```

### 4. Actualizar Aplicación de Escritorio

Edita `src/backend/executor.js` para usar el servidor remoto:

```javascript
// Antes (local)
const AI_SERVER_URL = 'http://localhost:5000';

// Después (remoto)
const AI_SERVER_URL = 'https://tu-dominio.com';
```

Reconstruye la aplicación:
```cmd
npm run build:win
```

## 🧪 Probar Localmente Primero

Antes de desplegar, prueba localmente con Docker:

### Opción 1: Docker Compose (Recomendado)

```cmd
REM 1. Configurar variables de entorno
copy .env.example .env
REM Edita .env y agrega tus API keys

REM 2. Iniciar
test-docker-compose.bat

REM 3. Probar
curl http://localhost:5000/health
```

### Opción 2: Docker Manual

```cmd
REM 1. Construir
docker build -t pc-optimizer-ai .

REM 2. Ejecutar
docker run -d -p 5000:5000 ^
  -e GROQ_KEY_1=tu-key ^
  pc-optimizer-ai

REM 3. Probar
curl http://localhost:5000/health
```

## 📡 Endpoints Disponibles

Una vez desplegado, estos endpoints estarán disponibles:

```
GET  /health                    - Health check
GET  /api/analyze               - Análisis del sistema
POST /api/recommendations       - Recomendaciones inteligentes
GET  /api/maintenance-plan      - Plan de mantenimiento
POST /api/chat                  - Chat con IA
POST /api/explain               - Explicar acción
POST /api/predict-impact        - Predecir impacto
GET  /api/groq-stats           - Estadísticas de keys
POST /api/groq-reset           - Resetear keys fallidas
```

## 🔄 Auto-Deploy desde GitHub

Configura webhook para despliegue automático:

```
1. En Easypanel:
   - Settings > Webhooks
   - Copia URL del webhook

2. En GitHub:
   - Repo > Settings > Webhooks
   - Add webhook
   - Pega URL de Easypanel
   - Content type: application/json
   - Events: Just the push event
   - Save

Ahora cada push a main desplegará automáticamente
```

## 💰 Costos Estimados

### Easypanel
- **Plan básico**: $5-10/mes
- Incluye: SSL, dominio, monitoreo, backups

### Groq API
- **Tier gratuito**: $0/mes
- 30 requests/min por key
- Con 7 keys: 210 requests/min gratis
- Más que suficiente para uso personal

**Total**: $5-10/mes

## 📊 Monitoreo

### Logs en Tiempo Real

```bash
# Easypanel CLI
easypanel logs pc-optimizer-ai --follow

# O en la interfaz web
Project > Logs
```

### Métricas

Easypanel incluye:
- CPU usage
- Memory usage
- Network traffic
- Request count
- Response time

### Estadísticas de Groq

```bash
curl https://tu-dominio.com/api/groq-stats
```

## 🐛 Solución de Problemas

### Build Falla

**Error**: `requirements.txt not found`
- Verifica que esté en la raíz del repo
- Revisa `.dockerignore`

**Error**: `Python version mismatch`
- El Dockerfile usa Python 3.11
- Actualiza si es necesario

### Aplicación No Inicia

**Error**: `Port already in use`
- Cambia el puerto en Easypanel
- O usa variable PORT

**Error**: `No API keys found`
- Verifica variables de entorno en Easypanel
- Revisa logs

### API Keys No Funcionan

**Error**: `Invalid API key`
- Verifica en https://console.groq.com/
- Copia keys completas sin espacios

**Error**: `Rate limit exceeded`
- Sistema rotará automáticamente
- Agrega más keys

## 📚 Documentación Completa

- **[EASYPANEL_DEPLOYMENT.md](EASYPANEL_DEPLOYMENT.md)** - Guía detallada de despliegue
- **[AI_SERVER_README.md](AI_SERVER_README.md)** - Documentación del servidor
- **[CONFIGURACION_API_KEYS.md](CONFIGURACION_API_KEYS.md)** - Configurar API keys
- **[PASOS_SIGUIENTES.md](PASOS_SIGUIENTES.md)** - Qué hacer después

## ✅ Checklist de Despliegue

- [ ] Obtener 7 API keys de Groq
- [ ] Probar localmente con Docker
- [ ] Crear proyecto en Easypanel
- [ ] Conectar repositorio GitHub
- [ ] Configurar variables de entorno
- [ ] Configurar puerto (5000)
- [ ] Agregar dominio personalizado
- [ ] Deploy inicial
- [ ] Verificar health check
- [ ] Probar todos los endpoints
- [ ] Configurar webhook para auto-deploy
- [ ] Actualizar aplicación de escritorio con URL remota
- [ ] Reconstruir ejecutables
- [ ] Probar integración completa
- [ ] Configurar alertas en Easypanel
- [ ] Documentar URL del servidor para usuarios

## 🎯 Próximos Pasos

1. **Desplegar en Easypanel** siguiendo [EASYPANEL_DEPLOYMENT.md](EASYPANEL_DEPLOYMENT.md)
2. **Actualizar aplicación de escritorio** con URL del servidor remoto
3. **Reconstruir ejecutables** con `npm run build:win`
4. **Crear nuevo release** en GitHub con ejecutables actualizados
5. **Documentar** la URL del servidor para usuarios finales

## 🆘 Soporte

¿Problemas con el despliegue?

- **Issues**: https://github.com/daveymena/mantenimiento/issues
- **Easypanel Support**: https://easypanel.io/support
- **Groq Docs**: https://console.groq.com/docs

---

## 🎊 ¡Todo Listo!

Tu proyecto está preparado para:
- ✅ Despliegue en Easypanel
- ✅ Pruebas locales con Docker
- ✅ Auto-deploy desde GitHub
- ✅ Monitoreo y logs
- ✅ Escalado horizontal

**Siguiente paso**: Sigue la guía en [EASYPANEL_DEPLOYMENT.md](EASYPANEL_DEPLOYMENT.md)

¡Éxito con tu despliegue! 🚀
