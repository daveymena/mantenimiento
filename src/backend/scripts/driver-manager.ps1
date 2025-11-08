param(
    [string]$Action = "list"
)

$ErrorActionPreference = "Continue"

Write-Output "=== GESTOR DE DRIVERS ==="
Write-Output ""

if ($Action -eq "list") {
    Write-Output "--- Drivers Instalados ---"
    
    try {
        Write-Output "Obteniendo lista de drivers..."
        Write-Output ""
        
        $drivers = Get-WmiObject Win32_PnPSignedDriver -ErrorAction Stop | 
                   Where-Object { $_.DeviceName -ne $null } |
                   Select-Object DeviceName, DriverVersion, Manufacturer, DriverDate |
                   Sort-Object DeviceName
        
        Write-Output "Total de drivers encontrados: $($drivers.Count)"
        Write-Output ""
        
        # Categorizar drivers importantes
        Write-Output "=== DRIVERS CRITICOS ==="
        Write-Output ""
        
        # GPU
        $gpuDrivers = $drivers | Where-Object { $_.DeviceName -like "*display*" -or $_.DeviceName -like "*graphics*" -or $_.DeviceName -like "*video*" }
        if ($gpuDrivers) {
            Write-Output "GPU / Display:"
            $gpuDrivers | ForEach-Object {
                Write-Output "  - $($_.DeviceName)"
                Write-Output "    Version: $($_.DriverVersion) | Fecha: $($_.DriverDate)"
            }
            Write-Output ""
        }
        
        # Red
        $netDrivers = $drivers | Where-Object { $_.DeviceName -like "*network*" -or $_.DeviceName -like "*ethernet*" -or $_.DeviceName -like "*wi-fi*" -or $_.DeviceName -like "*wireless*" }
        if ($netDrivers) {
            Write-Output "Red / Network:"
            $netDrivers | ForEach-Object {
                Write-Output "  - $($_.DeviceName)"
                Write-Output "    Version: $($_.DriverVersion) | Fecha: $($_.DriverDate)"
            }
            Write-Output ""
        }
        
        # Audio
        $audioDrivers = $drivers | Where-Object { $_.DeviceName -like "*audio*" -or $_.DeviceName -like "*sound*" }
        if ($audioDrivers) {
            Write-Output "Audio / Sonido:"
            $audioDrivers | ForEach-Object {
                Write-Output "  - $($_.DeviceName)"
                Write-Output "    Version: $($_.DriverVersion) | Fecha: $($_.DriverDate)"
            }
            Write-Output ""
        }
        
        # Almacenamiento
        $storageDrivers = $drivers | Where-Object { $_.DeviceName -like "*storage*" -or $_.DeviceName -like "*disk*" -or $_.DeviceName -like "*nvme*" -or $_.DeviceName -like "*sata*" }
        if ($storageDrivers) {
            Write-Output "Almacenamiento:"
            $storageDrivers | ForEach-Object {
                Write-Output "  - $($_.DeviceName)"
                Write-Output "    Version: $($_.DriverVersion) | Fecha: $($_.DriverDate)"
            }
            Write-Output ""
        }
        
        Write-Output "=== OTROS DRIVERS ==="
        Write-Output "Total: $($drivers.Count) drivers instalados"
        Write-Output "INFO Para ver la lista completa, abre el Administrador de Dispositivos (devmgmt.msc)"
        
    } catch {
        Write-Output "ERROR listando drivers: $_"
        Write-Output "INFO Intenta ejecutar como Administrador"
    }
    
} elseif ($Action -eq "outdated") {
    Write-Output "--- Verificacion de Drivers Desactualizados ---"
    Write-Output ""
    
    # Verificar dispositivos con problemas
    Write-Output "Buscando dispositivos con problemas..."
    try {
        $problemDevices = Get-WmiObject Win32_PnPEntity -ErrorAction Stop | 
                         Where-Object { $_.ConfigManagerErrorCode -ne 0 }
        
        if ($problemDevices) {
            Write-Output ""
            Write-Output "WARN Dispositivos con problemas detectados:"
            foreach ($device in $problemDevices) {
                Write-Output "  - $($device.Name)"
                Write-Output "    Codigo de error: $($device.ConfigManagerErrorCode)"
                Write-Output "    Estado: $($device.Status)"
            }
            Write-Output ""
            Write-Output "RECOMENDACION: Actualiza los drivers de estos dispositivos"
        } else {
            Write-Output "OK No se detectaron dispositivos con problemas"
        }
    } catch {
        Write-Output "WARN No se pudo verificar dispositivos: $_"
    }
    
    Write-Output ""
    Write-Output "=== COMO ACTUALIZAR DRIVERS ==="
    Write-Output ""
    Write-Output "Metodo 1 - Windows Update (Recomendado):"
    Write-Output "  1. Abre Configuracion (Win + I)"
    Write-Output "  2. Ve a Actualizacion y seguridad > Windows Update"
    Write-Output "  3. Click en 'Buscar actualizaciones'"
    Write-Output "  4. Click en 'Ver actualizaciones opcionales'"
    Write-Output "  5. Selecciona actualizaciones de drivers"
    Write-Output ""
    Write-Output "Metodo 2 - Sitios Oficiales:"
    Write-Output "  GPU NVIDIA: https://www.nvidia.com/Download/index.aspx"
    Write-Output "  GPU AMD: https://www.amd.com/en/support"
    Write-Output "  Intel: https://www.intel.com/content/www/us/en/download-center/home.html"
    Write-Output "  Fabricante de tu laptop/PC"
    Write-Output ""
    Write-Output "Metodo 3 - Administrador de Dispositivos:"
    Write-Output "  1. Abre devmgmt.msc"
    Write-Output "  2. Click derecho en el dispositivo"
    Write-Output "  3. Selecciona 'Actualizar controlador'"
    Write-Output ""
    Write-Output "PRECAUCION: Evita herramientas de terceros dudosas"
    
} elseif ($Action -eq "backup") {
    Write-Output "--- Backup de Drivers ---"
    Write-Output ""
    
    $backupPath = "$env:USERPROFILE\Desktop\DriversBackup"
    $timestamp = Get-Date -Format "yyyyMMdd_HHmmss"
    $backupPathWithDate = "$env:USERPROFILE\Desktop\DriversBackup_$timestamp"
    
    Write-Output "=== INFORMACION DE BACKUP ==="
    Write-Output ""
    Write-Output "Ruta sugerida: $backupPathWithDate"
    Write-Output ""
    
    Write-Output "=== METODOS DE BACKUP ==="
    Write-Output ""
    Write-Output "Metodo 1 - DISM (Recomendado, requiere Admin):"
    Write-Output "  Comando:"
    Write-Output "  dism /online /export-driver /destination:`"$backupPathWithDate`""
    Write-Output ""
    Write-Output "  Esto exporta TODOS los drivers de terceros instalados"
    Write-Output ""
    
    Write-Output "Metodo 2 - PowerShell (requiere Admin):"
    Write-Output "  Export-WindowsDriver -Online -Destination `"$backupPathWithDate`""
    Write-Output ""
    
    Write-Output "Metodo 3 - Herramientas de terceros:"
    Write-Output "  - Double Driver (gratuito)"
    Write-Output "  - DriverBackup! (gratuito)"
    Write-Output "  - Snappy Driver Installer (open source)"
    Write-Output ""
    
    Write-Output "=== CUANDO HACER BACKUP ==="
    Write-Output "  - Antes de actualizar Windows"
    Write-Output "  - Antes de actualizar drivers importantes (GPU, chipset)"
    Write-Output "  - Antes de reinstalar Windows"
    Write-Output "  - Periodicamente (mensual recomendado)"
    Write-Output ""
    
    Write-Output "=== RESTAURAR DRIVERS ==="
    Write-Output "  1. Abre Administrador de Dispositivos (devmgmt.msc)"
    Write-Output "  2. Click derecho en el dispositivo"
    Write-Output "  3. Actualizar controlador > Buscar en el equipo"
    Write-Output "  4. Selecciona la carpeta de backup"
    Write-Output ""
    
    # Verificar si ya existe un backup
    if (Test-Path "$env:USERPROFILE\Desktop\DriversBackup*") {
        Write-Output "INFO Se encontraron backups previos en el escritorio"
        Get-ChildItem "$env:USERPROFILE\Desktop\DriversBackup*" -Directory | ForEach-Object {
            Write-Output "  - $($_.Name) ($(Get-Date $_.CreationTime -Format 'yyyy-MM-dd HH:mm'))"
        }
    }
    
} else {
    Write-Output "Accion no valida. Usa: list, outdated, backup"
}

Write-Output "=== GESTION DE DRIVERS COMPLETADA ==="
