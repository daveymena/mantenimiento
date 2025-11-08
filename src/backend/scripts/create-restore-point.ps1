param(
    [string]$DryRun = "true"
)

# Convertir string a boolean
$DryRunBool = $DryRun -eq "true" -or $DryRun -eq "$true" -or $DryRun -eq "1"

$ErrorActionPreference = "Stop"

Write-Output "=== CREANDO RESTORE POINT ==="

if ($DryRunBool) {
    Write-Output "[DRY RUN] Se crearía un restore point llamado 'PCMaintenance-BeforeOptimization'"
    exit 0
}

try {
    # Verificar si System Protection está habilitado
    $sp = Get-ComputerRestorePoint -ErrorAction SilentlyContinue
    
    # Crear restore point
    Checkpoint-Computer -Description "PCMaintenance-BeforeOptimization" -RestorePointType "MODIFY_SETTINGS"
    Write-Output "✓ Restore point creado exitosamente"
    exit 0
} catch {
    Write-Output "⚠ Error al crear restore point: $_"
    Write-Output "Nota: Asegúrate de que System Protection esté habilitado en las propiedades del sistema"
    exit 1
}
