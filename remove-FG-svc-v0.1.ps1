<################################################################
#
#    Requirements: .\Service-list-FG.csv
#
#    Usage: .\remove-FG-svc-v0.1.ps1 | Out-File .\FortiGate-Service-Unconfig.txt
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
        Write-Output "delete $($obj.service)";

    }
 }
 Write-Output "end"

#create address groups
write-output "config firewall service group"
$GrpsvcList = @($SVCList | Group-Object -Property ServiceGrp -AsHashTable -AsString)
$Groups = @($SVCList | sort ServiceGrp –Unique)
foreach ($thing in $groups){
 if($thing.ServiceGrp -ne ""){
     Write-Output " delete ""$($thing.ServiceGrp)""";
 }
}
Write-Output "end"
