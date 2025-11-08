param(
    [string]$Action = "list",
    [string]$Frequency = "daily",
    [string]$Time = "02:00"
)

$TaskName = "PCMaintenanceOptimizer"
$TaskPath = "\PCMaintenance\"

function Create-ScheduledTask {
    param(
        [string]$Freq,
        [string]$TaskTime
    )
    
    Write-Output "Creando tarea programada..."
    
    # Ruta al script de optimización
    $scriptPath = Join-Path $PSScriptRoot "optimize-system.ps1"
    $action = New-ScheduledTaskAction -Execute "powershell.exe" `
        -Argument "-ExecutionPolicy Bypass -File `"$scriptPath`" -DryRun `$false -CleanTemp `$true"
    
    # Trigger según frecuencia
    switch ($Freq) {
        "daily" {
            $trigger = New-ScheduledTaskTrigger -Daily -At $TaskTime
        }
        "weekly" {
            $trigger = New-ScheduledTaskTrigger -Weekly -DaysOfWeek Sunday -At $TaskTime
        }
        "monthly" {
            $trigger = New-ScheduledTaskTrigger -Weekly -WeeksInterval 4 -DaysOfWeek Sunday -At $TaskTime
        }
    }
    
    # Configuración
    $principal = New-ScheduledTaskPrincipal -UserId "SYSTEM" -LogonType ServiceAccount -RunLevel Highest
    $settings = New-ScheduledTaskSettingsSet -AllowStartIfOnBatteries -DontStopIfGoingOnBatteries
    
    # Registrar tarea
    try {
        Register-ScheduledTask -TaskName $TaskName -TaskPath $TaskPath `
            -Action $action -Trigger $trigger -Principal $principal -Settings $settings -Force
        Write-Output "✓ Tarea programada creada: $Freq a las $TaskTime"
    } catch {
        Write-Output "✗ Error al crear tarea: $_"
        exit 1
    }
}

function Remove-ScheduledTask {
    try {
        Unregister-ScheduledTask -TaskName $TaskName -TaskPath $TaskPath -Confirm:$false
        Write-Output "✓ Tarea programada eliminada"
    } catch {
        Write-Output "⚠ No se encontró la tarea o error al eliminar: $_"
    }
}

function Get-ScheduledTask {
    try {
        $task = Get-ScheduledTask -TaskName $TaskName -TaskPath $TaskPath -ErrorAction Stop
        Write-Output "Tarea encontrada:"
        Write-Output "  Nombre: $($task.TaskName)"
        Write-Output "  Estado: $($task.State)"
        Write-Output "  Última ejecución: $($task.LastRunTime)"
        Write-Output "  Próxima ejecución: $($task.NextRunTime)"
    } catch {
        Write-Output "No hay tarea programada configurada"
    }
}

# Ejecutar acción
switch ($Action) {
    "create" {
        Create-ScheduledTask -Freq $Frequency -TaskTime $Time
    }
    "remove" {
        Remove-ScheduledTask
    }
    "list" {
        Get-ScheduledTask
    }
    default {
        Write-Output "Acción no válida. Usa: create, remove, list"
    }
}
