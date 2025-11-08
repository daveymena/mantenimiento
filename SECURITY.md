# 🔒 Guía de Seguridad

## Permisos Requeridos

Esta aplicación requiere permisos de **Administrador** para:
- Crear restore points
- Limpiar carpetas del sistema (C:\Windows\Temp)
- Modificar servicios
- Cambiar configuración de energía

## Operaciones Seguras

### ✅ Operaciones de Solo Lectura
- Escaneo del sistema
- Lectura de logs
- Visualización de servicios y apps de inicio

### ⚠️ Operaciones que Modifican el Sistema
- Limpieza de temporales
- Detención de servicios
- Modificación de apps de inicio
- Cambio de plan de energía

## Modo Dry Run

**SIEMPRE** usa el modo Dry Run primero:
- Muestra qué cambios se aplicarían
- No modifica nada en el sistema
- Permite revisar antes de ejecutar

## Restore Points

Antes de cualquier optimización real:
1. Crea un Restore Point desde la app
2. Verifica que se creó correctamente en el log
3. Procede con la optimización

### Restaurar Sistema

Si algo sale mal:
1. Abre "Crear un punto de restauración" en Windows
2. Clic en "Restaurar sistema"
3. Selecciona el punto "PCMaintenance-BeforeOptimization"

## Servicios Protegidos

La app NUNCA toca estos servicios críticos:
- `wuauserv` - Windows Update
- `WinDefend` - Windows Defender
- `MpsSvc` - Windows Firewall
- `BFE` - Base Filtering Engine
- `Dhcp` - DHCP Client
- `Dnscache` - DNS Client
- `EventLog` - Event Log

## Logs y Auditoría

Todos los logs se guardan en `logs/`:
- Timestamp de cada operación
- Salida completa de scripts
- Errores y advertencias
- Código de salida

## Recomendaciones

1. **Backup Regular**: Mantén backups de tus datos importantes
2. **Prueba en VM**: Prueba primero en una máquina virtual
3. **Lee los Logs**: Revisa siempre los logs después de ejecutar
4. **Modo Dry Run**: Úsalo antes de aplicar cambios reales
5. **Restore Points**: Créalos antes de optimizaciones importantes
6. **Conoce tu Sistema**: No deshabilites servicios que no conozcas

## Reportar Problemas de Seguridad

Si encuentras un problema de seguridad, por favor:
1. NO lo publiques públicamente
2. Contacta al mantenedor directamente
3. Proporciona detalles del problema
4. Espera respuesta antes de divulgar

## Limitaciones Conocidas

- No funciona sin permisos de administrador
- Algunos servicios requieren reinicio para cambios
- La limpieza de temporales puede tardar en sistemas con muchos archivos
- Restore Points requieren System Protection habilitado

## Buenas Prácticas

```powershell
# Verificar System Protection antes de usar
Get-ComputerRestorePoint

# Habilitar System Protection si está deshabilitado
Enable-ComputerRestore -Drive "C:\"

# Ver servicios antes de optimizar
Get-Service | Where-Object {$_.Status -eq "Running"}
```

## Disclaimer

**ESTA APLICACIÓN MODIFICA CONFIGURACIONES DEL SISTEMA**

El uso de esta aplicación es bajo tu propio riesgo. Los desarrolladores no se hacen responsables de:
- Pérdida de datos
- Inestabilidad del sistema
- Problemas de rendimiento
- Incompatibilidades con software
- Cualquier daño directo o indirecto

**SIEMPRE MANTÉN BACKUPS DE TUS DATOS IMPORTANTES**
