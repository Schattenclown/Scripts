#███████  ██████ ██████   ██████  ██      ██          ██████   ██████  ██     ██ ███    ██ 
#██      ██      ██   ██ ██    ██ ██      ██          ██   ██ ██    ██ ██     ██ ████   ██ 
#███████ ██      ██████  ██    ██ ██      ██          ██   ██ ██    ██ ██  █  ██ ██ ██  ██ 
#     ██ ██      ██   ██ ██    ██ ██      ██          ██   ██ ██    ██ ██ ███ ██ ██  ██ ██ 
#███████  ██████ ██   ██  ██████  ███████ ███████     ██████   ██████   ███ ███  ██   ████ 
function Update {
    param (
        [String]$_fqdn,
        [String]$_updatetoken,
        [String]$_logpath
    )
    # (mandatory) adjust your values
    $fqdn = $_fqdn
    $updatetoken = $_updatetoken
    $user = $_fqdn

    # (optional) set full path to (writable) logfile and switch logging on ($true) or off ($false)
    $myLogFile = $_logpath
    $logging = $true

    # (optional) add or remove service sites. NOTE: A service sites MUST return a plain IP string WITHOUT any HTML tags!
    $myServiceList = "http://checkip4.spdns.de"
    #"http://ipecho.net/plain"
    ### no necessity to edit below this line ###
    function log {
        param(
            [Parameter(ValueFromPipeline = $true)]
            $piped
        )

        if ($logging) {
            (Get-Date -Format "yyyy-MM-dd HH:mm:ss").ToString() + " " + `
                $piped | Out-File -FilePath $myLogFile -Append
        }
        # console output
        "$piped"
    }

    function checkIP ($myServiceAddress) {

        try {
            $myIP = Invoke-WebRequest -Uri $myServiceAddress -UseBasicParsing -TimeoutSec 10 -ErrorAction Stop

            if ( -not ($myIP) -or -not ($myIP -match '^(?:[0-9]{1,3}\.){3}[0-9]{1,3}$')) {
                "checkIP " + "No valid response" | log
                #exit 1
            }

        }
        catch {
            "checkIP " + $_.Exception.Message | log
            #exit 1
        }

        Return "$myIP"
    }

    $usedService = Get-Random -InputObject $myServiceList
    "checkIP " + "Determine current IP at " + $usedService | log
    $currentIP = checkIP $usedService

    try {
        if (([System.Environment]::OSVersion.Version.Major -eq 6) -and ([System.Environment]::OSVersion.Version.Minor -eq 1)) {
            "Resolve DNS Name " + "Using System.Net.Dns" | log
            # workaround for Windows 7/2008R2
            $ipHostEntry = [System.Net.Dns]::GetHostByName($fqdn)
            $registeredIP = ($ipHostEntry.AddressList).IPAddressToString 
        }
        else {
            "Resolve DNS Name " + "Using native Commandlet" | log
            $ipHostEntry = Resolve-DnsName $fqdn -Type A -ErrorAction Stop
            $registeredIP = $ipHostEntry[0].IPAddress
        }

    }
    catch {
        "Resolve DNS Name " + $_.Exception.Message | log
        #exit 1
    }


    if ($registeredIP -like $currentIP) {
        "Precheck " + "IP $currentIP already registered." | log
        #exit 0
    }
    else {
        $secpasswd = ConvertTo-SecureString $updatetoken -AsPlainText -Force
        $myCreds = New-Object System.Management.Automation.PSCredential ($user, $secpasswd)
        $url = "https://update.spdyn.de/nic/update?hostname=$fqdn&myip=$currentIP"

        try {
            $resp = Invoke-WebRequest -Uri $url -Credential $myCreds -UseBasicParsing -ErrorAction Stop
        }
        catch {
            $Host.UI.RawUI.ForegroundColor = 'Red'
            "Update DNS " + $_.Exception.Message | log
            $Host.UI.RawUI.ForegroundColor = 'Yellow'
            #exit 1
        }
        $Host.UI.RawUI.ForegroundColor = 'Green'
        "SPDNS result " + $resp.Content | log
    }

    #exit 0
}

#███████ ███████ ████████ ████████ ██ ███    ██  ██████  ███████ 
#██      ██         ██       ██    ██ ████   ██ ██       ██      
#███████ █████      ██       ██    ██ ██ ██  ██ ██   ███ ███████ 
#     ██ ██         ██       ██    ██ ██  ██ ██ ██    ██      ██ 
#███████ ███████    ██       ██    ██ ██   ████  ██████  ███████ 

#Array für Subdomains müssen mit den Arrayplätzen der Updatetoken übereinstimmen 
$fqdn_array = 
@(
    "demo1.spdns.de",
    "demo2.spdns.de",
    "demo3.spdns.de"
)
#Updatetokenarray der updatetoken muss im gleichen arrayslot sein wie die Subdomain
$updatetoken_array =
@(
    "key1-key1-key1",
    "key2-key2-key2",
    "key3-key3-key3"
)
$logpath = "C:\UpdateScript\Logs"
#Sleep anzeigen und Sleepzeit
$showsleepbool = $true
$sleep = 120
#Updateschleife
while ($true) {
    for ($i = 0; $i -lt $fqdn_array.Count; $i++) {
        $Host.UI.RawUI.ForegroundColor = 'Yellow'
        $fqdn_array_item = $fqdn_array[$i]
        $updatetoken_array_item = $updatetoken_array[$i]
        $log = $logpath + "\\" + $fqdn_array_item + ".txt"
        Update $fqdn_array_item $updatetoken_array_item $log
        $Host.UI.RawUI.ForegroundColor = 'Green'
        Write-Host "------------------------------------------------------------"
    }
    Write-Host "Sleep $sleep Sek."
    if ($showsleepbool -eq $true) {
        Start-Sleep 10
        Clear-Host
        $sleepminus = $sleep - 10
        for ($i = 10; $i -lt $sleepminus ; $i++) {
            Write-Host Sleep $i/$sleep Sek.
            Start-Sleep 1
            Clear-Host
            
        }
    }
    else {
        Start-Sleep $sleep
    }
}