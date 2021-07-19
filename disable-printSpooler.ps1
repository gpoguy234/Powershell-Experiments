#Windows Print Spooler Elevation of Privilege Vulnerability
#CVE-2021-34481

if((Get-Service -Name Spooler).Status -eq 'Running'){
    #If the Print Spooler is running or if the service is not disabled, follow these steps:
    #Stop and disable the Print Spooler service
    #If stopping and disabling the Print Spooler service is appropriate for your environment, run the following in Windows PowerShell:
    Stop-Service -Name Spooler -Force

    Set-Service -Name Spooler -StartupType Disabled
}
else{ write-host "already disabled - your safe!"}