$date = Get-Date -Format "yyyy-MM-dd__HH__mm"
Start-Transcript -path "C:\server\1_scripts\csgo\log\updatelog $date.txt"
Write-Host "csgo-Update STARTET." -ForegroundColor Yellow
#Write-Host "csgo wird beendet!" -ForegroundColor Red
#mussnoch
#TASKKILL /IM ThecsgoDedicatedServer.exe /F /T
#Write-Host "csgo wurde beendet." -ForegroundColor Green
#Write-Host "Backupverzeichnis wird erstellt!" -ForegroundColor Red
#New-Item -ItemType "directory" -Path "C:\server\2_backups\csgo_dedicated_server\$date"
#Write-Host "Verzeichniss erstellt." -ForegroundColor Green
#Write-Host "Mirror wird gestartet." -ForegroundColor Red
#robocopy C:\Users\Administrator\AppData\LocalLow\SKS\ThecsgoDedicatedServer\ds\Multiplayer\Slot1 C:\server\2_backups\valC:\server\csgo_dedicated_server\$date /MIR
#Write-Host "Backup Fertig" -ForegroundColor Green
Write-Host "Steamcmd update wird gestartet." -ForegroundColor Red
C:\steamcmd\steamcmd.exe +login anonymous +force_install_dir C:\server\csgo_dedicated_server +app_update 740 validate +quit
Write-Host "Update Fertig" -ForegroundColor Green
# Write-Host "Server wird wieder gestartet." -ForegroundColor Red
#powershell.exe C:\server\csgo_dedicated_server\ThecsgoDedicatedServer.exe -batchmode
#Write-Host "Server gestartet?" -ForegroundColor Green
Stop-Transcript