# ❓ Preguntas Frecuentes (FAQ)

## General

### ¿Qué hace esta aplicación?

PC Maintenance Optimizer es una herramienta que automatiza tareas de mantenimiento en Windows:
- Limpia archivos temporales
- Optimiza servicios del sistema
- Gestiona aplicaciones de inicio
- Libera memoria RAM
- Crea puntos de restauración

### ¿Es seguro usar esta aplicación?

Sí, con precauciones:
- Siempre usa **Modo Dry Run** primero
- Crea un **Restore Point** antes de optimizar
- La app tiene una **blacklist** de servicios críticos que nunca toca
- Todos los cambios se registran en **logs**

### ¿Necesito permisos de administrador?

Sí, muchas operaciones requieren permisos elevados:
- Crear restore points
- Limpiar carpetas del sistema
- Modificar servicios
- Cambiar configuración de energía

## Instalación

### ¿Cómo instalo la aplicación?

```cmd
npm install
npm start
```

Ver [INSTALL.md](../INSTALL.md) para detalles completos.

### Error: "No se puede ejecutar scripts"

Ejecuta en PowerShell como Administrador:
```powershell
Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope CurrentUser
```

### Error: "node no se reconoce"

Node.js no está instalado o no está en el PATH. Descarga desde: https://nodejs.org/

## Uso

### ¿Qué es el Modo Dry Run?

Es un modo de simulación que muestra qué cambios se aplicarían **sin modificar nada**. Siempre úsalo primero.

### ¿Puedo deshacer los cambios?

Sí, de varias formas:
1. **Restore Point**: Restaura el sistema al estado anterior
2. **Logs**: Revisa qué se cambió
3. **Revertir servicios**: Vuelve a habilitar servicios manualmente

### ¿Qué servicios se pueden detener?

Solo servicios **no críticos** como:
- TabletInputService
- Fax
- Xbox Services (si no usas Xbox)

**NUNCA** se tocan:
- Windows Update
- Windows Defender
- Firewall
- DHCP/DNS
- Event Log

### ¿Cuánto espacio libera?

Depende del sistema, típicamente:
- Temporales: 500 MB - 5 GB
- Cache de navegadores: 100 MB - 2 GB
- Logs antiguos: 50 MB - 500 MB

### ¿Con qué frecuencia debo ejecutarlo?

Recomendado:
- **Limpieza de temporales**: Semanal
- **Optimización completa**: Mensual
- **Escaneo**: Cuando notes lentitud

## Problemas Comunes

### La aplicación no inicia

1. Verifica que Node.js esté instalado: `node --version`
2. Instala dependencias: `npm install`
3. Ejecuta como Administrador

### No se crea el Restore Point

**Causa**: System Protection deshabilitado

**Solución**:
1. Win + Pause → "Protección del sistema"
2. Selecciona disco C:
3. "Configurar" → "Activar protección del sistema"

### La limpieza tarda mucho

Es normal si tienes muchos archivos temporales. Puede tardar 5-15 minutos en sistemas con mucha basura acumulada.

### Algunos servicios no se detienen

Algunos servicios están protegidos por Windows o son dependencias de otros. Esto es normal y seguro.

### La app dice "Error de permisos"

Ejecuta CMD como Administrador antes de `npm start`.

### ¿Puedo ejecutarlo en modo portátil?

Actualmente no, pero está en el roadmap. Por ahora requiere Node.js instalado.

## Características

### ¿Puedo programar mantenimiento automático?

Sí, usa el script `scheduler.ps1`:
```powershell
powershell -ExecutionPolicy Bypass -File src\backend\scripts\scheduler.ps1 -Action create -Frequency weekly -Time "02:00"
```

### ¿Soporta otros navegadores además de Chrome?

Sí, soporta:
- Google Chrome
- Mozilla Firefox
- Microsoft Edge

### ¿Funciona en Windows 7?

No oficialmente. Requiere Windows 10 (1809+) o Windows 11.

### ¿Hay versión para Linux/macOS?

No en esta versión, pero está planeado. Ver [TODO.md](../TODO.md).

## Seguridad

### ¿La app envía datos a internet?

No. Todo se ejecuta localmente. No hay telemetría ni conexiones externas.

### ¿Puedo revisar el código?

Sí, es código abierto. Revisa los scripts en `src/backend/scripts/`.

### ¿Qué pasa si algo sale mal?

1. Restaura desde el Restore Point
2. Revisa los logs en `logs/`
3. Reinicia el sistema
4. Reporta el problema en GitHub

### ¿Puede dañar mi PC?

Si se usa correctamente (con Dry Run y Restore Points), el riesgo es mínimo. Sin embargo:
- **Siempre haz backups**
- **Lee los logs**
- **No deshabilites servicios que no conozcas**

## Desarrollo

### ¿Puedo contribuir?

Sí, ver [TODO.md](../TODO.md) para tareas pendientes.

### ¿Cómo agrego un nuevo script?

Ver [API.md](API.md) sección "Extensión de la API".

### ¿Cómo compilo un ejecutable?

```cmd
npm install --save-dev electron-builder
npm run build
```

## Soporte

### ¿Dónde reporto bugs?

Abre un issue en GitHub con:
- Descripción del problema
- Logs relevantes
- Versión de Windows
- Pasos para reproducir

### ¿Dónde pido nuevas características?

En GitHub issues con la etiqueta "enhancement".

### ¿Hay documentación adicional?

Sí:
- [README.md](../README.md) - Introducción
- [INSTALL.md](../INSTALL.md) - Instalación
- [SECURITY.md](../SECURITY.md) - Seguridad
- [API.md](API.md) - API técnica
- [ARCHITECTURE.md](ARCHITECTURE.md) - Arquitectura

## Licencia

### ¿Puedo usar esto comercialmente?

Sí, bajo licencia MIT. Ver [LICENSE](../LICENSE).

### ¿Puedo modificar el código?

Sí, es código abierto.

### ¿Puedo redistribuir?

Sí, manteniendo la licencia MIT.

---

**¿No encuentras tu pregunta?** Abre un issue en GitHub.
