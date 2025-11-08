# 🔬 Guía de Monitoreo de Salud del Sistema

## Mejoras Implementadas

Se han mejorado significativamente las capacidades de monitoreo de salud del sistema para proporcionar información más detallada sobre:

### 1. 💚 Monitor de Salud Básico (health-monitor.ps1)

**Mejoras aplicadas:**

#### Datos SMART del Disco
- ✅ Ahora intenta acceder a datos SMART via WMI
- ✅ Detecta predicciones de fallo del disco
- ✅ Muestra atributos SMART cuando están disponibles
- ℹ️ Si no puede acceder, sugiere usar CrystalDiskInfo

#### Sensores de Temperatura
- ✅ Método 1: MSAcpi_ThermalZoneTemperature (zonas térmicas ACPI)
- ✅ Método 2: Win32_TemperatureProbe (sondas de temperatura)
- ✅ Validación de lecturas (filtra valores inválidos)
- ✅ Alertas por temperatura alta (>70°C moderada, >80°C alta)
- ℹ️ Si no hay sensores, recomienda herramientas como HWMonitor

#### Errores del Sistema
- ✅ Método 1: Get-EventLog (tradicional)
- ✅ Método 2: Get-WinEvent (alternativo si el primero falla)
- ✅ Muestra los últimos 5 errores del registro del sistema
- ✅ Mejor manejo de permisos
- ℹ️ Indica cuando se necesitan permisos de Administrador

### 2. 🔬 Verificación Avanzada de Salud (advanced-health-check.ps1)

**Nuevo script con análisis profundo:**

#### SMART Detallado
- Estado de predicción de fallos por disco
- Datos SMART crudos del fabricante
- Información adicional: interfaz, particiones, sectores
- Longitud de datos SMART disponibles

#### Temperatura Avanzada
- Múltiples zonas térmicas ACPI
- Clasificación de temperatura:
  - Normal: < 60°C
  - Moderada: 60-75°C
  - Alta: 75-85°C
  - Crítica: > 85°C
- Recomendaciones de herramientas de monitoreo

#### Errores del Sistema (24 horas)
- Errores CRÍTICOS (Level 1)
- Errores normales (Level 2)
- Advertencias importantes (Level 3)
- Incluye ID de evento y proveedor
- Muestra timestamp de cada evento

#### Salud de Batería Detallada
- Información completa de la batería
- Voltaje y química
- Generación automática de reporte de batería (powercfg /batteryreport)
- Ruta al reporte HTML para análisis detallado

#### Drivers Problemáticos
- Detecta dispositivos con errores
- Muestra código de error de configuración
- Lista todos los dispositivos con problemas

#### Recomendaciones de Herramientas
- HWiNFO64: Monitoreo completo de hardware
- CrystalDiskInfo: Salud y SMART de discos
- LatencyMon: Análisis de latencia del sistema
- HWMonitor: Monitoreo simple de temperatura
- Core Temp: Temperatura de CPU
- MSI Afterburner: Monitoreo de GPU

## Cómo Usar

### Desde la Aplicación

1. **Monitor Básico:**
   - Click en "💚 Monitor Salud"
   - Proporciona un resumen rápido del estado del sistema
   - Ideal para verificaciones diarias

2. **Verificación Avanzada:**
   - Click en "🔬 Salud Avanzada"
   - Análisis profundo con más detalles
   - Recomendado cuando sospechas problemas
   - **Mejor ejecutar como Administrador**

### Desde PowerShell

```powershell
# Monitor básico
powershell -ExecutionPolicy Bypass -File "src/backend/scripts/health-monitor.ps1"

# Verificación avanzada (recomendado como Admin)
powershell -ExecutionPolicy Bypass -File "src/backend/scripts/advanced-health-check.ps1"
```

## Permisos de Administrador

Algunas funciones requieren permisos elevados:

### Sin Administrador:
- ✅ Información básica de disco
- ✅ Estado de RAM y CPU
- ✅ Información de batería
- ⚠️ SMART limitado
- ⚠️ Temperatura limitada
- ⚠️ Errores del sistema limitados

### Con Administrador:
- ✅ Acceso completo a SMART
- ✅ Todos los sensores de temperatura
- ✅ Registro completo de eventos
- ✅ Generación de reportes de batería
- ✅ Estado detallado de drivers

## Interpretación de Resultados

### Puntuación de Salud

El monitor básico proporciona una puntuación de 0-5:

- **5/5 (100%)**: ✅ Sistema perfecto
- **4/5 (80%)**: ✅ Sistema saludable
- **3/5 (60%)**: ⚠️ Problemas menores
- **2/5 (40%)**: ⚠️ Requiere atención
- **1/5 (20%)**: 🚨 Problemas serios

### Códigos de Estado

- **OK**: Todo funciona correctamente
- **INFO**: Información adicional, no es un problema
- **WARN**: Advertencia, revisar pero no crítico
- **CRITICAL**: Problema serio, requiere acción inmediata

## Solución de Problemas

### "Temperatura no disponible"
**Causa:** Muchos sistemas no exponen sensores via WMI
**Solución:** 
- Esto es normal en muchas PCs
- Usa HWMonitor o HWiNFO para monitoreo
- Los sensores funcionan, solo no son accesibles via WMI

### "No se pudo verificar errores del sistema"
**Causa:** Falta de permisos
**Solución:**
- Ejecuta la aplicación como Administrador
- O abre el Visor de Eventos manualmente (eventvwr.msc)

### "SMART no disponible via WMI"
**Causa:** Algunos discos/controladores no exponen SMART
**Solución:**
- Usa CrystalDiskInfo para acceso directo a SMART
- Especialmente común en discos NVMe

### "Batería: 71582788 minutos restantes"
**Causa:** Valor inválido cuando está conectado a corriente
**Solución:**
- Esto es normal cuando está enchufado
- El valor real se muestra cuando está en batería

## Herramientas Recomendadas

### Para Temperatura
1. **HWiNFO64** (Recomendado)
   - Gratuito y muy completo
   - Muestra todos los sensores
   - Logging y alertas

2. **HWMonitor**
   - Simple y ligero
   - Bueno para verificaciones rápidas

3. **Core Temp**
   - Especializado en CPU
   - Muy preciso para Intel/AMD

### Para Discos
1. **CrystalDiskInfo** (Recomendado)
   - Muestra todos los atributos SMART
   - Alertas de salud
   - Soporta NVMe

2. **HD Tune**
   - Benchmarks y salud
   - Escaneo de errores

### Para Sistema General
1. **HWiNFO64**
   - Todo en uno
   - Sensores, voltajes, frecuencias

2. **LatencyMon**
   - Detecta problemas de latencia
   - Útil para gaming/audio

## Mantenimiento Preventivo

### Diario
- Monitor básico de salud
- Verificar uso de RAM/CPU

### Semanal
- Verificación avanzada de salud
- Revisar errores del sistema

### Mensual
- Reporte completo de batería (laptops)
- Verificar SMART de discos
- Limpiar archivos temporales

### Trimestral
- Backup completo del sistema
- Actualizar drivers
- Verificar actualizaciones de firmware

## Notas Importantes

1. **Ejecutar como Administrador** proporciona información más completa
2. **No todos los sensores** están disponibles en todos los sistemas
3. **Valores inválidos** son filtrados automáticamente
4. **Herramientas externas** proporcionan información más detallada
5. **Monitoreo regular** ayuda a detectar problemas temprano

## Soporte

Si encuentras problemas o tienes preguntas:
1. Revisa los logs en la carpeta `logs/`
2. Ejecuta como Administrador
3. Verifica que PowerShell tenga permisos
4. Consulta la documentación de Windows sobre WMI

---

**Última actualización:** Noviembre 2025
**Versión:** 2.0
