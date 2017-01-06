# Define command line parameters
param (
    [Parameter(Mandatory=$true)][string]$paramImagePath = ".\"
)

# Test valid directory and move to working directory
if ((Test-Path -Path $paramImagePath) -eq $true) {
    $imagePath = (Get-Item -Path $paramImagePath).FullName
    Write-Host "Quellpfad", $imagePath, "gefunden."
} else {
    Write-Host "Abbruch: Quellpfad", $paramImagePath, "nicht gefunden."
    return
}

$objShell = New-Object -ComObject Shell.Application     
$objFolder = $objShell.NameSpace($imagePath)
$objFolderItems = $objFolder.Items()

for ($DateTakenID = 0; $DateTakenID -le 20; $DateTakenID++) {
    $detailName = $objFolder.GetDetailsOf(0, $DateTakenID)
    if ($detailName -eq "Aufnahmedatum") {
        break
    }
}
if ($DateTakenID -ge 20) {
    Write-Host "Abbruch: Keine Information zum Aufnahmedatum gefunden."
    return
}

$hashTableImages = @{}
foreach ($folderItem in $objFolderItems) {
    if (($folderItem.Path -match "\.arw$") -or ($folderItem.Path -match "\.jpg$")) {
        if (-not ($folderItem.Path -match "_")) {
            $hashTableImages.Add($folderItem.Path, $objFolder.GetDetailsOf($folderItem, $DateTakenID))
        }
    }
}
Write-Host $hashTableImages.Count, "Bilder mit Aufnahmedatum gefunden."

foreach ($file in $hashTableImages.Keys) {
    $fileItem = Get-ChildItem $file
    # has localization specific format DD.?MM.?YYYY ??hh:mm
    $dateTimeString = [string]::new($hashTableImages.Get_Item($file))
    # Use .NET accelerator regex
    $m = [regex]::Match($dateTimeString, "([0-9]{2}).*([0-9]{2}).*([0-9]{4}).*([0-9]{2}).*([0-9]{2})")
    $year  = $m.Groups[3].Captures.Value
    $month = $m.Groups[2].Captures.Value
    $day   = $m.Groups[1].Captures.Value
    $hhmm  = $m.Groups[4].Captures.Value + $m.Groups[5].Captures.Value
    $outstring = [string]::Concat($year, "-", $month, "-", $day, "_", $hhmm, "_",$fileItem.BaseName, $fileItem.Extension) 
    Write-Host "...", $outstring 
    Move-Item -Path $file -Destination ($imagePath + $outstring)
}
