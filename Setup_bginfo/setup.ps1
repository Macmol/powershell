 
## Variables
 
$bgInfoFolder = "C:\BgInfo"
$bgInfoFolderContent = $bgInfoFolder + "\*"
$itemType = "Directory"

$bgInfoRegPath = "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Run"
$bgInfoRegkey = "BgInfo"
$bgInfoRegType = "String"
$bgInfoRegkeyValue = "C:\BgInfo\Bginfo.exe C:\BgInfo\logon.bgi /timer:0 /nolicprompt"
$regKeyExists = (Get-Item $bgInfoRegPath -EA Ignore).Property -contains $bgInfoRegkey
$writeEmptyLine = "`n"
$writeSeperator = " - "
$time = Get-Date
$foregroundColor1 = "Yellow"
$foregroundColor2 = "Red"
 
##-------------------------------------------------------------------------------------------------------------------------------------------------------
 
 
## Create BgInfo folder on C: if not exists
 
If (!(Test-Path -Path $bgInfoFolder)){New-Item -ItemType $itemType -Force -Path $bgInfoFolder
    Write-Host ($writeEmptyLine + "# BgInfo folder created" + $writeSeperator + $time)`
    -foregroundcolor $foregroundColor1 $writeEmptyLine
 }Else{Write-Host ($writeEmptyLine + "# BgInfo folder already exists" + $writeSeperator + $time)`
    -foregroundcolor $foregroundColor2 $writeEmptyLine
    Remove-Item $bgInfoFolderContent -Force -Recurse -ErrorAction SilentlyContinue
    Write-Host ($writeEmptyLine + "# Content existing BgInfo folder deleted" + $writeSeperator + $time)`
    -foregroundcolor $foregroundColor2 $writeEmptyLine}
 
##-------------------------------------------------------------------------------------------------------------------------------------------------------

## Copy Items

Copy-Item -Path .\*.exe -Destination $bgInfoFolder -Force
Copy-Item -Path .\*.bgi -Destination $bgInfoFolder -Force
Copy-Item -Path .\*.vbs -Destination $bgInfoFolder -Force


##-------------------------------------------------------------------------------------------------------------------------------------------------------
 
## Create BgInfo Registry Key to AutoStart
 
If ($regKeyExists -eq $True){Write-Host ($writeEmptyLine + "BgInfo regkey exists, script wil go on" + $writeSeperator + $time)`
-foregroundcolor $foregroundColor2 $writeEmptyLine
}Else{
New-ItemProperty -Path $bgInfoRegPath -Name $bgInfoRegkey -PropertyType $bgInfoRegType -Value $bgInfoRegkeyValue
Write-Host ($writeEmptyLine + "# BgInfo regkey added" + $writeSeperator + $time)`
-foregroundcolor $foregroundColor1 $writeEmptyLine}
 
##-------------------------------------------------------------------------------------------------------------------------------------------------------
 
## Run BgInfo
 
C:\BgInfo\Bginfo.exe C:\BgInfo\logon.bgi /timer:0 /nolicprompt
Write-Host ($writeEmptyLine + "# BgInfo has run" + $writeSeperator + $time)`
-foregroundcolor $foregroundColor1 $writeEmptyLine
 
##-------------------------------------------------------------------------------------------------------------------------------------------------------
 
