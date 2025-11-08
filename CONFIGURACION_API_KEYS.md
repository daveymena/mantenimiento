# 🔑 Configuración de API Keys

## ⚠️ Importante

Este proyecto requiere API keys de Groq para funcionar con IA. Las keys NO están incluidas en el repositorio por seguridad.

## Pasos para Configurar

### 1. Obtener API Keys de Groq (Gratis)

1. Visita https://console.groq.com/
2. Crea una cuenta gratuita
3. Ve a la sección "API Keys"
4. Genera hasta 7 API keys (recomendado para rotación automática)

### 2. Configurar Variables de Entorno

#### Opción A: Windows (Permanente)

```cmd
setx GROQ_KEY_1 "tu-primera-api-key-aqui"
setx GROQ_KEY_2 "tu-segunda-api-key-aqui"
setx GROQ_KEY_3 "tu-tercera-api-key-aqui"
REM ... hasta GROQ_KEY_7
```

**Importante**: Después de ejecutar estos comandos, cierra y vuelve a abrir la terminal.

#### Opción B: Archivo .env (Desarrollo)

1. Copia el archivo `.env.example` a `.env`:
   ```cmd
   copy .env.example .env
   ```

2. Edita `.env` y agrega tus API keys:
   ```
   GROQ_KEY_1=gsk_tu_key_real_aqui
   GROQ_KEY_2=gsk_otra_key_aqui
   ```

3. Instala python-dotenv:
   ```cmd
   pip install python-dotenv
   ```

### 3. Verificar Configuración

Ejecuta el script de prueba:

```cmd
test-groq-keys.bat
```

Deberías ver:
```
✓ Key 1: Funcionando
✓ Key 2: Funcionando
...
```

## Límites del Tier Gratuito

Por cada API key:
- 30 requests por minuto
- 14,400 requests por día
- 6,000 tokens por minuto

Con 7 keys tendrás:
- 210 requests por minuto
- 100,800 requests por día

## Sistema de Rotación Automática

El proyecto incluye rotación automática de keys:
- Si una key alcanza el límite, rota a la siguiente
- Si una key falla, se marca y se salta
- Tracking de uso por key
- Modo fallback si todas las keys fallan

## Solución de Problemas

### Error: "No se encontraron API keys"

Verifica que las variables de entorno estén configuradas:
```cmd
echo %GROQ_KEY_1%
```

Si no muestra tu key, configúrala de nuevo y reinicia la terminal.

### Error: "Invalid API key"

- Verifica que copiaste la key completa
- Asegúrate de que no haya espacios al inicio o final
- Genera una nueva key en https://console.groq.com/

### Todas las keys fallan

1. Verifica tu conexión a internet
2. Ejecuta `test-groq-keys.bat` para diagnosticar
3. Resetea las keys fallidas:
   ```cmd
   curl -X POST http://localhost:5000/api/groq-reset
   ```

## Seguridad

⚠️ **NUNCA** subas tus API keys a GitHub o repositorios públicos.

El archivo `.env` está en `.gitignore` para proteger tus keys.

## Más Información

Ver `GROQ_KEYS_INFO.md` para detalles sobre el sistema de rotación y monitoreo.
