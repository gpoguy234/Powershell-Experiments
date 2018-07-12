<################################################################
#
#    Requirements: .\Address-list-FG.csv
#
#    Usage: .\create-FG-Addr-v0.1.ps1 | Out-File .\FortiGate-Address-config.txt
#
################################################################>

#get address list
$AddrList = @(Import-Csv .\Address-list-FG.csv)


$DDAddrList = @($AddrList | sort AddrIP,AddrName –Unique)

# show columns (for testing)
#$AddrList | gm

#Create address objects with comments
Write-Output "config firewall address"
foreach ($obj in $DDAddrList){
    if ($($obj.AddrName) -ne ""){
        Write-Output "edit $($obj.AddrName)";
        Write-Output " set subnet $($obj.AddrIP)";
        if ($($obj.Desc) -ne ""){
            write-output " set comment ""$($obj.Desc)""";
        }
        write-output "next"
    }
 }
 Write-Output "end"

#create address groups
write-output "config firewall addrgrp"
$GrpAddrList = @($AddrList | Group-Object -Property AddressGrp -AsHashTable -AsString)
$Groups = @($AddrList | sort AddressGrp –Unique)
foreach ($thing in $groups){
 if($thing.AddressGrp -ne ""){
     Write-Output " edit ""$($thing.AddressGrp)""";
    #$thing2 = $thing.AddressGrp;
    #$GroupAddrlist | ? ($_.AddressGrp -match $GroupAddrlist.Name)# WIP - can't seem to pull values I want yet
 #if ($GrpAddrList."$($thing.AddressGrp)" -ne ""){
    $GrpMembers = $GrpAddrList."$($thing.AddressGrp)".AddrName -Join """ """
    Write-Output "  set member ""$GrpMembers"""
 }
 write-output " next";
}
Write-Output "end"
