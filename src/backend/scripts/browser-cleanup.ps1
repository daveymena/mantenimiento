param(
    [bool]$DryRun = $true,
    [bool]$Chrome = $true,
    [bool]$Firefox = $true,
    [bool]$Edge = $true
)

$ErrorActionPreference = "Continue"

Write-Output "=== LIMPIEZA DE NAVEGADORES ==="
Write-Output "Modo: $(if ($DryRun) { 'DRY RUN' } else { 'REAL' })"
Write-Output ""

function Get-FolderSize {
    param([string]$Path)
    if (Test-Path $Path) {
        $size = (Get-ChildItem -Path $Path -Recurse -Force -ErrorAction SilentlyContinue | 
                 Measure-Object -Property Length -Sum -ErrorAction SilentlyContinue).Sum
        return [math]::Round($size / 1MB, 2)
    }
    return 0
}

function Clean-BrowserCache {
    param(
        [string]$BrowserName,
        [string[]]$CachePaths
    )
    
    Write-Output "--- $BrowserName ---"
    $totalSize = 0
    
    foreach ($path in $CachePaths) {
        $fullPath = [Environment]::ExpandEnvironmentVariables($path)
        
        if (Test-Path $fullPath) {
            $size = Get-FolderSize -Path $fullPath
            $totalSize += $size
            
            if ($DryRun) {
                Write-Output "[DRY RUN] Se limpiarían $size MB de: $fullPath"
            } else {
                try {
                    Remove-Item -Path "$fullPath\*" -Recurse -Force -ErrorAction SilentlyContinue
                    Write-Output "✓ Limpiado: $fullPath ($size MB)"
                } catch {
                    Write-Output "⚠ Error limpiando: $fullPath"
                }
            }
        }
    }
    
    Write-Output "Total $BrowserName : $totalSize MB"
    Write-Output ""
}

# Chrome
if ($Chrome) {
    $chromePaths = @(
        "%LOCALAPPDATA%\Google\Chrome\User Data\Default\Cache",
        "%LOCALAPPDATA%\Google\Chrome\User Data\Default\Code Cache",
        "%LOCALAPPDATA%\Google\Chrome\User Data\Default\GPUCache"
    )
    Clean-BrowserCache -BrowserName "Google Chrome" -CachePaths $chromePaths
}

# Firefox
if ($Firefox) {
    $firefoxPaths = @(
        "%LOCALAPPDATA%\Mozilla\Firefox\Profiles\*\cache2",
        "%LOCALAPPDATA%\Mozilla\Firefox\Profiles\*\startupCache"
    )
    Clean-BrowserCache -BrowserName "Mozilla Firefox" -CachePaths $firefoxPaths
}

# Edge
if ($Edge) {
    $edgePaths = @(
        "%LOCALAPPDATA%\Microsoft\Edge\User Data\Default\Cache",
        "%LOCALAPPDATA%\Microsoft\Edge\User Data\Default\Code Cache",
        "%LOCALAPPDATA%\Microsoft\Edge\User Data\Default\GPUCache"
    )
    Clean-BrowserCache -BrowserName "Microsoft Edge" -CachePaths $edgePaths
}

Write-Output "=== LIMPIEZA DE NAVEGADORES COMPLETADA ==="
