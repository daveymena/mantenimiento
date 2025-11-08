param(
    [string]$DryRun = "true",
    [string]$CleanTemp = "false",
    [string]$OptimizeStartup = "false",
    [string]$OptimizeServices = "false",
    [string]$FreeMemory = "false"
)

# Convertir strings a booleans
$DryRunBool = $DryRun -eq "true" -or $DryRun -eq "`$true" -or $DryRun -eq "1"
$CleanTempBool = $CleanTemp -eq "true" -or $CleanTemp -eq "`$true" -or $CleanTemp -eq "1"
$OptimizeStartupBool = $OptimizeStartup -eq "true" -or $OptimizeStartup -eq "`$true" -or $OptimizeStartup -eq "1"
$OptimizeServicesBool = $OptimizeServices -eq "true" -or $OptimizeServices -eq "`$true" -or $OptimizeServices -eq "1"
$FreeMemoryBool = $FreeMemory -eq "true" -or $FreeMemory -eq "`$true" -or $FreeMemory -eq "1"

$ErrorActionPreference = "Continue"

Write-Output "=== OPTIMIZACION DEL SISTEMA ==="
Write-Output "Modo: $(if ($DryRunBool) { 'DRY RUN (simulacion)' } else { 'EJECUCION REAL' })"
Write-Output ""

# 1. Limpiar archivos temporales
if ($CleanTempBool) {
    Write-Output "--- Limpieza de archivos temporales ---"
    $paths = @($env:TEMP, "$env:windir\Temp")
    
    foreach ($p in $paths) {
        if (Test-Path $p) {
            $fileCount = (Get-ChildItem -Path $p -Recurse -Force -ErrorAction SilentlyContinue | Measure-Object).Count
            
            if ($DryRunBool) {
                Write-Output "[DRY RUN] Se eliminarian $fileCount archivos de: $p"
            } else {
                try {
                    Get-ChildItem -Path $p -Recurse -Force -ErrorAction SilentlyContinue | 
                        Remove-Item -Force -Recurse -ErrorAction SilentlyContinue
                    Write-Output "OK Limpiado: $p ($fileCount archivos)"
                } catch {
                    Write-Output "WARN Error limpiando $p : $_"
                }
            }
        }
    }
    
    # Ejecutar Disk Cleanup
    if ($DryRunBool) {
        Write-Output "[DRY RUN] Se ejecutaria Disk Cleanup (cleanmgr)"
    } else {
        Start-Process -FilePath "cleanmgr.exe" -ArgumentList "/sagerun:1" -NoNewWindow -Wait -ErrorAction SilentlyContinue
        Write-Output "OK Disk Cleanup ejecutado"
    }
}

# 2. Optimizar aplicaciones de inicio
if ($OptimizeStartupBool) {
    Write-Output ""
    Write-Output "--- Optimizacion de inicio ---"
    
    $regPath = "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Run"
    $nonCriticalApps = @()
    
    if (Test-Path $regPath) {
        $items = Get-ItemProperty -Path $regPath -ErrorAction SilentlyContinue
        
        if ($DryRunBool) {
            Write-Output "[DRY RUN] Apps de inicio detectadas:"
            $items.PSObject.Properties | Where-Object { $_.Name -notlike "PS*" } | ForEach-Object {
                Write-Output "  - $($_.Name)"
            }
        } else {
            Write-Output "INFO En modo real, aqui se deshabilitarian apps especificas"
            Write-Output "  (Requiere configuracion de whitelist/blacklist)"
        }
    }
}

# 3. Optimizar servicios
if ($OptimizeServicesBool) {
    Write-Output ""
    Write-Output "--- Optimizacion de servicios ---"
    
    $safeToStop = @("TabletInputService", "Fax", "XblAuthManager", "XblGameSave", "XboxNetApiSvc")
    $blacklist = @("wuauserv", "WinDefend", "MpsSvc", "BFE", "Dhcp", "Dnscache", "EventLog")
    
    foreach ($serviceName in $safeToStop) {
        $service = Get-Service -Name $serviceName -ErrorAction SilentlyContinue
        
        if ($service -and $service.Status -eq "Running" -and $blacklist -notcontains $serviceName) {
            if ($DryRunBool) {
                Write-Output "[DRY RUN] Se detendria servicio: $($service.DisplayName)"
            } else {
                try {
                    Stop-Service -Name $serviceName -Force -ErrorAction Stop
                    Set-Service -Name $serviceName -StartupType Manual -ErrorAction Stop
                    Write-Output "OK Servicio detenido: $($service.DisplayName)"
                } catch {
                    Write-Output "WARN No se pudo detener: $($service.DisplayName)"
                }
            }
        }
    }
}

# 4. Liberar memoria
if ($FreeMemoryBool) {
    Write-Output ""
    Write-Output "--- Liberacion de memoria ---"
    
    if ($DryRunBool) {
        Write-Output "[DRY RUN] Se ejecutaria limpieza de memoria y procesos no criticos"
    } else {
        [System.GC]::Collect()
        [System.GC]::WaitForPendingFinalizers()
        Write-Output "OK Garbage collection ejecutado"
        
        try {
            powercfg /setactive SCHEME_MIN
            Write-Output "OK Plan de energia ajustado a Alto Rendimiento"
        } catch {
            Write-Output "WARN No se pudo cambiar plan de energia"
        }
    }
}

Write-Output ""
Write-Output "=== OPTIMIZACION COMPLETADA ==="
