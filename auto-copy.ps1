$file_extensions = @(".arw", ".jpg", ".mp4")
$look_up_dirs = @("e:\", "f:\")

Add-Type -AssemblyName System.Windows.Forms
$FolderBrowser = New-Object System.Windows.Forms.FolderBrowserDialog -Property @{
    ShowNewFolderButton = $true
}
[void]$FolderBrowser.ShowDialog() 
$destination_dir = $FolderBrowser.SelectedPath

if ($destination_dir -eq $null) {
  exit
}

foreach ($source_dir in $look_up_dirs) {
  if (Test-Path -Path $source_dir) {
    foreach ($extension in $file_extensions)  {
      Write-Host -NoNewline "Looking for", $extension, "files on path", $source_dir , ": "
      $file_matches = Get-ChildItem -Recurse -Path ($source_dir + "\DSC*" + $extension)
      Write-Host "found", $file_matches.length, "files"
      foreach ($candidate in $file_matches) {
        # Do the rename
        $original_name = $candidate.BaseName
        $date = (Get-ChildItem $candidate).LastWriteTime   #CreationTime
        $created_date = $date.Year.ToString("0000") + "-" + $date.Month.ToString("00") + "-" + ($date.Day).ToString("00")
        $created_time = $date.Hour.ToString("00") + $date.Minute.ToString("00") + $date.Second.ToString("00")
        $new_name =  $created_date + "-" + $created_time + "-" + $original_name + $extension 
        # Copy the file
        Copy-Item -Path $candidate -Destination ($destination_dir + "\" + $new_name)
      }
    }
  }
}
