$phoneNum = Read-Host "enter phone # (Use dashes: ie. 1-234-567-8900) "


#$URL = "http://canada411.yellowpages.ca/fs/X-XXX-XXX-XXXX?what=X-XXX-XXX-XXXX"

$URLPart1 = "http://canada411.yellowpages.ca/fs/"
$URLPart2 = $phoneNum
$URLPart3 = "?what="
$URLPart4 = $URLPart2
$URL = $URLPart1 + $URLPart2 + $URLPart3 + $URLPart4

Start-Process chrome.exe $URL