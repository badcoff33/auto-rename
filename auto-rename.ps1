$array = @(".arw",".jpg",".mp4")

foreach ($extension in $array) {
  foreach ($candidate in Get-ChildItem ("*" + $extension)) {
    $original_name = $candidate.BaseName
    $date = (Get-ChildItem $candidate).CreationTime
    $created_date = $date.Year.ToString("0000") + $date.Month.ToString("00") + ($date.Day).ToString("00")
    $created_time = $date.Hour.ToString("00") + $date.Minute.ToString("00") + $date.Second.ToString("00")
    $new_name = $created_date + "_" + $created_time + "_" + $original_name + $extension 
    Write-Host "Copy-Item", $candidate, $new_name
  }
}
