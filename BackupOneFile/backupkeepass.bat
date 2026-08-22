
@echo off
setlocal

REM PowerShell-Script befindet sich im gleichen Verzeichnis wie diese Batchdatei
set "PS_SCRIPT=%~dp0backuponefile.ps1"

REM Vollständige Pfade
set "SOURCE_FILE=C:\Users\macmo\OneDrive\PortableApps\Keepass2\Databases\Database.kdbx"
set "BACKUP_DIR=C:\Users\macmo\OneDrive\PortableApps\Keepass2\Backup Databases"

powershell.exe -NoProfile -ExecutionPolicy Bypass -File "%PS_SCRIPT%" -SourceFile "%SOURCE_FILE%" -BackupDirectory "%BACKUP_DIR%"

if errorlevel 1 (
    echo.
    echo Fehler beim Ausfuehren des Backup-Scripts.
    pause
    exit /b 1
)

endlocal
