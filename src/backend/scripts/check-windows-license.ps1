param(
    [string]$DryRun = "true"
)

$ErrorActionPreference = "Continue"

Write-Output "=== VERIFICADOR DE ESTADO DE WINDOWS ==="
Write-Output ""

# 1. Estado de activacion
Write-Output "--- Estado de Activacion ---"
try {
    $license = Get-CimInstance -ClassName SoftwareLicensingProduct | Where-Object { $_.PartialProductKey -ne $null }
    
    if ($license) {
        Write-Output "Producto: $($license.Name)"
        Write-Output "Estado: $($license.LicenseStatus)"
        Write-Output "Descripcion: $($license.Description)"
        
        switch ($license.LicenseStatus) {
            0 { Write-Output "Estado: Sin licencia" }
            1 { Write-Output "Estado: Licenciado (Activado)" }
            2 { Write-Output "Estado: OOB Grace" }
            3 { Write-Output "Estado: OOT Grace" }
            4 { Write-Output "Estado: Non-Genuine Grace" }
            5 { Write-Output "Estado: Notification" }
            6 { Write-Output "Estado: Extended Grace" }
        }
        
        if ($license.PartialProductKey) {
            Write-Output "Product Key (parcial): *****-$($license.PartialProductKey)"
        }
    }
} catch {
    Write-Output "Error obteniendo informacion de licencia: $_"
}

# 2. Version de Windows
Write-Output ""
Write-Output "--- Version de Windows ---"
$os = Get-CimInstance -ClassName Win32_OperatingSystem
Write-Output "Sistema: $($os.Caption)"
Write-Output "Version: $($os.Version)"
Write-Output "Build: $($os.BuildNumber)"
Write-Output "Arquitectura: $($os.OSArchitecture)"

# 3. Tipo de licencia
Write-Output ""
Write-Output "--- Tipo de Licencia ---"
try {
    $channel = (Get-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion" -Name "EditionID" -ErrorAction SilentlyContinue).EditionID
    Write-Output "Edicion: $channel"
} catch {
    Write-Output "No se pudo determinar el tipo de licencia"
}

# 4. Fecha de instalacion
Write-Output ""
Write-Output "--- Informacion del Sistema ---"
Write-Output "Fecha de instalacion: $($os.InstallDate)"
Write-Output "Ultimo arranque: $($os.LastBootUpTime)"

# 5. Recomendaciones
Write-Output ""
Write-Output "--- Recomendaciones ---"
if ($license.LicenseStatus -ne 1) {
    Write-Output "WARN Windows no esta activado"
    Write-Output "INFO Opciones legitimas:"
    Write-Output "  1. Comprar licencia oficial de Microsoft"
    Write-Output "  2. Licencias OEM economicas (10-30 USD)"
    Write-Output "  3. Usar Windows sin activar (funcional con marca de agua)"
    Write-Output "  4. Windows Insider Program (gratis)"
} else {
    Write-Output "OK Windows esta correctamente activado"
}

Write-Output ""
Write-Output "=== VERIFICACION COMPLETADA ==="
