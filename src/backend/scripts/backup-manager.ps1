param(
    [string]$Action = "status",
    [string]$BackupPath = "$env:USERPROFILE\PCMaintenanceBackup"
)

$ErrorActionPreference = "Continue"

Write-Output "=== GESTOR DE BACKUP AUTOMATICO ==="
Write-Output ""

if ($Action -eq "status") {
    Write-Output "--- Estado del Backup ---"
    
    # Verificar si existe carpeta de backup
    if (Test-Path $BackupPath) {
        $backupSize = (Get-ChildItem -Path $BackupPath -Recurse -ErrorAction SilentlyContinue | 
                       Measure-Object -Property Length -Sum).Sum
        $backupSizeGB = [math]::Round($backupSize / 1GB, 2)
        
        Write-Output "Ruta de backup: $BackupPath"
        Write-Output "Tamano total: $backupSizeGB GB"
        Write-Output "Ultimo backup: $(Get-Item $BackupPath).LastWriteTime"
    } else {
        Write-Output "No hay backups configurados"
        Write-Output "Ruta sugerida: $BackupPath"
    }
    
    # Verificar historial de archivos de Windows
    Write-Output ""
    Write-Output "--- Historial de Archivos de Windows ---"
    try {
        $fileHistory = Get-ItemProperty -Path "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\FileHistory" -ErrorAction SilentlyContinue
        if ($fileHistory) {
            Write-Output "Estado: Configurado"
        } else {
            Write-Output "Estado: No configurado"
            Write-Output "INFO Puedes configurarlo en: Configuracion > Actualizacion y seguridad > Copia de seguridad"
        }
    } catch {
        Write-Output "No se pudo verificar Historial de Archivos"
    }
    
    # Verificar puntos de restauracion
    Write-Output ""
    Write-Output "--- Puntos de Restauracion ---"
    try {
        $restorePoints = Get-ComputerRestorePoint -ErrorAction SilentlyContinue
        if ($restorePoints) {
            Write-Output "Puntos de restauracion disponibles: $($restorePoints.Count)"
            $restorePoints | Select-Object -First 5 | ForEach-Object {
                Write-Output "  - $($_.Description) ($($_.CreationTime))"
            }
        } else {
            Write-Output "No hay puntos de restauracion"
            Write-Output "WARN Recomendamos crear puntos de restauracion regularmente"
        }
    } catch {
        Write-Output "No se pudo verificar puntos de restauracion"
    }
    
} elseif ($Action -eq "create") {
    Write-Output "--- Crear Backup ---"
    
    # Crear carpeta de backup
    if (!(Test-Path $BackupPath)) {
        New-Item -Path $BackupPath -ItemType Directory -Force | Out-Null
        Write-Output "OK Carpeta de backup creada: $BackupPath"
    }
    
    # Backup de configuraciones importantes
    Write-Output ""
    Write-Output "Haciendo backup de configuraciones..."
    
    # 1. Drivers
    $driversPath = Join-Path $BackupPath "Drivers"
    Write-Output "INFO Para backup de drivers, ejecuta:"
    Write-Output "  dism /online /export-driver /destination:$driversPath"
    
    # 2. Lista de programas instalados
    $programsFile = Join-Path $BackupPath "InstalledPrograms.txt"
    Get-ItemProperty HKLM:\Software\Microsoft\Windows\CurrentVersion\Uninstall\* |
        Select-Object DisplayName, DisplayVersion, Publisher |
        Out-File -FilePath $programsFile
    Write-Output "OK Lista de programas guardada"
    
    # 3. Configuracion de red
    $networkFile = Join-Path $BackupPath "NetworkConfig.txt"
    ipconfig /all | Out-File -FilePath $networkFile
    Write-Output "OK Configuracion de red guardada"
    
    # 4. Informacion del sistema
    $systemFile = Join-Path $BackupPath "SystemInfo.txt"
    systeminfo | Out-File -FilePath $systemFile
    Write-Output "OK Informacion del sistema guardada"
    
    Write-Output ""
    Write-Output "OK Backup completado en: $BackupPath"
    
} elseif ($Action -eq "schedule") {
    Write-Output "--- Programar Backup Automatico ---"
    
    $taskName = "PCMaintenanceBackup"
    $scriptPath = $MyInvocation.MyCommand.Path
    
    Write-Output "Nombre de tarea: $taskName"
    Write-Output "Script: $scriptPath"
    Write-Output ""
    Write-Output "Para programar backup automatico:"
    Write-Output "  1. Abre Programador de tareas"
    Write-Output "  2. Crea tarea basica"
    Write-Output "  3. Programa: Semanal"
    Write-Output "  4. Accion: Ejecutar este script con -Action create"
    
} else {
    Write-Output "Accion no valida. Usa: status, create, schedule"
}

Write-Output ""
Write-Output "=== GESTION DE BACKUP COMPLETADA ==="
Write-Output ""
Write-Output "RECOMENDACIONES:"
Write-Output "1. Haz backups regularmente (semanal o mensual)"
Write-Output "2. Guarda backups en disco externo o nube"
Write-Output "3. Verifica que los backups funcionen"
Write-Output "4. Mantén al menos 3 copias de datos importantes"
