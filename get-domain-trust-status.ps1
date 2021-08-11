#$uDomain = "testing.local"  #static domain name

#prompt for trusted domain 
$uDomain = Read-Host "Enter Remote Domain Name: (i.e. scada.local)"
#get Domain trust information
$dom = [System.DirectoryServices.ActiveDirectory.Domain]::GetCurrentDomain()

try{$status = $dom.GetSelectiveAuthenticationStatus($uDomain)}
catch {$status = $False}
if ($status -eq $True){
    Write-Host "Domain trust is in place between $dom and $uDomain"
    $dom.GetAllTrustRelationships()
}
else {
    Write-host "A domain trust relationship does not exist between $dom and $uDomain" -ForegroundColor DarkGreen
    
}