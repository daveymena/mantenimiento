param(
    [string]$Action = "scan",
    [string]$DryRun = "true"
)

$DryRunBool = $DryRun -eq "true" -or $DryRun -eq "`$true" -or $DryRun -eq "1"
$ErrorActionPreference = "Continue"

Write-Output "=== ACTUALIZADOR AUTOMATICO DE DRIVERS ==="
Write-Output "Accion: $Action"
Write-Output "Modo: $(if ($DryRunBool) { 'DRY RUN (simulacion)' } else { 'EJECUCION REAL' })"
Write-Output ""

function Get-DriverInfo {
    Write-Output "--- Escaneando Drivers del Sistema ---"
    Write-Output "Esto puede tardar unos segundos..."
    Write-Output ""
    
    try {
        $drivers = Get-WmiObject Win32_PnPSignedDriver | 
                   Where-Object { $_.DeviceName -ne $null } |
                   Select-Object DeviceName, DriverVersion, Manufacturer, DriverDate, DeviceID |
                   Sort-Object DeviceName
        
        Write-Output "Total de drivers encontrados: $($drivers.Count)"
        Write-Output ""
        
        # Categorizar drivers
        $categories = @{
            'Display' = @()
            'Network' = @()
            'Audio' = @()
            'USB' = @()
            'Storage' = @()
            'Other' = @()
        }
        
        foreach ($driver in $drivers) {
            $deviceName = $driver.DeviceName.ToLower()
            
            if ($deviceName -match 'display|video|graphics|nvidia|amd|intel.*graphics') {
                $categories['Display'] += $driver
            }
            elseif ($deviceName -match 'network|ethernet|wi-fi|wireless|bluetooth') {
                $categories['Network'] += $driver
            }
            elseif ($deviceName -match 'audio|sound|realtek.*audio') {
                $categories['Audio'] += $driver
            }
            elseif ($deviceName -match 'usb|hub') {
                $categories['USB'] += $driver
            }
            elseif ($deviceName -match 'disk|storage|sata|nvme') {
                $categories['Storage'] += $driver
            }
            else {
                $categories['Other'] += $driver
            }
        }
        
        # Mostrar drivers criticos
        Write-Output "=== DRIVERS CRITICOS ==="
        Write-Output ""
        
        foreach ($category in @('Display', 'Network', 'Audio', 'Storage')) {
            if ($categories[$category].Count -gt 0) {
                Write-Output "--- $category ---"
                $categories[$category] | Select-Object -First 3 | ForEach-Object {
                    Write-Output "Dispositivo: $($_.DeviceName)"
                    Write-Output "  Version: $($_.DriverVersion)"
                    Write-Output "  Fabricante: $($_.Manufacturer)"
                    Write-Output "  Fecha: $($_.DriverDate)"
                    Write-Output ""
                }
            }
        }
        
        return $drivers
        
    } catch {
        Write-Output "Error escaneando drivers: $_"
        return $null
    }
}

function Update-DriversViaWindowsUpdate {
    Write-Output "--- Actualizacion via Windows Update ---"
    
    if ($DryRunBool) {
        Write-Output "[DRY RUN] Se buscarian actualizaciones de drivers via Windows Update"
        Write-Output "[DRY RUN] Comando: pnputil /scan-devices"
    } else {
        Write-Output "Escaneando dispositivos para actualizaciones..."
        
        try {
            # Forzar escaneo de dispositivos
            pnputil /scan-devices
            Write-Output "OK Escaneo completado"
            Write-Output ""
            Write-Output "INFO Ahora ve a: Configuracion > Windows Update > Buscar actualizaciones"
            Write-Output "INFO Windows Update descargara drivers automaticamente"
        } catch {
            Write-Output "WARN Error ejecutando pnputil: $_"
        }
    }
}

function Get-CriticalDriverUpdates {
    Write-Output "--- Verificando Drivers Criticos ---"
    Write-Output ""
    
    # GPU Drivers
    Write-Output "GPU (Tarjeta Grafica):"
    $gpu = Get-WmiObject Win32_VideoController
    foreach ($g in $gpu) {
        Write-Output "  - $($g.Name)"
        Write-Output "    Version: $($g.DriverVersion)"
        Write-Output "    Fecha: $($g.DriverDate)"
        
        # Detectar fabricante y sugerir descarga
        if ($g.Name -match 'NVIDIA') {
            Write-Output "    Actualizar en: https://www.nvidia.com/Download/index.aspx"
        }
        elseif ($g.Name -match 'AMD|Radeon') {
            Write-Output "    Actualizar en: https://www.amd.com/en/support"
        }
        elseif ($g.Name -match 'Intel') {
            Write-Output "    Actualizar en: https://www.intel.com/content/www/us/en/download-center/home.html"
        }
    }
    Write-Output ""
    
    # Network Adapters
    Write-Output "Adaptadores de Red:"
    $network = Get-WmiObject Win32_NetworkAdapter | Where-Object { $_.NetEnabled -eq $true }
    foreach ($n in $network) {
        Write-Output "  - $($n.Name)"
        Write-Output "    Fabricante: $($n.Manufacturer)"
    }
    Write-Output ""
    
    # Audio
    Write-Output "Dispositivos de Audio:"
    $audio = Get-WmiObject Win32_SoundDevice
    foreach ($a in $audio) {
        Write-Output "  - $($a.Name)"
        Write-Output "    Fabricante: $($a.Manufacturer)"
    }
    Write-Output ""
}

function Backup-Drivers {
    param([string]$BackupPath = "$env:USERPROFILE\Desktop\DriversBackup")
    
    Write-Output "--- Backup de Drivers ---"
    Write-Output "Ruta: $BackupPath"
    Write-Output ""
    
    if ($DryRunBool) {
        Write-Output "[DRY RUN] Se crearia backup de drivers en: $BackupPath"
        Write-Output "[DRY RUN] Comando: dism /online /export-driver /destination:$BackupPath"
    } else {
        Write-Output "Creando backup de drivers..."
        Write-Output "Esto puede tardar varios minutos..."
        Write-Output ""
        
        try {
            # Crear carpeta si no existe
            if (!(Test-Path $BackupPath)) {
                New-Item -Path $BackupPath -ItemType Directory -Force | Out-Null
            }
            
            # Exportar drivers
            dism /online /export-driver /destination:$BackupPath
            
            Write-Output ""
            Write-Output "OK Backup completado en: $BackupPath"
            Write-Output "INFO Guarda esta carpeta en un lugar seguro"
            
        } catch {
            Write-Output "WARN Error creando backup: $_"
        }
    }
}

# Ejecutar accion
switch ($Action) {
    "scan" {
        $drivers = Get-DriverInfo
        Write-Output ""
        Write-Output "=== ESCANEO COMPLETADO ==="
    }
    
    "update" {
        Get-DriverInfo
        Write-Output ""
        Update-DriversViaWindowsUpdate
        Write-Output ""
        Write-Output "=== ACTUALIZACION INICIADA ==="
        Write-Output ""
        Write-Output "PASOS SIGUIENTES:"
        Write-Output "1. Abre Configuracion > Windows Update"
        Write-Output "2. Haz clic en 'Buscar actualizaciones'"
        Write-Output "3. Windows descargara drivers automaticamente"
        Write-Output "4. Reinicia el sistema cuando termine"
    }
    
    "check" {
        Get-CriticalDriverUpdates
        Write-Output ""
        Write-Output "=== VERIFICACION COMPLETADA ==="
        Write-Output ""
        Write-Output "RECOMENDACIONES:"
        Write-Output "1. Visita los sitios web de los fabricantes"
        Write-Output "2. Descarga los drivers mas recientes"
        Write-Output "3. Instala y reinicia el sistema"
    }
    
    "backup" {
        Backup-Drivers
        Write-Output ""
        Write-Output "=== BACKUP COMPLETADO ==="
    }
    
    "list" {
        Get-DriverInfo
        Write-Output ""
        Write-Output "=== LISTADO COMPLETADO ==="
    }
    
    default {
        Write-Output "Accion no valida. Usa: scan, update, check, backup, list"
    }
}

Write-Output ""
Write-Output "NOTA IMPORTANTE:"
Write-Output "- Siempre descarga drivers de sitios oficiales"
Write-Output "- Crea un restore point antes de actualizar drivers"
Write-Output "- Reinicia el sistema despues de actualizar"
