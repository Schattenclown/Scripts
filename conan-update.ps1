$date = Get-Date -Format "yyyy-MM-dd__HH__mm"
Start-Transcript -path "C:\server\1_scripts\conan\log\updatelog $date.txt"

Write-Host "Conan-Update STARTET." -ForegroundColor Yellow
Write-Host "Conan wird beendet!" -ForegroundColor Red
TASKKILL /IM ConanSandboxServer-Win64-Test.exe /F /T
Write-Host "Conan wurde beendet." -ForegroundColor Green

Write-Host "Backupverzeichnis wird erstellt!" -ForegroundColor Red
New-Item -ItemType "directory" -Path \\192.168.69.69\local_data\game_backups\conan_exiles_dedicated_server
Write-Host "Verzeichniss erstellt." -ForegroundColor Green

Write-Host "Compress wird gestartet." -ForegroundColor Red
$compress = @{
    Path             = "C:\server\conan_exiles_dedicated_server\ConanSandbox\Saved"
    CompressionLevel = "Fastest"
    DestinationPath  = "\\192.168.69.69\local_data\game_backups\conan_exiles_dedicated_server\$date.zip"
}
Compress-Archive @compress
Write-Host "Compress Fertig" -ForegroundColor Green

Write-Host "Steamcmd update wird gestartet." -ForegroundColor Red
C:\steamcmd\steamcmd.exe +login anonymous +force_install_dir C:\server\conan_exiles_dedicated_server\ +app_update 443030 +workshop_download_item 440900 1159180273 +workshop_download_item 440900 1369743238 +workshop_download_item 440900 1542041983 +workshop_download_item 440900 1797359985 +workshop_download_item 440900 864199675 +workshop_download_item 440900 880454836 +workshop_download_item 440900 931088249 +workshop_download_item 440900 1966733568 +workshop_download_item 440900 1928978003 +workshop_download_item 440900 1367404881 +workshop_download_item 440900 2050780234 +workshop_download_item 440900 1629644846 +workshop_download_item 440900 1386174080 +workshop_download_item 440900 1934607107 +workshop_download_item 440900 901911361 +workshop_download_item 440900 1417350098 +workshop_download_item 440900 1502970736 +workshop_download_item 440900 1394768794 +workshop_download_item 440900 1402835318 +workshop_download_item 440900 2377569193 +workshop_download_item 440900 2098700751 +workshop_download_item 440900 2010870025 +workshop_download_item 440900 1403991684 +workshop_download_item 440900 880177231 +workshop_download_item 440900 877108545 +workshop_download_item 440900 1976970830 +workshop_download_item 440900 1185321962 +workshop_download_item 440900 1890943363 +workshop_download_item 440900 2419910241 +workshop_download_item 440900 1125427722 +workshop_download_item 440900 1545911731 +workshop_download_item 440900 1802389425 +workshop_download_item 440900 2275543723 +workshop_download_item 440900 1705201022 +workshop_download_item 440900 1396310739 validate +quit
Write-Host "Update Fertig" -ForegroundColor Green

Write-Host "Server wird wieder gestartet." -ForegroundColor Red
powershell.exe C:\server\conan_exiles_dedicated_server\ConanSandboxServer.exe -log -MaxPlayers=69 -Port=<port> -QueryPort=<port> -usedir=SERVER1
                                                                                                        #port             #port
Write-Host "Server gestartet?" -ForegroundColor Green
Stop-Transcript