# Funktion zur Änderung des Dateidatums und EXIF-Daten
function Change-FileDateAndExif {
    param (
        [string]$path
    )

    # Durchlaufen aller Dateien im Verzeichnis
    Get-ChildItem -Path $path -Recurse | ForEach-Object {
        $file = $_
        if ($file.Extension -match '\.(gif|png|jpg|jpeg|tiff|mp4|avi|mov|flv)$') {
            $imageFilePath = $file.FullName
            # $jsonFileName = $file.Name -replace '-editado', '' -replace $file.Extension, '.json'
            $jsonFileName = $file.Name+'.json' -replace '-editado', '' 
            $jsonFilePath = Join-Path -Path $file.DirectoryName -ChildPath $jsonFileName
            try {
                $jsonContent = Get-Content -Path $jsonFilePath -Raw | ConvertFrom-Json
                if ($jsonContent.photoTakenTime -ne $null) {

                    
                    
                    $dateTime = (Get-Date "1970-01-01").AddSeconds($jsonContent.photoTakenTime.timestamp)
                    

                    $dateTimeOriginal = [datetime]::FromFileTime($jsonContent.photoTakenTime.timestamp)
                    
                    
                    # Datum in den EXIF-Daten des Fotos ändern
                    # if ($file.Extension -match '\.(png|jpg|jpeg|tiff)$') {
                    #     $image = [System.Drawing.Image]::FromFile($imageFilePath)
                    #     $exif = New-Object -TypeName System.Drawing.Imaging.PropertyItem
                    #     $exif.Id = 0x9003 # Exif-Tag für Datum/Uhrzeit des Originals
                    #     $exif.Type = 2 # Datentyp ASCII
                    #     $exif.Value = [System.Text.Encoding]::ASCII.GetBytes($dateTimeOriginal.ToString('yyyy:MM:dd HH:mm:ss'))
                    #     $image.SetPropertyItem($exif)
                    #     $image.Save($imageFilePath)
                    # }

                    #$timestamp = [long]($dateTimeOriginal.ToUniversalTime() - (Get-Date "1970-01-01")).TotalSeconds
                      
                    $file.LastWriteTime = $datetime
                    $file.CreationTime = $datetime
                    $file.LastAccessTime = $datetime
                    
                    #$jsonFile = Get-Item -Path $jsonFilePath
                    #$jsonFile.LastWriteTime = $dateTimeOriginal
                    #$jsonFile.CreationTime = $dateTimeOriginal
                    #$jsonFile.LastAccessTime = $dateTimeOriginal
                }
                else {
                    Write-Host "Fehler beim Verarbeiten der Datei $imageFilePath Datum nicht gefunden"
                }
            }
            catch {
                Write-Host "!!!Fehler beim Verarbeiten der Datei $imageFilePath $_"
            }
        }
    }
}

# Hauptprogramm
if ($args.Count -ne 1) {
    Change-FileDateAndExif -Path "."
}
else {
    $directoryPath = $args[0]
    Change-FileDateAndExif -Path $directoryPath
}