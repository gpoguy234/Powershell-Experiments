# Description: Check for new SAM vuln - fully patched windows 10/11 systems seeme to be vulnerable to allowing any user to access the SAM database
# Date: 07/19/2021

<#
C:\Users\User>icacls c:\Windows\System32\config\SAM
c:\Windows\System32\config\SAM BUILTIN\Administrators:(I)(F)
                               NT AUTHORITY\SYSTEM:(I)(F)
                               BUILTIN\Users:(I)(RX)
                               APPLICATION PACKAGE AUTHORITY\ALL APPLICATION PACKAGES:(I)(RX)
                               APPLICATION PACKAGE AUTHORITY\ALL RESTRICTED APPLICATION PACKAGES:(I)(RX)

Successfully processed 1 files; Failed processing 0 files
#>
$searchStr = [regex]::Escape("Users:(I)(RX)")

$check = icacls c:\Windows\System32\config\SAM | Out-String | Select-String -Pattern "Users" -context 1
#get-acl -path c:\Windows\System32\config\SAM -Audit

if( $check | select-string $searchStr ) {
    write-host "Looks like Users have some privs `n $check "
    }
else{
    write-host "your probably safe"
    }