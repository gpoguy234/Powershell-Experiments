#use for searching important phone numbers in common formats 
# currently assumes a Canadian or US number will be supplied
$text1 = read-host "enter phone number i.e. 12345678901:"
$regex = "^([0-9 ][ 0-9.]{10,10})$"


if($text1 -match $regex){
    Write-Host "$text1 matches, proceeding ..." -ForegroundColor Green
}else{
    Write-Host "$text1 is an invalid number format - setting to 12345678901 ... close browser try again" -ForegroundColor Red
    $text1 = "12345678901"
}

$text2 = $text1.TrimStart("1")
$urlstring = "https://www.google.ca/search?q=intext%3A%22" + $text1 + "%22+OR+intext%3A%22%2B" + $text1 + "%22+OR+intext%3A%22" + $text2 + "%22"
cmd.exe /k start msedge $urlstring
