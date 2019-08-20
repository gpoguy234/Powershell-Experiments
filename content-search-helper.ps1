<#
#    Author: Matt Elliott
#    Date:   Aug 20, 2019
#    Description:  Use this script to generate content search criteria for complex email purges
#                  Useful for phishing attacks from a dynamic list of senders.
#
#>

$csvFile = Read-host "Enter the full path to the CSV message trace file (i.e. C:\test\47.43.20..x.csv)"

if (!(test-path $csvFile)){
$csvFile = Read-host "File does not exist - Enter the full path to the CSV message trace file (i.e. C:\test\47.43.20..x.csv) or ctrl+C to cancel "
}

$csvData = import-csv $csvFile

Foreach($obj in $csvData){

$Sender = $obj.SenderAddress
$Subject = $obj.Subject

$string = "(From:"+$Sender+") AND (Subject:'"+$Subject+"')"

Write-Output $string
}
