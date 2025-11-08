param(
    [string]$DryRun = "true"
)

# Convertir string a boolean
$DryRunBool = $DryRun -eq "true" -or $DryRun -eq "$true" -or $DryRun -eq "1"

$ErrorActionPreference = "Continue"

function Get-TempSize {
    $paths = @($env:TEMP, "$env:windir\Temp")
    $totalSize = 0
    
    foreach ($p in $paths) {
        if (Test-Path $p) {
            $size = (Get-ChildItem -Path $p -Recurse -Force -ErrorAction SilentlyContinue | 
                     Measure-Object -Property Length -Sum -ErrorAction SilentlyContinue).Sum
            $totalSize += $size
        }
    }
    
    return [math]::Round($totalSize / 1MB, 2)
}

function Get-StartupApps {
    $apps = @()
    $regPaths = @(
        "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Run",
        "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Run"
    )
    
    foreach ($regPath in $regPaths) {
        if (Test-Path $regPath) {
            $items = Get-ItemProperty -Path $regPath -ErrorAction SilentlyContinue
            if ($items) {
                $items.PSObject.Properties | Where-Object { $_.Name -notlike "PS*" } | ForEach-Object {
                    $apps += @{
                        Name = $_.Name
                        Command = $_.Value
                        Location = $regPath
                    }
                }
            }
        }
    }
    
    return $apps
}

function Get-NonCriticalServices {
    $blacklist = @("wuauserv", "WinDefend", "MpsSvc", "BFE", "Dhcp", "Dnscache")
    $services = Get-Service | Where-Object { 
        $_.Status -eq "Running" -and 
        $_.StartType -ne "Disabled" -and
        $blacklist -notcontains $_.Name
    } | Select-Object -First 10 Name, DisplayName, Status, StartType
    
    return $services
}

# Escaneo
Write-Output "=== ESCANEO DEL SISTEMA ==="
Write-Output ""

$tempSize = Get-TempSize
Write-Output "Archivos temporales: $tempSize MB"

$startupApps = Get-StartupApps
Write-Output "Aplicaciones en inicio: $($startupApps.Count)"

$services = Get-NonCriticalServices
Write-Output "Servicios no críticos en ejecución: $($services.Count)"

$memory = Get-CimInstance Win32_OperatingSystem
$freeMemoryMB = [math]::Round($memory.FreePhysicalMemory / 1024, 2)
$totalMemoryMB = [math]::Round($memory.TotalVisibleMemorySize / 1024, 2)
Write-Output "Memoria libre: $freeMemoryMB MB de $totalMemoryMB MB"

# Resultado JSON
$result = @{
    tempSize = $tempSize
    startupAppsCount = $startupApps.Count
    startupApps = $startupApps
    servicesCount = $services.Count
    services = $services
    freeMemory = $freeMemoryMB
    totalMemory = $totalMemoryMB
} | ConvertTo-Json -Depth 3

Write-Output ""
Write-Output "JSON_RESULT:"
Write-Output $result
