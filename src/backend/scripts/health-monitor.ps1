param(
    [string]$DryRun = "true"
)

$ErrorActionPreference = "Continue"

Write-Output "=== MONITOR DE SALUD DEL SISTEMA ==="
Write-Output ""

# 1. Salud del disco
Write-Output "--- Salud del Disco ---"
try {
    $disks = Get-PhysicalDisk
    foreach ($disk in $disks) {
        Write-Output "Disco: $($disk.FriendlyName)"
        Write-Output "  Estado: $($disk.HealthStatus)"
        Write-Output "  Tipo: $($disk.MediaType)"
        Write-Output "  Tamano: $([math]::Round($disk.Size / 1GB, 2)) GB"
        
        if ($disk.HealthStatus -ne "Healthy") {
            Write-Output "  WARN Disco con problemas de salud!"
        }
    }
} catch {
    Write-Output "WARN No se pudo verificar salud del disco: $_"
}

# 2. SMART del disco
Write-Output ""
Write-Output "--- SMART del Disco ---"
try {
    # Intentar obtener datos SMART usando WMI
    $smartData = Get-WmiObject -Namespace root\wmi -Class MSStorageDriver_FailurePredictStatus -ErrorAction SilentlyContinue
    
    if ($smartData) {
        foreach ($smart in $smartData) {
            if ($smart.PredictFailure) {
                Write-Output "WARN SMART indica posible fallo del disco!"
            } else {
                Write-Output "OK SMART: Sin predicciones de fallo"
            }
        }
        
        # Intentar obtener atributos SMART
        $smartAttributes = Get-WmiObject -Namespace root\wmi -Class MSStorageDriver_FailurePredictData -ErrorAction SilentlyContinue
        if ($smartAttributes) {
            Write-Output "OK Atributos SMART disponibles"
            
            # Mostrar algunos atributos clave si están disponibles
            foreach ($attr in $smartAttributes) {
                if ($attr.VendorSpecific) {
                    Write-Output "  - Datos del fabricante detectados"
                }
            }
        }
    } else {
        Write-Output "INFO SMART no disponible via WMI"
        Write-Output "INFO Usa CrystalDiskInfo para detalles SMART completos"
    }
} catch {
    Write-Output "INFO No se pudo acceder a datos SMART"
    Write-Output "INFO Ejecuta como Administrador para acceso completo"
}

# 3. Temperatura (si esta disponible)
Write-Output ""
Write-Output "--- Temperatura ---"
try {
    # Método 1: MSAcpi_ThermalZoneTemperature
    $temp = Get-WmiObject -Namespace "root\wmi" -Class MSAcpi_ThermalZoneTemperature -ErrorAction SilentlyContinue
    
    if ($temp) {
        $tempFound = $false
        foreach ($t in $temp) {
            $celsius = [math]::Round(($t.CurrentTemperature / 10) - 273.15, 2)
            if ($celsius -gt 0 -and $celsius -lt 150) {
                Write-Output "Zona termica: $celsius C"
                $tempFound = $true
                
                if ($celsius -gt 80) {
                    Write-Output "  WARN Temperatura alta!"
                } elseif ($celsius -gt 70) {
                    Write-Output "  INFO Temperatura moderada"
                } else {
                    Write-Output "  OK Temperatura normal"
                }
            }
        }
        
        if (-not $tempFound) {
            Write-Output "INFO Sensores termicos no reportan datos validos"
        }
    } else {
        # Método 2: Intentar con Win32_TemperatureProbe
        $tempProbe = Get-WmiObject -Class Win32_TemperatureProbe -ErrorAction SilentlyContinue
        
        if ($tempProbe) {
            foreach ($probe in $tempProbe) {
                if ($probe.CurrentReading) {
                    $celsius = [math]::Round(($probe.CurrentReading / 10) - 273.15, 2)
                    if ($celsius -gt 0 -and $celsius -lt 150) {
                        Write-Output "Temperatura: $celsius C"
                    }
                }
            }
        } else {
            Write-Output "INFO Sensores de temperatura no disponibles"
            Write-Output "INFO Esto es normal en muchos sistemas"
            Write-Output "INFO Usa HWMonitor o HWiNFO para monitoreo detallado"
        }
    }
} catch {
    Write-Output "INFO No se pudo acceder a sensores de temperatura"
    Write-Output "INFO Ejecuta como Administrador para mejor acceso"
}

# 4. Memoria RAM
Write-Output ""
Write-Output "--- Memoria RAM ---"
try {
    $memory = Get-CimInstance Win32_PhysicalMemory
    $totalRAM = ($memory | Measure-Object -Property Capacity -Sum).Sum / 1GB
    
    Write-Output "RAM total instalada: $([math]::Round($totalRAM, 2)) GB"
    Write-Output "Modulos de RAM: $($memory.Count)"
    
    foreach ($mem in $memory) {
        Write-Output "  - $([math]::Round($mem.Capacity / 1GB, 2)) GB @ $($mem.Speed) MHz"
    }
    
    # Uso actual
    $os = Get-CimInstance Win32_OperatingSystem
    $freeRAM = [math]::Round($os.FreePhysicalMemory / 1MB, 2)
    $usedRAM = [math]::Round(($os.TotalVisibleMemorySize - $os.FreePhysicalMemory) / 1MB, 2)
    $percentUsed = [math]::Round(($usedRAM / ($totalRAM)) * 100, 2)
    
    Write-Output ""
    Write-Output "Uso actual: $usedRAM GB / $([math]::Round($totalRAM, 2)) GB ($percentUsed%)"
    
    if ($percentUsed -gt 90) {
        Write-Output "WARN Uso de RAM muy alto!"
    }
} catch {
    Write-Output "WARN No se pudo verificar RAM: $_"
}

# 5. CPU
Write-Output ""
Write-Output "--- Procesador ---"
try {
    $cpu = Get-CimInstance Win32_Processor
    Write-Output "CPU: $($cpu.Name)"
    Write-Output "Nucleos: $($cpu.NumberOfCores)"
    Write-Output "Threads: $($cpu.NumberOfLogicalProcessors)"
    Write-Output "Velocidad: $($cpu.MaxClockSpeed) MHz"
    
    # Uso actual
    $cpuLoad = (Get-Counter '\Processor(_Total)\% Processor Time').CounterSamples.CookedValue
    Write-Output "Uso actual: $([math]::Round($cpuLoad, 2))%"
    
    if ($cpuLoad -gt 90) {
        Write-Output "WARN Uso de CPU muy alto!"
    }
} catch {
    Write-Output "WARN No se pudo verificar CPU: $_"
}

# 6. Bateria (si es laptop)
Write-Output ""
Write-Output "--- Bateria ---"
try {
    $battery = Get-CimInstance Win32_Battery
    if ($battery) {
        Write-Output "Estado: $($battery.Status)"
        Write-Output "Carga: $($battery.EstimatedChargeRemaining)%"
        Write-Output "Tiempo restante: $($battery.EstimatedRunTime) minutos"
        
        if ($battery.EstimatedChargeRemaining -lt 20) {
            Write-Output "WARN Bateria baja!"
        }
    } else {
        Write-Output "INFO No hay bateria (PC de escritorio)"
    }
} catch {
    Write-Output "INFO No hay bateria detectada"
}

# 7. Errores del sistema
Write-Output ""
Write-Output "--- Errores Recientes del Sistema ---"
try {
    # Intentar con Get-EventLog (requiere permisos)
    $errors = Get-EventLog -LogName System -EntryType Error -Newest 5 -ErrorAction SilentlyContinue
    
    if ($errors) {
        Write-Output "Ultimos 5 errores del sistema:"
        foreach ($error in $errors) {
            $msg = $error.Message
            if ($msg.Length -gt 100) {
                $msg = $msg.Substring(0, 100) + "..."
            }
            Write-Output "  - $($error.TimeGenerated): $msg"
        }
    } else {
        # Método alternativo con Get-WinEvent
        try {
            $events = Get-WinEvent -FilterHashtable @{LogName='System'; Level=2} -MaxEvents 5 -ErrorAction SilentlyContinue
            
            if ($events) {
                Write-Output "Ultimos 5 errores del sistema:"
                foreach ($event in $events) {
                    $msg = $event.Message
                    if ($msg -and $msg.Length -gt 100) {
                        $msg = $msg.Substring(0, 100) + "..."
                    } elseif (-not $msg) {
                        $msg = "Error ID: $($event.Id)"
                    }
                    Write-Output "  - $($event.TimeCreated): $msg"
                }
            } else {
                Write-Output "OK No hay errores recientes en el registro"
            }
        } catch {
            Write-Output "INFO No se pudo acceder al registro de eventos"
            Write-Output "INFO Ejecuta como Administrador para ver errores del sistema"
            Write-Output "INFO O abre el Visor de Eventos manualmente (eventvwr.msc)"
        }
    }
} catch {
    Write-Output "INFO No se pudo verificar errores del sistema"
    Write-Output "INFO Ejecuta como Administrador para acceso completo"
}

# 8. Uptime
Write-Output ""
Write-Output "--- Tiempo de Actividad ---"
try {
    $os = Get-CimInstance Win32_OperatingSystem
    $uptime = (Get-Date) - $os.LastBootUpTime
    Write-Output "Ultimo reinicio: $($os.LastBootUpTime)"
    Write-Output "Tiempo activo: $($uptime.Days) dias, $($uptime.Hours) horas, $($uptime.Minutes) minutos"
    
    if ($uptime.Days -gt 30) {
        Write-Output "WARN Sistema sin reiniciar por mas de 30 dias"
        Write-Output "INFO Recomendamos reiniciar regularmente"
    }
} catch {
    Write-Output "WARN No se pudo verificar uptime: $_"
}

# 9. Resumen de salud
Write-Output ""
Write-Output "--- RESUMEN DE SALUD ---"
$healthScore = 0
$maxScore = 5

# Disco saludable
try {
    if ((Get-PhysicalDisk | Where-Object { $_.HealthStatus -eq "Healthy" }).Count -gt 0) { $healthScore++ }
} catch {}

# RAM no saturada
try {
    $os = Get-CimInstance Win32_OperatingSystem
    $memPercent = (($os.TotalVisibleMemorySize - $os.FreePhysicalMemory) / $os.TotalVisibleMemorySize) * 100
    if ($memPercent -lt 90) { $healthScore++ }
} catch {}

# CPU no saturada
try {
    $cpuLoad = (Get-Counter '\Processor(_Total)\% Processor Time').CounterSamples.CookedValue
    if ($cpuLoad -lt 90) { $healthScore++ }
} catch {}

# Sin errores criticos recientes
try {
    $criticalErrors = Get-EventLog -LogName System -EntryType Error -Newest 10 -ErrorAction SilentlyContinue
    if ($criticalErrors.Count -lt 5) { $healthScore++ }
} catch { $healthScore++ }

$healthScore++ # Punto por ejecutar el monitor

$percentage = [math]::Round(($healthScore / $maxScore) * 100)

Write-Output "Puntuacion de salud: $healthScore/$maxScore ($percentage%)"

if ($percentage -ge 80) {
    Write-Output "OK Tu sistema esta saludable"
} elseif ($percentage -ge 60) {
    Write-Output "WARN Tu sistema tiene algunos problemas menores"
} else {
    Write-Output "WARN Tu sistema tiene problemas que requieren atencion"
}

Write-Output ""
Write-Output "=== MONITOREO DE SALUD COMPLETADO ==="
