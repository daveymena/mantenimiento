# 🚀 Inicio Rápido

## En 5 Minutos

### 1. Instalar Node.js (si no lo tienes)
Descarga desde: https://nodejs.org/ (versión LTS recomendada)

### 2. Instalar Dependencias
```cmd
npm install
```

### 3. Ejecutar como Administrador
```cmd
# Clic derecho en CMD → "Ejecutar como administrador"
npm start
```

O usa el archivo `run-as-admin.bat` (clic derecho → Ejecutar como administrador)

### 4. Primera Ejecución

1. **Escanear**: Haz clic en "🔍 Escanear Sistema"
2. **Revisar**: Mira los resultados del escaneo
3. **Dry Run**: Marca las opciones que quieras y haz clic en "✨ Optimizar Ahora" (en modo simulación)
4. **Restore Point**: Haz clic en "💾 Crear Restore Point"
5. **Optimizar**: Cambia a "Ejecutar Cambios Reales" y optimiza

## Flujo Recomendado

```
┌─────────────────┐
│  1. ESCANEAR    │ ← Ver estado actual
└────────┬────────┘
         │
┌────────▼────────┐
│  2. DRY RUN     │ ← Simular cambios
└────────┬────────┘
         │
┌────────▼────────┐
│ 3. RESTORE PT   │ ← Crear backup
└────────┬────────┘
         │
┌────────▼────────┐
│ 4. OPTIMIZAR    │ ← Aplicar cambios
└────────┬────────┘
         │
┌────────▼────────┐
│ 5. REVISAR LOGS │ ← Verificar
└─────────────────┘
```

## Opciones Recomendadas para Principiantes

✅ **Seguras** (siempre):
- 🗑️ Limpiar Temporales
- 💾 Liberar Memoria

⚠️ **Con precaución**:
- 🚀 Optimizar Inicio (revisa qué apps se deshabilitarán)
- ⚙️ Optimizar Servicios (solo si sabes qué hace cada servicio)

## Comandos Útiles

```cmd
# Iniciar app
npm start

# Ver logs
dir logs

# Limpiar logs antiguos
del logs\*.log

# Reinstalar dependencias
rmdir /s /q node_modules
npm install
```

## Scripts PowerShell Directos

Si prefieres usar scripts sin la GUI:

```powershell
# Escanear
powershell -ExecutionPolicy Bypass -File src\backend\scripts\scan-system.ps1

# Limpiar temporales (dry run)
powershell -ExecutionPolicy Bypass -File src\backend\scripts\optimize-system.ps1 -DryRun $true -CleanTemp $true

# Crear restore point
powershell -ExecutionPolicy Bypass -File src\backend\scripts\create-restore-point.ps1 -DryRun $false

# Programar mantenimiento semanal
powershell -ExecutionPolicy Bypass -File src\backend\scripts\scheduler.ps1 -Action create -Frequency weekly -Time "02:00"
```

## Solución Rápida de Problemas

| Problema | Solución |
|----------|----------|
| "node no se reconoce" | Instala Node.js |
| "No se puede ejecutar scripts" | `Set-ExecutionPolicy RemoteSigned` en PowerShell Admin |
| App no inicia | Ejecuta CMD como Administrador |
| No crea Restore Point | Habilita System Protection |
| Tarda mucho | Normal si hay muchos archivos temporales |

## Próximos Pasos

1. Lee [README.md](README.md) para más detalles
2. Revisa [SECURITY.md](SECURITY.md) para mejores prácticas
3. Consulta [FAQ.md](docs/FAQ.md) para preguntas comunes
4. Explora [API.md](docs/API.md) si quieres extender la app

## Programar Mantenimiento Automático

```powershell
# Ejecuta como Administrador
powershell -ExecutionPolicy Bypass -File src\backend\scripts\scheduler.ps1 -Action create -Frequency weekly -Time "02:00"
```

Esto ejecutará mantenimiento automático cada semana a las 2 AM.

## Desinstalar

```cmd
# Eliminar tarea programada (si existe)
powershell -ExecutionPolicy Bypass -File src\backend\scripts\scheduler.ps1 -Action remove

# Eliminar carpeta del proyecto
cd ..
rmdir /s /q pc-maintenance-optimizer
```

---

**¿Problemas?** Consulta [FAQ.md](docs/FAQ.md) o abre un issue en GitHub.
