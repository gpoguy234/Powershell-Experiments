$prefix = Read-Host "enter class c subnet prefix (i.e. 192.168.1.)"
$x = (2..254)
$StartD = (get-date).AddDays(-9).toString("MM/dd/yyy")
$EndD = (get-date).AddDays(1).toString("MM/dd/yyy")

foreach($item in $x) {
	$ip = $prefix+$item;
	Get-MessageTrace -FromIP $ip -StartDate $StartD -EndDate $EndD | select -Property Received, SenderAddress, RecipientAddress, subject, status | Export-Csv -NoTypeInformation -Append -path $prefix".x.csv"
}