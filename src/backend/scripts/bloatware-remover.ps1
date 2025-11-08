param(
    [string]$DryRun = "true"
)

$DryRunBool = $DryRun -eq "true" -or $DryRun -eq "`$true" -or $DryRun -eq "1"
$ErrorActionPreference = "Continue"

Write-Output "=== LIMPIADOR DE BLOATWARE ==="
Write-Output "Modo: $(if ($DryRunBool) { 'DRY RUN (simulacion)' } else { 'EJECUCION REAL' })"
Write-Output ""

# Lista de apps de Windows que se pueden eliminar de forma segura
$bloatwareApps = @(
    "Microsoft.3DBuilder",
    "Microsoft.BingNews",
    "Microsoft.BingWeather",
    "Microsoft.GetHelp",
    "Microsoft.Getstarted",
    "Microsoft.Messaging",
    "Microsoft.Microsoft3DViewer",
    "Microsoft.MicrosoftOfficeHub",
    "Microsoft.MicrosoftSolitaireCollection",
    "Microsoft.MixedReality.Portal",
    "Microsoft.OneConnect",
    "Microsoft.People",
    "Microsoft.Print3D",
    "Microsoft.SkypeApp",
    "Microsoft.Wallet",
    "Microsoft.WindowsAlarms",
    "Microsoft.WindowsFeedbackHub",
    "Microsoft.WindowsMaps",
    "Microsoft.Xbox.TCUI",
    "Microsoft.XboxApp",
    "Microsoft.XboxGameOverlay",
    "Microsoft.XboxGamingOverlay",
    "Microsoft.XboxIdentityProvider",
    "Microsoft.XboxSpeechToTextOverlay",
    "Microsoft.YourPhone",
    "Microsoft.ZuneMusic",
    "Microsoft.ZuneVideo"
)

Write-Output "--- Apps de Windows Preinstaladas ---"
Write-Output "Buscando bloatware..."
Write-Output ""

$removedCount = 0
$failedCount = 0

foreach ($app in $bloatwareApps) {
    $package = Get-AppxPackage -Name $app -ErrorAction SilentlyContinue
    
    if ($package) {
        if ($DryRunBool) {
            Write-Output "[DRY RUN] Se eliminaria: $($package.Name)"
            $removedCount++
        } else {
            try {
                Remove-AppxPackage -Package $package.PackageFullName -ErrorAction Stop
                Write-Output "OK Eliminado: $($package.Name)"
                $removedCount++
            } catch {
                Write-Output "WARN No se pudo eliminar: $($package.Name)"
                $failedCount++
            }
        }
    }
}

Write-Output ""
Write-Output "--- Resumen ---"
Write-Output "Apps encontradas: $removedCount"
if (!$DryRunBool) {
    Write-Output "Apps eliminadas: $removedCount"
    Write-Output "Fallos: $failedCount"
}

Write-Output ""
Write-Output "=== LIMPIEZA DE BLOATWARE COMPLETADA ==="
Write-Output ""
Write-Output "NOTA: Las apps eliminadas se pueden reinstalar desde Microsoft Store si las necesitas"
