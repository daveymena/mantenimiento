param(
    [string]$DryRun = "true"
)

$DryRunBool = $DryRun -eq "true" -or $DryRun -eq "`$true" -or $DryRun -eq "1"
$ErrorActionPreference = "Continue"

Write-Output "=== LIMPIADOR AGRESIVO DE MEMORIA ==="
Write-Output "Modo: $(if ($DryRunBool) { 'DRY RUN (simulacion)' } else { 'EJECUCION REAL' })"
Write-Output ""

# Obtener estado inicial
$memBefore = Get-CimInstance Win32_OperatingSystem
$freeMemBefore = [math]::Round($memBefore.FreePhysicalMemory / 1MB, 2)
$totalMem = [math]::Round($memBefore.TotalVisibleMemorySize / 1MB, 2)
$percentBefore = [math]::Round((($totalMem - $freeMemBefore) / $totalMem) * 100, 2)

Write-Output "--- Estado Inicial ---"
Write-Output "RAM total: $totalMem GB"
Write-Output "RAM libre: $freeMemBefore GB"
Write-Output "Uso: $percentBefore%"
Write-Output ""

# 1. Identificar procesos pesados (excluyendo criticos)
Write-Output "--- Procesos Pesados ---"
$criticalProcesses = @(
    "System", "svchost", "csrss", "wininit", "services", "lsass", "winlogon",
    "explorer", "dwm", "RuntimeBroker", "SearchIndexer", "MsMpEng", 
    "SecurityHealthService", "fontdrvhost", "conhost", "powershell"
)

$heavyProcesses = Get-Process | Where-Object {
    $_.WorkingSet -gt 100MB -and 
    $criticalProcesses -notcontains $_.Name -and
    $_.Name -ne "Idle"
} | Sort-Object WorkingSet -Descending | Select-Object -First 10

Write-Output "Top 10 procesos por uso de RAM:"
foreach ($proc in $heavyProcesses) {
    $memMB = [math]::Round($proc.WorkingSet / 1MB, 2)
    Write-Output "  - $($proc.Name) (PID: $($proc.Id)): $memMB MB"
}

# 2. Cerrar procesos no criticos que consumen mucha RAM
Write-Output ""
Write-Output "--- Cerrando Procesos No Criticos ---"

$targetProcesses = @(
    "OneDrive", "Spotify", "Discord", "Slack", "Teams", "Steam", 
    "EpicGamesLauncher", "Origin", "Skype", "Zoom", "Chrome", 
    "msedge", "firefox", "opera"
)

$closedCount = 0
foreach ($procName in $targetProcesses) {
    $processes = Get-Process -Name $procName -ErrorAction SilentlyContinue
    
    if ($processes) {
        foreach ($proc in $processes) {
            $memMB = [math]::Round($proc.WorkingSet / 1MB, 2)
            
            if ($DryRunBool) {
                Write-Output "[DRY RUN] Se cerraría: $($proc.Name) ($memMB MB)"
                $closedCount++
            } else {
                try {
                    Stop-Process -Id $proc.Id -Force -ErrorAction Stop
                    Write-Output "OK Cerrado: $($proc.Name) ($memMB MB)"
                    $closedCount++
                } catch {
                    Write-Output "WARN No se pudo cerrar: $($proc.Name)"
                }
            }
        }
    }
}

Write-Output "Procesos cerrados: $closedCount"

# 3. Limpiar cache de sistema
Write-Output ""
Write-Output "--- Limpiando Cache del Sistema ---"

if (!$DryRunBool) {
    # Limpiar cache de DNS
    try {
        ipconfig /flushdns | Out-Null
        Write-Output "OK Cache DNS limpiado"
    } catch {
        Write-Output "WARN Error limpiando DNS"
    }
    
    # Limpiar cache de Windows Store
    try {
        wsreset.exe /noui
        Write-Output "OK Cache de Windows Store limpiado"
    } catch {
        Write-Output "WARN Error limpiando Store"
    }
    
    # Forzar garbage collection
    [System.GC]::Collect()
    [System.GC]::WaitForPendingFinalizers()
    [System.GC]::Collect()
    Write-Output "OK Garbage collection ejecutado"
    
    # Limpiar memoria standby (requiere RAMMap o similar)
    Write-Output "INFO Para limpiar memoria standby, usa: RAMMap o EmptyStandbyList"
} else {
    Write-Output "[DRY RUN] Se limpiaría cache DNS, Store y se ejecutaría GC"
}

# 4. Reducir procesos de svchost
Write-Output ""
Write-Output "--- Optimizando svchost ---"

if (!$DryRunBool) {
    # Detener servicios no esenciales
    $nonEssentialServices = @(
        "SysMain",          # Superfetch
        "WSearch",          # Windows Search
        "DiagTrack",        # Telemetria
        "dmwappushservice", # WAP Push
        "MapsBroker",       # Mapas
        "lfsvc",            # Geolocalizacion
        "RetailDemo"        # Demo de tienda
    )
    
    foreach ($service in $nonEssentialServices) {
        $svc = Get-Service -Name $service -ErrorAction SilentlyContinue
        
        if ($svc -and $svc.Status -eq "Running") {
            try {
                Stop-Service -Name $service -Force -ErrorAction Stop
                Set-Service -Name $service -StartupType Disabled -ErrorAction Stop
                Write-Output "OK Detenido: $($svc.DisplayName)"
            } catch {
                Write-Output "WARN No se pudo detener: $($svc.DisplayName)"
            }
        }
    }
} else {
    Write-Output "[DRY RUN] Se detendrían servicios no esenciales"
}

# 5. Limpiar archivos temporales en RAM
Write-Output ""
Write-Output "--- Limpiando Temporales ---"

if (!$DryRunBool) {
    $tempPaths = @($env:TEMP, "$env:windir\Temp", "$env:LOCALAPPDATA\Temp")
    
    foreach ($path in $tempPaths) {
        if (Test-Path $path) {
            try {
                Get-ChildItem -Path $path -Recurse -Force -ErrorAction SilentlyContinue |
                    Where-Object { !$_.PSIsContainer } |
                    Remove-Item -Force -ErrorAction SilentlyContinue
                Write-Output "OK Limpiado: $path"
            } catch {
                Write-Output "WARN Error limpiando: $path"
            }
        }
    }
} else {
    Write-Output "[DRY RUN] Se limpiarían archivos temporales"
}

# 6. Esperar y medir resultado
if (!$DryRunBool) {
    Write-Output ""
    Write-Output "Esperando 3 segundos para que el sistema se estabilice..."
    Start-Sleep -Seconds 3
}

# Estado final
Write-Output ""
Write-Output "--- Estado Final ---"
$memAfter = Get-CimInstance Win32_OperatingSystem
$freeMemAfter = [math]::Round($memAfter.FreePhysicalMemory / 1MB, 2)
$percentAfter = [math]::Round((($totalMem - $freeMemAfter) / $totalMem) * 100, 2)

Write-Output "RAM libre: $freeMemAfter GB"
Write-Output "Uso: $percentAfter%"

if (!$DryRunBool) {
    $memFreed = $freeMemAfter - $freeMemBefore
    $percentFreed = $percentBefore - $percentAfter
    
    Write-Output ""
    Write-Output "--- Resultado ---"
    Write-Output "RAM liberada: $([math]::Round($memFreed, 2)) GB"
    Write-Output "Reduccion de uso: $([math]::Round($percentFreed, 2))%"
    
    if ($memFreed -gt 0) {
        Write-Output "OK Memoria liberada exitosamente"
    } else {
        Write-Output "INFO No se pudo liberar memoria adicional"
    }
}

Write-Output ""
Write-Output "=== LIMPIEZA AGRESIVA COMPLETADA ==="
Write-Output ""
Write-Output "RECOMENDACIONES ADICIONALES:"
Write-Output "1. Cierra navegadores con muchas pestañas"
Write-Output "2. Reinicia el sistema si el problema persiste"
Write-Output "3. Considera agregar mas RAM si usas aplicaciones pesadas"
Write-Output "4. Usa el Administrador de tareas para identificar procesos especificos"
