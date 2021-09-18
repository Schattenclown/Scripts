$date = Get-Date -Format "yyyy-MM-dd__HH__mm"
Start-Transcript -path "C:\server\1_scripts\valheim\log\updatelog $date.txt"

Write-Host "Valheim-Update STARTET." -ForegroundColor Yellow
Write-Host "Valheim wird beendet!" -ForegroundColor Red
TASKKILL /IM valheim_server.exe /F /T
Write-Host "Valheim wurde beendet." -ForegroundColor Green

Write-Host "Backupverzeichnis wird erstellt!" -ForegroundColor Red
New-Item -ItemType "directory" -Path \\192.168.69.69\local_data\game_backups\valheim_dedicated_server
Write-Host "Verzeichniss erstellt." -ForegroundColor Green

Write-Host "Compress wird gestartet." -ForegroundColor Red
$compress = @{
    Path             = "C:\Users\Administrator\AppData\LocalLow\IronGate\Valheim"
    CompressionLevel = "Fastest"
    DestinationPath  = "\\192.168.69.69\local_data\game_backups\valheim_dedicated_server\$date.zip"
}
Compress-Archive @compress
Write-Host "Compress Fertig" -ForegroundColor Green

Write-Host "Steamcmd update wird gestartet." -ForegroundColor Red
C:\steamcmd\steamcmd.exe +login anonymous +force_install_dir C:\server\valheim_dedicated_server +app_update 896660 validate +quit
Write-Host "Update Fertig" -ForegroundColor Green

Write-Host "Server wird wieder gestartet." -ForegroundColor Red
powershell.exe C:\server\valheim_dedicated_server\valheim_start.ps1
Write-Host "Server gestartet?" -ForegroundColor Green
Stop-Transcript