param(
    [string]$Action = "list",
    [bool]$DryRun = $true
)

$ErrorActionPreference = "Continue"

# Procesos que NUNCA se deben cerrar
$criticalProcesses = @(
    "System", "svchost", "csrss", "wininit", "services", "lsass", "winlogon",
    "explorer", "dwm", "RuntimeBroker", "SearchIndexer", "MsMpEng", "SecurityHealthService"
)

function Get-TopProcesses {
    Write-Output "=== PROCESOS CON MAYOR USO DE RECURSOS ==="
    Write-Output ""
    
    Write-Output "--- Top 10 por CPU ---"
    Get-Process | Sort-Object CPU -Descending | Select-Object -First 10 Name, CPU, WorkingSet | 
        Format-Table -AutoSize | Out-String | Write-Output
    
    Write-Output "--- Top 10 por Memoria ---"
    Get-Process | Sort-Object WorkingSet -Descending | Select-Object -First 10 Name, 
        @{Name="MemoryMB";Expression={[math]::Round($_.WorkingSet / 1MB, 2)}}, CPU | 
        Format-Table -AutoSize | Out-String | Write-Output
}

function Stop-NonCriticalProcesses {
    Write-Output "=== CERRANDO PROCESOS NO CRÍTICOS ==="
    Write-Output ""
    
    # Lista de procesos comunes no críticos que consumen recursos
    $targetProcesses = @(
        "OneDrive", "Spotify", "Discord", "Slack", "Teams", 
        "Steam", "EpicGamesLauncher", "Origin"
    )
    
    foreach ($procName in $targetProcesses) {
        $processes = Get-Process -Name $procName -ErrorAction SilentlyContinue
        
        if ($processes) {
            foreach ($proc in $processes) {
                if ($criticalProcesses -notcontains $proc.Name) {
                    if ($DryRun) {
                        Write-Output "[DRY RUN] Se cerraría: $($proc.Name) (PID: $($proc.Id))"
                    } else {
                        try {
                            Stop-Process -Id $proc.Id -Force -ErrorAction Stop
                            Write-Output "✓ Cerrado: $($proc.Name) (PID: $($proc.Id))"
                        } catch {
                            Write-Output "⚠ No se pudo cerrar: $($proc.Name)"
                        }
                    }
                }
            }
        }
    }
}

# Ejecutar acción
switch ($Action) {
    "list" {
        Get-TopProcesses
    }
    "cleanup" {
        Stop-NonCriticalProcesses
    }
    default {
        Write-Output "Acción no válida. Usa: list, cleanup"
    }
}
