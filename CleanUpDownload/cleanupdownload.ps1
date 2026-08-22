# Download Cleanup
# Marc Lange 14.03.2023
# Modified 26.07.2023
# 21.11.2023 zusätzliche Extensions



$downdir = [environment]::getfolderpath("Userprofile") + "\Downloads" 


$filetypes = @{}
$filetypes.add( "pdf", "\Archiv\PDF" )
$filetypes.add( "pptx", "\Archiv\Office\PowerPoint" )
$filetypes.add( "ppt", "\Archiv\Office\PowerPoint" )
$filetypes.add( "docx", "\Archiv\Office\Word" )
$filetypes.add( "doc", "\Archiv\Office\Word" )
$filetypes.add( "xlsx", "\Archiv\Office\Excel" )
$filetypes.add( "xls", "\Archiv\Office\Excel" )
$filetypes.add( "zip", "\Archiv\ZIP" )
$filetypes.add( "png", "\Archiv\Media" )
$filetypes.add( "jpg", "\Archiv\Media" )
$filetypes.add( "jpeg", "\Archiv\Media" )
$filetypes.add( "avif", "\Archiv\Media" )
$filetypes.add( "webp", "\Archiv\Media" )
$filetypes.add( "webm", "\Archiv\Media" )
$filetypes.add( "tif", "\Archiv\Media" )
$filetypes.add( "jfif", "\Archiv\Media" )
$filetypes.add( "mp4", "\Archiv\Media" )
$filetypes.add( "exe", "\Archiv\Sonstiges" )
$filetypes.add( "csv", "\Archiv\Sonstiges" )
$filetypes.add( "html", "\Archiv\Sonstiges" )
$filetypes.add( "htm", "\Archiv\Sonstiges" )
$filetypes.add( "eml", "\Archiv\EMail" )
$filetypes.add( "msg", "\Archiv\EMail" )
$filetypes.add( "stl", "\Archiv\3Dprint" )
$filetypes.add( "3mf", "\Archiv\3Dprint" )
$filetypes.add( "7z", "\Archiv\ZIP" )


$myerror = $false

foreach ($key in $filetypes.keys) {
    
    $ftype = "*." + $key
    $files = Get-ChildItem -Path $downdir $ftype

    foreach ($file in $files) {

        $lastWrite = (get-item $downdir\$file).LastWriteTime
        $timespan = new-timespan -days 30

        try {
            $doit = ((get-date) - $lastWrite) -gt $timespan     
        }
        catch {
            $doit = $false
            $myerror = $true
            write-host $file -ForegroundColor red
        }


        
        if ($doit) {
                        
            $destdir = $downdir + $filetypes[$key]
            if (!(Test-Path -PathType Container $destdir)) {
                New-Item -ItemType Directory -Path $destdir
            }

            # Prüfen, ob Datei vorhanden
            $testfile = $destdir + "\" + $file 
            if (Test-Path $testfile -PathType Leaf) {
                # Umbenennen
                $timestamp = get-date -format "yyyyMMddHHmmss"

                $newfile = $file.basename + "_" + $timestamp + $file.Extension
                Rename-Item -Path $downdir\$file -NewName $downdir\$newfile
                $file = $file.basename + "_" + $timestamp + $file.Extension
            }
                
            Move-Item $downdir\$file $destdir #-WhatIf
            write-host "Archiviere: "  $file

        }
        

    }
      
}


if ($myerror) {
    [console]::beep(500,200)
    [console]::beep(400,200)
    Read-Host "Fehler beim Verschieben. Bitte Enter drücken"
}


