# Script avanzado de salud del sistema (requiere permisos de Administrador)
# Este script proporciona información más detallada que health-monitor.ps1

param(
    [string]$DryRun = "true"
)

$ErrorActionPreference = "Continue"

# Verificar si se ejecuta como administrador
$isAdmin = ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)

if (-not $isAdmin) {
    Write-Output "WARN Este script funciona mejor con permisos de Administrador"
    Write-Output "INFO Algunos datos pueden no estar disponibles"
    Write-Output ""
}

Write-Output "=== VERIFICACION AVANZADA DE SALUD DEL SISTEMA ==="
Write-Output ""

# 1. SMART detallado del disco
Write-Output "--- Datos SMART Detallados ---"
try {
    # Estado de predicción de fallos
    $smartStatus = Get-WmiObject -Namespace root\wmi -Class MSStorageDriver_FailurePredictStatus -ErrorAction SilentlyContinue
    
    if ($smartStatus) {
        foreach ($status in $smartStatus) {
            $diskName = $status.InstanceName
            Write-Output "Disco: $diskName"
            
            if ($status.PredictFailure) {
                Write-Output "  WARN Prediccion de fallo: SI - Respalda tus datos!"
            } else {
                Write-Output "  OK Prediccion de fallo: NO"
            }
            Write-Output "  Activo: $($status.Active)"
        }
        
        # Datos SMART crudos
        $smartData = Get-WmiObject -Namespace root\wmi -Class MSStorageDriver_FailurePredictData -ErrorAction SilentlyContinue
        
        if ($smartData) {
            Write-Output ""
            Write-Output "Atributos SMART detectados:"
            foreach ($data in $smartData) {
                if ($data.VendorSpecific) {
                    $bytes = $data.VendorSpecific
                    Write-Output "  - Longitud de datos: $($bytes.Length) bytes"
                    
                    # Intentar parsear algunos atributos comunes
                    # Nota: El formato varía por fabricante
                    if ($bytes.Length -ge 362) {
                        Write-Output "  - Datos del fabricante disponibles"
                    }
                }
            }
        }
    } else {
        Write-Output "INFO SMART no disponible via WMI en este sistema"
    }
    
    # Información adicional del disco
    Write-Output ""
    Write-Output "Informacion adicional del disco:"
    $diskDrives = Get-WmiObject Win32_DiskDrive
    foreach ($disk in $diskDrives) {
        Write-Output "  Disco: $($disk.Model)"
        Write-Output "    Interface: $($disk.InterfaceType)"
        Write-Output "    Particiones: $($disk.Partitions)"
        Write-Output "    Sectores: $($disk.TotalSectors)"
        Write-Output "    Bytes por sector: $($disk.BytesPerSector)"
    }
    
} catch {
    Write-Output "WARN Error al obtener datos SMART: $_"
}

# 2. Temperatura avanzada
Write-Output ""
Write-Output "--- Sensores de Temperatura Avanzados ---"
try {
    # Método 1: Zonas térmicas ACPI
    $thermalZones = Get-WmiObject -Namespace "root\wmi" -Class MSAcpi_ThermalZoneTemperature -ErrorAction SilentlyContinue
    
    if ($thermalZones) {
        Write-Output "Zonas termicas ACPI:"
        $zoneNum = 1
        foreach ($zone in $thermalZones) {
            $kelvin = $zone.CurrentTemperature / 10
            $celsius = [math]::Round($kelvin - 273.15, 2)
            
            if ($celsius -gt 0 -and $celsius -lt 150) {
                Write-Output "  Zona $zoneNum : $celsius C"
                
                if ($celsius -gt 85) {
                    Write-Output "    WARN Temperatura critica!"
                } elseif ($celsius -gt 75) {
                    Write-Output "    WARN Temperatura alta"
                } elseif ($celsius -gt 60) {
                    Write-Output "    INFO Temperatura moderada"
                } else {
                    Write-Output "    OK Temperatura normal"
                }
            }
            $zoneNum++
        }
    }
    
    # Método 2: Win32_TemperatureProbe
    $tempProbes = Get-WmiObject Win32_TemperatureProbe -ErrorAction SilentlyContinue
    if ($tempProbes) {
        Write-Output ""
        Write-Output "Sondas de temperatura:"
        foreach ($probe in $tempProbes) {
            Write-Output "  $($probe.Description): $($probe.Status)"
            if ($probe.CurrentReading) {
                $celsius = [math]::Round(($probe.CurrentReading / 10) - 273.15, 2)
                if ($celsius -gt 0 -and $celsius -lt 150) {
                    Write-Output "    Lectura: $celsius C"
                }
            }
        }
    }
    
    if (-not $thermalZones -and -not $tempProbes) {
        Write-Output "INFO No hay sensores de temperatura accesibles via WMI"
        Write-Output "INFO Recomendaciones para monitoreo de temperatura:"
        Write-Output "  - HWiNFO64 (gratuito, muy detallado)"
        Write-Output "  - HWMonitor (gratuito, simple)"
        Write-Output "  - Core Temp (para CPU Intel/AMD)"
        Write-Output "  - MSI Afterburner (para GPU)"
    }
    
} catch {
    Write-Output "WARN Error al obtener temperatura: $_"
}

# 3. Errores del sistema detallados
Write-Output ""
Write-Output "--- Errores del Sistema (Ultimas 24 horas) ---"
try {
    $yesterday = (Get-Date).AddDays(-1)
    
    # Errores críticos
    $criticalErrors = Get-WinEvent -FilterHashtable @{
        LogName='System'
        Level=1  # Critical
        StartTime=$yesterday
    } -MaxEvents 10 -ErrorAction SilentlyContinue
    
    if ($criticalErrors) {
        Write-Output "Errores CRITICOS:"
        foreach ($error in $criticalErrors) {
            Write-Output "  - [$($error.TimeCreated)] ID:$($error.Id) - $($error.ProviderName)"
            if ($error.Message) {
                $msg = $error.Message.Split("`n")[0]
                if ($msg.Length -gt 80) { $msg = $msg.Substring(0, 80) + "..." }
                Write-Output "    $msg"
            }
        }
    } else {
        Write-Output "OK No hay errores criticos en las ultimas 24 horas"
    }
    
    # Errores normales
    Write-Output ""
    $errors = Get-WinEvent -FilterHashtable @{
        LogName='System'
        Level=2  # Error
        StartTime=$yesterday
    } -MaxEvents 10 -ErrorAction SilentlyContinue
    
    if ($errors) {
        Write-Output "Errores recientes (ultimos 10):"
        foreach ($error in $errors) {
            Write-Output "  - [$($error.TimeCreated)] ID:$($error.Id) - $($error.ProviderName)"
        }
    } else {
        Write-Output "OK No hay errores en las ultimas 24 horas"
    }
    
    # Advertencias importantes
    Write-Output ""
    $warnings = Get-WinEvent -FilterHashtable @{
        LogName='System'
        Level=3  # Warning
        StartTime=$yesterday
    } -MaxEvents 5 -ErrorAction SilentlyContinue
    
    if ($warnings) {
        Write-Output "Advertencias recientes (ultimas 5):"
        foreach ($warning in $warnings) {
            Write-Output "  - [$($warning.TimeCreated)] ID:$($warning.Id) - $($warning.ProviderName)"
        }
    }
    
} catch {
    Write-Output "WARN No se pudo acceder al registro de eventos: $_"
    Write-Output "INFO Ejecuta como Administrador para acceso completo"
}

# 4. Salud de la batería (para laptops)
Write-Output ""
Write-Output "--- Salud de la Bateria (Detallado) ---"
try {
    $battery = Get-WmiObject Win32_Battery
    
    if ($battery) {
        Write-Output "Informacion de la bateria:"
        Write-Output "  Estado: $($battery.Status)"
        Write-Output "  Carga actual: $($battery.EstimatedChargeRemaining)%"
        Write-Output "  Tiempo restante: $($battery.EstimatedRunTime) minutos"
        Write-Output "  Voltaje: $($battery.DesignVoltage / 1000) V"
        Write-Output "  Quimica: $($battery.Chemistry)"
        
        # Generar reporte de batería
        if ($isAdmin) {
            Write-Output ""
            Write-Output "Generando reporte detallado de bateria..."
            $reportPath = "$env:TEMP\battery-report.html"
            powercfg /batteryreport /output $reportPath 2>&1 | Out-Null
            
            if (Test-Path $reportPath) {
                Write-Output "OK Reporte generado: $reportPath"
                Write-Output "INFO Abre este archivo en tu navegador para ver detalles completos"
            }
        } else {
            Write-Output "INFO Ejecuta como Administrador para generar reporte detallado"
            Write-Output "INFO Comando: powercfg /batteryreport"
        }
    } else {
        Write-Output "INFO No hay bateria (PC de escritorio)"
    }
} catch {
    Write-Output "INFO No se pudo obtener informacion de bateria"
}

# 5. Verificación de drivers problemáticos
Write-Output ""
Write-Output "--- Drivers con Problemas ---"
try {
    $problemDevices = Get-WmiObject Win32_PnPEntity | Where-Object { $_.ConfigManagerErrorCode -ne 0 }
    
    if ($problemDevices) {
        Write-Output "WARN Dispositivos con problemas detectados:"
        foreach ($device in $problemDevices) {
            Write-Output "  - $($device.Name)"
            Write-Output "    Codigo de error: $($device.ConfigManagerErrorCode)"
        }
    } else {
        Write-Output "OK Todos los drivers funcionan correctamente"
    }
} catch {
    Write-Output "INFO No se pudo verificar estado de drivers"
}

# 6. Resumen final
Write-Output ""
Write-Output "--- RESUMEN ---"
Write-Output "Verificacion completada: $(Get-Date -Format 'yyyy-MM-dd HH:mm:ss')"
Write-Output ""
Write-Output "Para monitoreo continuo, considera instalar:"
Write-Output "  - HWiNFO64: Monitoreo completo de hardware"
Write-Output "  - CrystalDiskInfo: Salud y SMART de discos"
Write-Output "  - LatencyMon: Analisis de latencia del sistema"
Write-Output ""
Write-Output "=== VERIFICACION COMPLETADA ==="
