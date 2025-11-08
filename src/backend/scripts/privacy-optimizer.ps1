param(
    [string]$DryRun = "true"
)

$DryRunBool = $DryRun -eq "true" -or $DryRun -eq "`$true" -or $DryRun -eq "1"
$ErrorActionPreference = "Continue"

Write-Output "=== OPTIMIZADOR DE PRIVACIDAD ==="
Write-Output "Modo: $(if ($DryRunBool) { 'DRY RUN (simulacion)' } else { 'EJECUCION REAL' })"
Write-Output ""

# 1. Deshabilitar telemetria
Write-Output "--- Telemetria de Windows ---"
$telemetryPath = "HKLM:\SOFTWARE\Policies\Microsoft\Windows\DataCollection"

if ($DryRunBool) {
    Write-Output "[DRY RUN] Se deshabilitaria la telemetria de Windows"
} else {
    try {
        if (!(Test-Path $telemetryPath)) {
            New-Item -Path $telemetryPath -Force | Out-Null
        }
        Set-ItemProperty -Path $telemetryPath -Name "AllowTelemetry" -Value 0 -Type DWord
        Write-Output "OK Telemetria deshabilitada"
    } catch {
        Write-Output "WARN Error deshabilitando telemetria: $_"
    }
}

# 2. Deshabilitar Cortana
Write-Output ""
Write-Output "--- Cortana ---"
$cortanaPath = "HKLM:\SOFTWARE\Policies\Microsoft\Windows\Windows Search"

if ($DryRunBool) {
    Write-Output "[DRY RUN] Se deshabilitaria Cortana"
} else {
    try {
        if (!(Test-Path $cortanaPath)) {
            New-Item -Path $cortanaPath -Force | Out-Null
        }
        Set-ItemProperty -Path $cortanaPath -Name "AllowCortana" -Value 0 -Type DWord
        Write-Output "OK Cortana deshabilitada"
    } catch {
        Write-Output "WARN Error deshabilitando Cortana: $_"
    }
}

# 3. Deshabilitar sugerencias de Windows
Write-Output ""
Write-Output "--- Sugerencias de Windows ---"
$suggestionsPath = "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\ContentDeliveryManager"

if ($DryRunBool) {
    Write-Output "[DRY RUN] Se deshabilitarian las sugerencias"
} else {
    try {
        Set-ItemProperty -Path $suggestionsPath -Name "SystemPaneSuggestionsEnabled" -Value 0 -Type DWord -ErrorAction SilentlyContinue
        Set-ItemProperty -Path $suggestionsPath -Name "SubscribedContent-338388Enabled" -Value 0 -Type DWord -ErrorAction SilentlyContinue
        Write-Output "OK Sugerencias deshabilitadas"
    } catch {
        Write-Output "WARN Error deshabilitando sugerencias: $_"
    }
}

# 4. Deshabilitar ubicacion
Write-Output ""
Write-Output "--- Servicios de Ubicacion ---"
$locationPath = "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\CapabilityAccessManager\ConsentStore\location"

if ($DryRunBool) {
    Write-Output "[DRY RUN] Se deshabilitaria el servicio de ubicacion"
} else {
    try {
        Set-ItemProperty -Path $locationPath -Name "Value" -Value "Deny" -ErrorAction SilentlyContinue
        Write-Output "OK Ubicacion deshabilitada"
    } catch {
        Write-Output "WARN Error deshabilitando ubicacion: $_"
    }
}

# 5. Deshabilitar anuncios personalizados
Write-Output ""
Write-Output "--- Anuncios Personalizados ---"
$adsPath = "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\AdvertisingInfo"

if ($DryRunBool) {
    Write-Output "[DRY RUN] Se deshabilitarian los anuncios personalizados"
} else {
    try {
        if (!(Test-Path $adsPath)) {
            New-Item -Path $adsPath -Force | Out-Null
        }
        Set-ItemProperty -Path $adsPath -Name "Enabled" -Value 0 -Type DWord
        Write-Output "OK Anuncios personalizados deshabilitados"
    } catch {
        Write-Output "WARN Error deshabilitando anuncios: $_"
    }
}

# 6. Deshabilitar feedback de Windows
Write-Output ""
Write-Output "--- Feedback de Windows ---"
$feedbackPath = "HKCU:\SOFTWARE\Microsoft\Siuf\Rules"

if ($DryRunBool) {
    Write-Output "[DRY RUN] Se deshabilitaria el feedback de Windows"
} else {
    try {
        if (!(Test-Path $feedbackPath)) {
            New-Item -Path $feedbackPath -Force | Out-Null
        }
        Set-ItemProperty -Path $feedbackPath -Name "NumberOfSIUFInPeriod" -Value 0 -Type DWord
        Write-Output "OK Feedback deshabilitado"
    } catch {
        Write-Output "WARN Error deshabilitando feedback: $_"
    }
}

Write-Output ""
Write-Output "=== OPTIMIZACION DE PRIVACIDAD COMPLETADA ==="
Write-Output ""
Write-Output "NOTA: Algunos cambios requieren reiniciar Windows para aplicarse"
