param(
    [string]$Drive = "C:"
)

$ErrorActionPreference = "Continue"

Write-Output "=== ANÁLISIS DE DISCO $Drive ==="
Write-Output ""

# Información general del disco
$disk = Get-PSDrive -Name $Drive.TrimEnd(':') -ErrorAction SilentlyContinue
if ($disk) {
    $usedGB = [math]::Round($disk.Used / 1GB, 2)
    $freeGB = [math]::Round($disk.Free / 1GB, 2)
    $totalGB = [math]::Round(($disk.Used + $disk.Free) / 1GB, 2)
    $usedPercent = [math]::Round(($disk.Used / ($disk.Used + $disk.Free)) * 100, 2)
    
    Write-Output "Capacidad total: $totalGB GB"
    Write-Output "Espacio usado: $usedGB GB ($usedPercent%)"
    Write-Output "Espacio libre: $freeGB GB"
    Write-Output ""
}

# Carpetas grandes
Write-Output "--- Carpetas más grandes ---"
$folders = @(
    "$env:USERPROFILE\Downloads",
    "$env:USERPROFILE\Documents",
    "$env:USERPROFILE\Videos",
    "$env:USERPROFILE\Pictures",
    "$env:USERPROFILE\Music",
    "$env:LOCALAPPDATA\Temp",
    "$env:windir\Temp",
    "$env:LOCALAPPDATA\Microsoft\Windows\INetCache"
)

$folderSizes = @()
foreach ($folder in $folders) {
    if (Test-Path $folder) {
        $size = (Get-ChildItem -Path $folder -Recurse -Force -ErrorAction SilentlyContinue | 
                 Measure-Object -Property Length -Sum -ErrorAction SilentlyContinue).Sum
        $sizeGB = [math]::Round($size / 1GB, 2)
        
        if ($sizeGB -gt 0) {
            $folderSizes += [PSCustomObject]@{
                Folder = $folder
                SizeGB = $sizeGB
            }
        }
    }
}

$folderSizes | Sort-Object SizeGB -Descending | ForEach-Object {
    Write-Output "$($_.Folder): $($_.SizeGB) GB"
}

Write-Output ""
Write-Output "=== ANÁLISIS COMPLETADO ==="
