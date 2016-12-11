$array = @("arw","jpg","mp4")

foreach ($i in $array) {
   Write-Host $i 
}

$number = (Get-ChildItem "*.*").Length
Write-Host $number
foreach ($i in Get-ChildItem "*.*") {
    $name = (Get-ChildItem $i).BaseName
    $date = (Get-ChildItem $i).CreationTime
    $out_date = $date.Year.ToString() + $date.Month.ToString() + $date.Day.ToString()
    $out_time = $date.Hour.ToString() + $date.Minute.ToString() + $date.Second.ToString()
    $out = $out_date + "__" + $out_time + "__" + $name 
    Write-Host $out   
}