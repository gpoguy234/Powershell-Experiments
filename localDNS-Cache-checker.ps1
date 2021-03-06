<#############################################################
#
#  .Synopsis
#    This script just displays local DNS cache 
#    - interesting to see how frequent it changes
#
#  .Example
#    .\localDNS-Cache-checker.ps1
#
#############################################################>

Function Get-DNSRecs(){
    $dnsrecs = @(ipconfig /displaydns)
    $IPs = $dnsrecs | select-string "(Host)" | % {$_ -replace "A (Host) Record . . . : ", " "}
    $IPs 
    }


    Write-Host "Displaying all cached DNS record IP addresses" -ForegroundColor Black -BackgroundColor White

    Get-DNSRecs