param(
    [string]$DryRun = "true"
)

$ErrorActionPreference = "Continue"

Write-Output "=== ANALIZADOR DE SEGURIDAD ==="
Write-Output ""

# 1. Estado de Windows Defender
Write-Output "--- Windows Defender ---"
try {
    $defender = Get-MpComputerStatus
    Write-Output "Antivirus habilitado: $($defender.AntivirusEnabled)"
    Write-Output "Antispyware habilitado: $($defender.AntispywareEnabled)"
    Write-Output "Proteccion en tiempo real: $($defender.RealTimeProtectionEnabled)"
    Write-Output "Ultima actualizacion: $($defender.AntivirusSignatureLastUpdated)"
    
    if (!$defender.RealTimeProtectionEnabled) {
        Write-Output "WARN Proteccion en tiempo real deshabilitada!"
    } else {
        Write-Output "OK Windows Defender activo"
    }
} catch {
    Write-Output "WARN No se pudo verificar Windows Defender: $_"
}

# 2. Estado del Firewall
Write-Output ""
Write-Output "--- Firewall de Windows ---"
try {
    $firewall = Get-NetFirewallProfile
    
    foreach ($profile in $firewall) {
        Write-Output "Perfil: $($profile.Name)"
        Write-Output "  Estado: $($profile.Enabled)"
        
        if (!$profile.Enabled) {
            Write-Output "  WARN Firewall deshabilitado en perfil $($profile.Name)!"
        }
    }
} catch {
    Write-Output "WARN No se pudo verificar Firewall: $_"
}

# 3. Windows Update
Write-Output ""
Write-Output "--- Windows Update ---"
try {
    $updateService = Get-Service -Name wuauserv
    Write-Output "Servicio Windows Update: $($updateService.Status)"
    
    if ($updateService.Status -ne "Running") {
        Write-Output "WARN Windows Update no esta ejecutandose"
    } else {
        Write-Output "OK Windows Update activo"
    }
} catch {
    Write-Output "WARN No se pudo verificar Windows Update: $_"
}

# 4. UAC (Control de Cuentas de Usuario)
Write-Output ""
Write-Output "--- Control de Cuentas de Usuario (UAC) ---"
try {
    $uac = Get-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System" -Name "EnableLUA"
    
    if ($uac.EnableLUA -eq 1) {
        Write-Output "OK UAC habilitado"
    } else {
        Write-Output "WARN UAC deshabilitado (riesgo de seguridad)"
    }
} catch {
    Write-Output "WARN No se pudo verificar UAC: $_"
}

# 5. Actualizaciones pendientes
Write-Output ""
Write-Output "--- Actualizaciones Pendientes ---"
Write-Output "INFO Para verificar actualizaciones pendientes:"
Write-Output "  Configuracion > Actualizacion y seguridad > Windows Update"

# 6. Puertos abiertos
Write-Output ""
Write-Output "--- Puertos Abiertos ---"
try {
    $connections = Get-NetTCPConnection | Where-Object { $_.State -eq "Listen" } | 
                   Select-Object LocalAddress, LocalPort, OwningProcess -Unique |
                   Sort-Object LocalPort |
                   Select-Object -First 10
    
    Write-Output "Primeros 10 puertos en escucha:"
    foreach ($conn in $connections) {
        $process = Get-Process -Id $conn.OwningProcess -ErrorAction SilentlyContinue
        Write-Output "Puerto $($conn.LocalPort): $($process.Name)"
    }
} catch {
    Write-Output "WARN No se pudo listar puertos: $_"
}

# 7. Usuarios con privilegios de administrador
Write-Output ""
Write-Output "--- Usuarios Administradores ---"
try {
    $admins = Get-LocalGroupMember -Group "Administradores" -ErrorAction SilentlyContinue
    Write-Output "Usuarios con privilegios de administrador:"
    foreach ($admin in $admins) {
        Write-Output "  - $($admin.Name)"
    }
} catch {
    Write-Output "WARN No se pudo listar administradores: $_"
}

# 8. Resumen de seguridad
Write-Output ""
Write-Output "--- RESUMEN DE SEGURIDAD ---"
$securityScore = 0
$maxScore = 5

try {
    if ((Get-MpComputerStatus).RealTimeProtectionEnabled) { $securityScore++ }
} catch {}

try {
    if ((Get-NetFirewallProfile | Where-Object { $_.Name -eq "Domain" }).Enabled) { $securityScore++ }
} catch {}

try {
    if ((Get-Service -Name wuauserv).Status -eq "Running") { $securityScore++ }
} catch {}

try {
    if ((Get-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System" -Name "EnableLUA").EnableLUA -eq 1) { $securityScore++ }
} catch {}

$securityScore++ # Punto por ejecutar el analisis

$percentage = [math]::Round(($securityScore / $maxScore) * 100)

Write-Output "Puntuacion de seguridad: $securityScore/$maxScore ($percentage%)"

if ($percentage -ge 80) {
    Write-Output "OK Tu sistema tiene buena seguridad"
} elseif ($percentage -ge 60) {
    Write-Output "WARN Tu sistema tiene seguridad aceptable, pero mejorable"
} else {
    Write-Output "WARN Tu sistema tiene problemas de seguridad importantes"
}

Write-Output ""
Write-Output "=== ANALISIS DE SEGURIDAD COMPLETADO ==="
