# Download Cleanup
# Marc Lange 14.03.2023



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
$filetypes.add( "mp4", "\Archiv\Media" )
$filetypes.add( "exe", "\Archiv\Sonstiges" )
$filetypes.add( "csv", "\Archiv\Sonstiges" )



foreach ($key in $filetypes.keys) {
    
    $ftype = "*." + $key
    $files = Get-ChildItem -Path $downdir $ftype

    foreach ($file in $files) {

        $lastWrite = (get-item $downdir\$file).LastWriteTime
        $timespan = new-timespan -days 30
         
        if (((get-date) - $lastWrite) -gt $timespan) {
                        
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





