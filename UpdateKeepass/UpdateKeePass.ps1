# Initialisierung
$tempdir = [System.IO.Path]::GetTempPath()
$global:zippath=$tempdir+"ziptemp"

#Admincheck 14.09.2022
If (-NOT ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole(`

    [Security.Principal.WindowsBuiltInRole] “Administrator”))

{

    Write-Warning “You do not have Administrator rights to run this script!`nPlease re-run this script as an Administrator!”
    Read-Host "Press Enter to continue..."

    Break

}


# TLS >=1.1 erzwingen
$AllProtocols = [System.Net.SecurityProtocolType]'Tls11,Tls12'
[System.Net.ServicePointManager]::SecurityProtocol = $AllProtocols


#FTP
$server="https://sourceforge.net/projects/keepass/files/latest/download"


function zipexpand($zipfile) {
    
    $test=Test-Path -Path $zippath
    if ($test -eq $False){
        New-Item -ItemType Directory -Force -Path $zippath
    } 
    try {
        Expand-Archive -LiteralPath $zipfile -DestinationPath $zippath -Force   
        return $zippath.ToString()
    }
    catch {
        return $null
        
    }
        
}


function download($url) {
    
    $exename = $url.Substring($url.LastIndexOf("/")+1)
    $localfile=$tempdir+$exename
    Invoke-WebRequest -UserAgent "Wget" -Uri $url -OutFile $localfile
    #Invoke-WebRequest -UserAgent "Wget" -Uri https://sourceforge.net/projects/keepass/files/latest/download -OutFile $env:USERPROFILE'\Downloads\KeePass2-Latest.exe'


    return $localfile
}


# EIgentliches Skript
Write-Output ""
Write-Output "Installiere Keepass"
Write-Output "Bitte warten..."

Stop-Process -Name "keepass" -erroraction silentlycontinue

# Download KeePass
$localfile=download -url $server"/keepass/KeePassSetup.exe"
$myprocess= Start-Process $localfile -PassThru -ArgumentList "/VERYSILENT"
$myprocess.WaitForExit() 

Remove-Item $localfile




# Download Plugins
$localfile=download -url $server"/keepass/KeePassRPC.plgx"

if (Test-Path -path ${env:ProgramFiles(x86)}"\KeePass Password Safe 2\Plugins") {
    Copy-Item $localfile ${env:ProgramFiles(x86)}"\KeePass Password Safe 2\Plugins"
}
if (Test-Path -path ${env:ProgramFiles}"\KeePass Password Safe 2\Plugins") {
    Copy-Item $localfile ${env:ProgramFiles}"\KeePass Password Safe 2\Plugins"
}

Remove-Item $localfile
	
<# $localfile=download -url $server"/keepass/KeeAutoExec.plgx"
Copy-Item $localfile ${env:ProgramFiles(x86)}"\KeePass Password Safe 2\Plugins"
Remove-Item $localfile

$localfile=download -url $server"/keepass/KeeAutoExec.dll"
Copy-Item $localfile ${env:ProgramFiles(x86)}"\KeePass Password Safe 2\Plugins"
Remove-Item $localfile

# Sprache
$localfile=download -url $server"/keepass/German.lngx"
Copy-Item $localfile ${env:ProgramFiles(x86)}"\KeePass Password Safe 2\Languages"
Remove-Item $localfile
 #>
write-output "Done...."
	
