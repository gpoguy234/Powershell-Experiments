<################################################################
#
#    Requirements: .\Service-list-FG.csv
#
#    Usage: .\create-FG-svc-v0.1.ps1 | Out-File .\FortiGate-Service-config.txt
#
################################################################>

#get Service list
$SVCList = @(Import-Csv .\Service-list-FG.csv)


$SVCList | gm 

#remove duplicate services from list
$DDSVCList = @($SVCList | sort service,start-port,end-port –Unique)

#Create service objects with comments
Write-Output "config firewall service custom"
foreach ($obj in $DDSVCList){
    if ($($obj.service) -ne ""){
        Write-Output "edit ""$($obj.service)""";
        Write-Output " set category $($obj.Category)";
        if ($($obj.Desc) -ne ""){
            write-output " set comment ""$($obj.Desc)""";
            write-output "next"
        }
    }
 }
 Write-Output "end"

#create address groups
write-output "config firewall service group"
$GrpsvcList = @($SVCList | Group-Object -Property ServiceGrp -AsHashTable -AsString)
$Groups = @($SVCList | sort ServiceGrp –Unique)
foreach ($thing in $groups){
 if($thing.ServiceGrp -ne ""){
     Write-Output " edit ""$($thing.ServiceGrp)""";
    #$thing2 = $thing.ServiceGrp;
    #$GroupAddrlist | ? ($_.ServiceGrp -match $GroupAddrlist.Name)# WIP - can't seem to pull values I want yet
 #if ($GrpAddrList."$($thing.ServiceGrp)" -ne ""){
    $GrpMembers = $GrpsvcList."$($thing.ServiceGrp)".Service -Join """ """
    Write-Output "  set member ""$GrpMembers"""
    write-output " next";
 }
}
Write-Output "end"
