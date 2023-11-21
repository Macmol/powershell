#https://www.reddit.com/r/PowerShell/comments/qvypf7/renaming_eml_files_to_include_date_and_subject/?utm_medium=android_app&utm_source=share

Function Read-EML() {
    Param([Parameter(Position = 1)]
        [string]$FileName = "_EMPTY_")
    <#
        This neat function is based on Chris Dziemborowicz's article
        http://chris.dziemborowicz.com/blog/2013/05/11/how-to-convert-eml-files-to-html-using-powershell/
        Since my goal was not an HTML file, I skipped that part.
    #>

    $cdoMessage = $null
    if ( $FileName -ne "_EMPTY_" ) {
        $adoDbStream = New-Object -ComObject ADODB.Stream
        $adoDbStream.Open()
        $adoDbStream.LoadFromFile($FileName)
        $cdoMessage = New-Object -ComObject CDO.Message
        $cdoMessage.DataSource.OpenObject($adoDbStream, "_Stream")
    }
    return $cdoMessage
}

$SourceFolder = '<PATH To Source Files>'

$SourceFiles = Get-ChildItem -Recurse -File -Include '*.eml' -Path $SourceFolder

foreach ($File in $SourceFiles) {
    $cdoEML = Read-EML -FileName $File.FullName
    #$EMLDate = Get-Date ($EMLViewer.cdoMessage.ReceivedTime) -Format "yyyy-mm-dd.HHMM"
    $EMLDate = Get-Date ($cdoEML.ReceivedTime) -Format "yyyy-mm-dd.HHMM"
    $NewFileName = "$($File.Directory.FullName)\$EMLDate - $($cdoEML.Subject.Split([IO.Path]::GetInvalidFileNameChars()) -join '_')"
    if (Test-Path "$NewFilename.eml") {
        $FileNumber = 1
        while ( Test-Path "$NewFileName ($FileNumber).eml") {
            $FileNumber++
        }
        $NewFileName = "$NewFileName ($FileNumber)"
    }
    Rename-Item -Path $File.FullName -NewName "$NewFileName.eml"
}