<################################################################
#
#    Requirements: .\Address-list-FG.csv
#
#    Usage:  .\Remove-FG-Addr-v0.1.ps1 | Out-File .\FortiGate-Address-config-UNDO.txt
#
################################################################>

#get address list
$AddrList = @(Import-Csv .\Address-list-FG.csv)


$DDAddrList = @($AddrList | sort AddrIP,AddrName –Unique)

# show columns (for testing)
#$AddrList | gm

#remove address groups
write-output "config firewall addrgrp"
$GrpAddrList = @($AddrList | Group-Object -Property AddressGrp -AsHashTable -AsString)
$Groups = @($AddrList | sort AddressGrp –Unique)
foreach ($thing in $groups){
 if($thing.AddressGrp -ne ""){
     Write-Output " delete ""$($thing.AddressGrp)""";
 }
}
Write-Output "end"

#remove address objects 
Write-Output "config firewall address"
foreach ($obj in $DDAddrList){
    if ($($obj.AddrNAme) -ne ""){
        Write-Output " delete $($obj.AddrName)";
    }
 }
 Write-Output "end"