$date = Get-Date -Format "yyyy-MM-dd__HH__mm"
Start-Transcript -path "C:\server\1_scripts\ark\log\updatelog__$date.txt"

Write-Host "ARK-Update STARTET." -ForegroundColor Yellow
Write-Host "ARK wird beendet!" -ForegroundColor Red
TASKKILL /IM ShooterGameServer.exe /F /T
Write-Host "ARK wurde beendet." -ForegroundColor Green

Write-Host "Backupverzeichnis wird erstellt!" -ForegroundColor Red
New-Item -ItemType "directory" -Path \\192.168.69.69\local_data\game_backups\ark_survival_evolved_dedicated_server
Write-Host "Verzeichniss erstellt." -ForegroundColor Green

Write-Host "Compress wird gestartet." -ForegroundColor Red
$compress = @{
    Path             = "C:\server\ark_survival_evolved_dedicated_server\ShooterGame\Saved"
    CompressionLevel = "Fastest"
    DestinationPath  = "\\192.168.69.69\local_data\game_backups\ark_survival_evolved_dedicated_server\$date.zip"
}
Compress-Archive @compress
Write-Host "Compress Fertig" -ForegroundColor Green

Write-Host "Steamcmd update wird gestartet." -ForegroundColor Red
C:\steamcmd\steamcmd.exe +login anonymous +force_install_dir c:\server\ark_survival_evolved_dedicated_server +app_update 376030 validate +quit
Write-Host "Update Fertig" -ForegroundColor Green

Write-Host "Server wird wieder gestartet." -ForegroundColor Red
powershell.exe C:\server\ark_survival_evolved_dedicated_server\ShooterGame\Binaries\Win64\ShooterGameServer.exe "TheIsland?listen?Port=<port>?QueryPort=<port>?MaxPlayers=69?SessionName=<name>?ServerPassword=<password>?ServerAdminPassword=<password>?AllowCaveBuildingPVE=true?ServerCrosshair=True?AllowThirdPersonPlayer=True?MapPlayerLocation=True" -UseBattlEye -UseDynamicConfig -log
                                                                                                                          #port 1 lower then QuaryPort #1 higher then Port  #seesion name here             #password here        #one more password here
Write-Host "Server gestartet?" -ForegroundColor Green
Stop-Transcript