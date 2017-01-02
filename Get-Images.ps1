function RetriveImageFileData ($imagePath) {
<# 
    .DESCRIPTION
    Retrive the absolute path and date, when image was taken. 
    Return this data as a list of key/value pairs.

    .PARAMETER imagePath
    Path to look up for image files
#>
    $objShell = New-Object -ComObject Shell.Application     
    $objFolder = $objShell.namespace($imagePath)

    $folderItems = $objFolder.Items()
    $folderItemsCount = $objFolder.Items().Count

    for ($DateTakenID = 0; $DateTakenID -le 20; $DateTakenID++) {
        $detailName = $objFolder.GetDetailsOf(0, $DateTakenID)
        if ($detailName -eq "Aufnahmedatum") {
            break
        }
    }

    $localImageData = @{}
    foreach ($file in $folderItems) { 
        $localImageData.Add($file.Path, $objFolder.GetDetailsOf($file, $DateTakenID))
    }
    return $localImageData
}

$nameOfImport = Read-Host 'Name des Bildimports'
$targetPath = "C:\Users\Markus\Documents\RAW\"+ (Get-Date -Format yyyy-MM-dd) + "-" + $nameOfImport + "\"

Write-Host "Testing ", $targetPath , "...", (Test-Path $targetPath)
if ((Test-Path -Path $targetPath) -eq $true) {
    Write-Host "Name für Bildimport besteht bereits"
    return
} else {
    New-Item -ItemType Directory -Path $targetPath
}


$hashTableImages = @{}
foreach ($subPath in (Get-ChildItem -Recurse -Directory -Path "C:\Users\Markus\Sources\GitHub\auto-rename\testfiles")) {
    Write-Host "Search in", $subPath.FullName, "..."
    $collectedImageData = RetriveImageFileData($subPath.FullName)
    $hashTableImages = $hashTableImages + $collectedImageData
}

foreach ($file in $hashTableImages.Keys) {
    $fileItem = Get-ChildItem $file
    if ($fileItem.Extension -eq ".arw") {
        # has localization specific format DD.‎MM.‎YYYY ‏‎hh:mm
        $dateTimeString = [string]::new($hashTableImages.Get_Item($file))
        # Use .NET accelerator regex
        $m = [regex]::Match($dateTimeString, "([0-9]{2}).*([0-9]{2}).*([0-9]{4}).*([0-9]{2}).*([0-9]{2})")
        $year  = $m.Groups[3].Captures.Value
        $month = $m.Groups[2].Captures.Value
        $day   = $m.Groups[1].Captures.Value
        $hhmm  = $m.Groups[4].Captures.Value + $m.Groups[5].Captures.Value
        $outstring = [string]::Concat($year, "-", $month, "-", $day, "-", $hhmm, "-") 
        Copy-Item -Path $file -Destination ($targetPath + $outstring + $fileItem.BaseName + $fileItem.Extension)
        Write-Host "Kopiere", $file, "..."
    }
}

Pause
