param(
    [bool]$DryRun = $true
)

$logsPath = Join-Path $PSScriptRoot "..\..\..\logs"

if (Test-Path $logsPath) {
    $logs = Get-ChildItem -Path $logsPath -Filter "*.log" | 
            Sort-Object LastWriteTime -Descending | 
            Select-Object -First 10 Name, LastWriteTime, Length
    
    $logs | ForEach-Object {
        Write-Output "$($_.Name) - $($_.LastWriteTime) - $([math]::Round($_.Length/1KB, 2)) KB"
    }
} else {
    Write-Output "No hay logs disponibles"
}
