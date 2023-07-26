#param([Parameter(Mandatory = $true, ValueFromPipeline = $true)]
#    [string]          
#    $action, [switch]$Elevated)


function Test-Admin {
    $currentUser = New-Object Security.Principal.WindowsPrincipal $([Security.Principal.WindowsIdentity]::GetCurrent())
    $currentUser.IsInRole([Security.Principal.WindowsBuiltinRole]::Administrator)
}

if ((Test-Admin) -eq $false) {
    if ($elevated) {
        # tried to elevate, did not work, aborting
        Write-Host "you need admin privileges"
    } 
    
    exit

}

'running with full privileges'

$HostFile = 'C:\Windows\System32\drivers\etc\hosts'
 
# Create a backup copy of the Hosts file
$dateFormat = (Get-Date).ToString('dd-MM-yyyy hh-mm-ss')
$FileCopy = $HostFile + '.' + $dateFormat  + '.copy'
Copy-Item $HostFile -Destination $FileCopy
 
#Hosts to Add
$Hosts = @("www.instagram.com", "www.reddit.com", "twitter.com")
 
# Get the contents of the Hosts file
$File = Get-Content $HostFile
 
# write the Entries to hosts file, if it doesn't exist.
foreach ($HostFileEntry in $Hosts) 
{
    Write-Host "Checking existing HOST file entries for $HostFileEntry..."
     
    #Set a Flag
    $EntryExists = $false
     
    if ($File -contains "127.0.0.1 `t $HostFileEntry") 
    {
        Write-Host "Host File Entry for $HostFileEntry is already exists."
        $EntryExists = $true
    }
    #Add Entry to Host File
    if (!$EntryExists) 
    {
        Write-host "Adding Host File Entry for $HostFileEntry"
        Add-content -path $HostFile -value "127.0.0.1 `t $HostFileEntry"
        Start-Sleep 1
    }
}