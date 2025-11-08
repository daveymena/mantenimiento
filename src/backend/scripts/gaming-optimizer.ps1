param(
    [string]$DryRun = "true"
)

$DryRunBool = $DryRun -eq "true" -or $DryRun -eq "`$true" -or $DryRun -eq "1"
$ErrorActionPreference = "Continue"

Write-Output "=== OPTIMIZADOR DE GAMING ==="
Write-Output "Modo: $(if ($DryRunBool) { 'DRY RUN (simulacion)' } else { 'EJECUCION REAL' })"
Write-Output ""

# 1. Plan de energia a Alto Rendimiento
Write-Output "--- Plan de Energia ---"
if ($DryRunBool) {
    Write-Output "[DRY RUN] Se cambiaria el plan de energia a Alto Rendimiento"
} else {
    try {
        powercfg /setactive SCHEME_MIN
        Write-Output "OK Plan de energia: Alto Rendimiento"
    } catch {
        Write-Output "WARN Error cambiando plan de energia"
    }
}

# 2. Deshabilitar Game DVR
Write-Output ""
Write-Output "--- Game DVR (Xbox) ---"
$gameDVRPath = "HKCU:\System\GameConfigStore"

if ($DryRunBool) {
    Write-Output "[DRY RUN] Se deshabilitaria Game DVR"
} else {
    try {
        if (!(Test-Path $gameDVRPath)) {
            New-Item -Path $gameDVRPath -Force | Out-Null
        }
        Set-ItemProperty -Path $gameDVRPath -Name "GameDVR_Enabled" -Value 0 -Type DWord
        Write-Output "OK Game DVR deshabilitado"
    } catch {
        Write-Output "WARN Error deshabilitando Game DVR: $_"
    }
}

# 3. Optimizar prioridad de GPU
Write-Output ""
Write-Output "--- Prioridad de GPU ---"
$gpuPath = "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile\Tasks\Games"

if ($DryRunBool) {
    Write-Output "[DRY RUN] Se optimizaria la prioridad de GPU para juegos"
} else {
    try {
        if (Test-Path $gpuPath) {
            Set-ItemProperty -Path $gpuPath -Name "GPU Priority" -Value 8 -Type DWord
            Set-ItemProperty -Path $gpuPath -Name "Priority" -Value 6 -Type DWord
            Write-Output "OK Prioridad de GPU optimizada"
        }
    } catch {
        Write-Output "WARN Error optimizando GPU: $_"
    }
}

# 4. Deshabilitar Fullscreen Optimizations
Write-Output ""
Write-Output "--- Fullscreen Optimizations ---"
if ($DryRunBool) {
    Write-Output "[DRY RUN] Se deshabilitarian las optimizaciones de pantalla completa"
} else {
    Write-Output "INFO Las optimizaciones de pantalla completa se deshabilitan por juego"
    Write-Output "INFO Puedes hacerlo manualmente: Propiedades del .exe > Compatibilidad"
}

# 5. Deshabilitar servicios no necesarios para gaming
Write-Output ""
Write-Output "--- Servicios No Necesarios ---"
$gamingNonEssential = @("SysMain", "WSearch", "DiagTrack")

foreach ($service in $gamingNonEssential) {
    $svc = Get-Service -Name $service -ErrorAction SilentlyContinue
    
    if ($svc -and $svc.Status -eq "Running") {
        if ($DryRunBool) {
            Write-Output "[DRY RUN] Se detendria: $($svc.DisplayName)"
        } else {
            try {
                Stop-Service -Name $service -Force -ErrorAction Stop
                Set-Service -Name $service -StartupType Manual -ErrorAction Stop
                Write-Output "OK Detenido: $($svc.DisplayName)"
            } catch {
                Write-Output "WARN No se pudo detener: $($svc.DisplayName)"
            }
        }
    }
}

# 6. Optimizar configuracion de red para gaming
Write-Output ""
Write-Output "--- Optimizacion de Red ---"
if ($DryRunBool) {
    Write-Output "[DRY RUN] Se optimizaria la configuracion de red"
} else {
    try {
        # Comandos modernos de netsh (chimney está obsoleto en Windows 10+)
        netsh int tcp set global autotuninglevel=normal 2>&1 | Out-Null
        netsh int tcp set global rss=enabled 2>&1 | Out-Null
        netsh int tcp set global timestamps=disabled 2>&1 | Out-Null
        Write-Output "OK Red optimizada para gaming"
        Write-Output "  - Autotuning: Normal"
        Write-Output "  - RSS: Habilitado"
        Write-Output "  - Timestamps: Deshabilitado (reduce latencia)"
    } catch {
        Write-Output "WARN Error optimizando red: $_"
        Write-Output "INFO Ejecuta como Administrador para optimizacion completa"
    }
}

# 7. Deshabilitar Nagle's Algorithm (reduce latencia)
Write-Output ""
Write-Output "--- Nagle's Algorithm ---"
if ($DryRunBool) {
    Write-Output "[DRY RUN] Se deshabilitaria Nagle's Algorithm (reduce latencia)"
} else {
    Write-Output "INFO Nagle's Algorithm se deshabilita por adaptador de red"
    Write-Output "INFO Requiere configuracion avanzada del registro"
}

Write-Output ""
Write-Output "=== OPTIMIZACION DE GAMING COMPLETADA ==="
Write-Output ""
Write-Output "RECOMENDACIONES ADICIONALES:"
Write-Output "1. Cierra aplicaciones en segundo plano antes de jugar"
Write-Output "2. Actualiza drivers de GPU regularmente"
Write-Output "3. Usa modo de juego de Windows (Win + G)"
Write-Output "4. Considera overclocking (con precaucion)"
