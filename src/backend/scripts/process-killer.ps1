param(
    [string]$DryRun = "true",
    [int]$MinMemoryMB = 200
)

$DryRunBool = $DryRun -eq "true" -or $DryRun -eq "`$true" -or $DryRun -eq "1"
$ErrorActionPreference = "Continue"

Write-Output "=== ELIMINADOR DE PROCESOS PESADOS ==="
Write-Output "Modo: $(if ($DryRunBool) { 'DRY RUN (simulacion)' } else { 'EJECUCION REAL' })"
Write-Output "Umbral minimo: $MinMemoryMB MB"
Write-Output ""

# Procesos que NUNCA se deben cerrar
$protectedProcesses = @(
    "System", "svchost", "csrss", "wininit", "services", "lsass", "winlogon",
    "explorer", "dwm", "RuntimeBroker", "SearchIndexer", "MsMpEng", 
    "SecurityHealthService", "fontdrvhost", "conhost", "powershell",
    "cmd", "taskmgr", "regedit", "mmc", "services"
)

# Obtener procesos pesados
$heavyProcesses = Get-Process | Where-Object {
    ($_.WorkingSet / 1MB) -gt $MinMemoryMB -and 
    $protectedProcesses -notcontains $_.Name -and
    $_.Name -ne "Idle" -and
    $_.Name -ne "System Idle Process"
} | Sort-Object WorkingSet -Descending

Write-Output "--- Procesos que Consumen Mas de $MinMemoryMB MB ---"
Write-Output "Total encontrados: $($heavyProcesses.Count)"
Write-Output ""

if ($heavyProcesses.Count -eq 0) {
    Write-Output "OK No hay procesos pesados que cerrar"
    exit 0
}

$totalMemToFree = 0
$closedCount = 0

foreach ($proc in $heavyProcesses) {
    $memMB = [math]::Round($proc.WorkingSet / 1MB, 2)
    $cpuPercent = [math]::Round($proc.CPU, 2)
    
    Write-Output "Proceso: $($proc.Name) (PID: $($proc.Id))"
    Write-Output "  RAM: $memMB MB"
    Write-Output "  CPU: $cpuPercent segundos"
    Write-Output "  Ruta: $($proc.Path)"
    
    # Preguntar si es seguro cerrar (en modo interactivo)
    $isSafe = $true
    
    # Verificar si es un proceso del sistema
    if ($proc.Path -like "*Windows\System32*" -or $proc.Path -like "*Windows\SysWOW64*") {
        Write-Output "  WARN Proceso del sistema - NO se cerrara"
        $isSafe = $false
    }
    
    if ($isSafe) {
        if ($DryRunBool) {
            Write-Output "  [DRY RUN] Se cerraría este proceso"
            $totalMemToFree += $memMB
            $closedCount++
        } else {
            try {
                Stop-Process -Id $proc.Id -Force -ErrorAction Stop
                Write-Output "  OK Proceso cerrado"
                $totalMemToFree += $memMB
                $closedCount++
            } catch {
                Write-Output "  WARN No se pudo cerrar: $_"
            }
        }
    }
    
    Write-Output ""
}

Write-Output "--- Resumen ---"
Write-Output "Procesos cerrados: $closedCount"
Write-Output "Memoria a liberar: $([math]::Round($totalMemToFree / 1024, 2)) GB"

Write-Output ""
Write-Output "=== ELIMINACION DE PROCESOS COMPLETADA ==="
