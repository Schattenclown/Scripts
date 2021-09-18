$date = Get-Date -Format "yyyy-MM-dd__HH__mm"
Start-Transcript -path "C:\server\1_scripts\forest\log\updatelog $date.txt"

Write-Host "The-Forest-Update STARTET." -ForegroundColor Yellow
Write-Host "The-Forest wird beendet!" -ForegroundColor Red
TASKKILL /IM TheForestDedicatedServer.exe /F /T
Write-Host "The-Forest wurde beendet." -ForegroundColor Green

Write-Host "Backupverzeichnis wird erstellt!" -ForegroundColor Red
New-Item -ItemType "directory" -Path \\192.168.69.69\local_data\game_backups\the_forest_dedicated_server
Write-Host "Verzeichniss erstellt." -ForegroundColor Green

Write-Host "Compress wird gestartet." -ForegroundColor Red
$compress = @{
    Path             = "C:\Users\Administrator\AppData\LocalLow\SKS\TheForestDedicatedServer\ds\Multiplayer\Slot1"
    CompressionLevel = "Fastest"
    DestinationPath  = "\\192.168.69.69\local_data\game_backups\the_forest_dedicated_server\$date.zip"
}
Compress-Archive @compress
Write-Host "Compress Fertig" -ForegroundColor Green

Write-Host "Steamcmd update wird gestartet." -ForegroundColor Red
C:\steamcmd\steamcmd.exe +login anonymous +force_install_dir C:\server\the_forest_dedicated_server +app_update 556450 validate +quit
Write-Host "Update Fertig" -ForegroundColor Green

Write-Host "Server wird wieder gestartet." -ForegroundColor Red
powershell.exe C:\server\the_forest_dedicated_server\TheForestDedicatedServer.exe -log -batchmode serverplayers 8 -serversteamport port -servergameport port -serverqueryport port
                                                                                                                                  #port                 #port                 #port
Write-Host "Server gestartet?" -ForegroundColor Green
Stop-Transcript