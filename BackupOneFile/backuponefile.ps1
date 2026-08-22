<#
.SYNOPSIS
    Prüft eine Datei auf Änderungen und erstellt bei Änderung ein Backup.

.PARAMETER SourceFile
    Die zu überwachende Datei.

.PARAMETER BackupDirectory
    Das Zielverzeichnis für die Backups.

.EXAMPLE
    .\Backup-ChangedFile.ps1 -SourceFile "C:\Daten\config.xml" -BackupDirectory "D:\Backups"
#>

param(
    [Parameter(Mandatory = $true)]
    [string]$SourceFile,

    [Parameter(Mandatory = $true)]
    [string]$BackupDirectory
)

# Prüfen, ob die Quelldatei existiert
if (-not (Test-Path -LiteralPath $SourceFile -PathType Leaf)) {
    Write-Error "Die Quelldatei existiert nicht: $SourceFile"
    exit 1
}

# Backup-Verzeichnis erstellen, falls es noch nicht existiert
if (-not (Test-Path -LiteralPath $BackupDirectory)) {
    New-Item -ItemType Directory -Path $BackupDirectory -Force | Out-Null
}

# Absoluten Pfad der Quelldatei ermitteln
$SourceFile = (Resolve-Path -LiteralPath $SourceFile).Path

# Dateiname und Erweiterung aufteilen
$FileName = [System.IO.Path]::GetFileNameWithoutExtension($SourceFile)
$Extension = [System.IO.Path]::GetExtension($SourceFile)

# Hash-Datei im Backup-Verzeichnis
$HashFile = Join-Path $BackupDirectory "$FileName.last.hash"

# Aktuellen SHA256-Hash berechnen
$CurrentHash = (Get-FileHash -LiteralPath $SourceFile -Algorithm SHA256).Hash

# Prüfen, ob bereits ein vorheriger Hash existiert
$HasChanged = $true

if (Test-Path -LiteralPath $HashFile) {
    $PreviousHash = Get-Content -LiteralPath $HashFile -Raw
    $PreviousHash = $PreviousHash.Trim()

    if ($CurrentHash -eq $PreviousHash) {
        $HasChanged = $false
    }
}

if ($HasChanged) {
    # Datum für den Backup-Dateinamen
    $Date = Get-Date -Format "yyyy-MM-dd"

    # Backup-Dateiname
    $BackupFileName = "$FileName`_$Date$Extension"
    $BackupFile = Join-Path $BackupDirectory $BackupFileName

    # Falls am gleichen Tag bereits ein Backup existiert,
    # wird zusätzlich die Uhrzeit verwendet
    if (Test-Path -LiteralPath $BackupFile) {
        $DateTime = Get-Date -Format "yyyy-MM-dd_HH-mm-ss"
        $BackupFileName = "$FileName`_$DateTime$Extension"
        $BackupFile = Join-Path $BackupDirectory $BackupFileName
    }

    # Backup erstellen
    Copy-Item -LiteralPath $SourceFile -Destination $BackupFile -Force

    # Neuen Hash speichern
    Set-Content -LiteralPath $HashFile -Value $CurrentHash -NoNewline

    Write-Host "Datei wurde ver�ndert. Backup erstellt:"
    Write-Host $BackupFile
}
else {
    Write-Host "Keine �nderung festgestellt. Kein Backup erforderlich."
}