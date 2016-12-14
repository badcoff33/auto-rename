# THINGS TO do 
# +++ DONE Avoid multiple renames (if file name with new format exists, skip file)
# +++ OPEN something like --dry-run
# +++ OPEN How to handle xmp or dop files?

$array = @(".arw",".jpg",".mp4")

Add-Type -AssemblyName System.Windows.Forms
$FolderBrowser = New-Object System.Windows.Forms.FolderBrowserDialog -Property @{
    ShowNewFolderButton = $false
}
[void]$FolderBrowser.ShowDialog() 
$working_dir = $FolderBrowser.SelectedPath

#if ((Test-Path -Path $working_dir) -eq $true) {
if (!($working_dir -eq $null)) {
  foreach ($extension in $array) {
    foreach ($candidate in Get-ChildItem ($working_dir + "\DSC*" + $extension)) {
      $original_name = $candidate.BaseName
      $date = (Get-ChildItem $candidate).LastWriteTime   #CreationTime
      $created_date = $date.Year.ToString("0000") + "-" + $date.Month.ToString("00") + "-" + ($date.Day).ToString("00")
      $created_time = $date.Hour.ToString("00") + $date.Minute.ToString("00") + $date.Second.ToString("00")
      $new_name = $working_dir + "\" + $created_date + "-" + $created_time + "-" + $original_name + $extension 
      Move-Item -Path $candidate -Destination $new_name
    }
  }
}
