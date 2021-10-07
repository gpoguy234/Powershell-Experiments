<#
# Title: printNightmareHangover.ps1
# Author: Matt Elliott
# Date:   Sept 17, 2021
# Notes: troubleshoot printing issues for #printnightmare, run as administrator to execute this on Windows 10
# Updated: Sept 22, 2021 - added admin check
# 
#>
#run this to toggle print spooler service
#check if admin
Write-Host "Checking for elevated permissions..."
if (-NOT ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator")) {
    Write-Warning "Insufficient permissions to run this script. Open the PowerShell console as an administrator and run this script again."
    Break}
else {Write-Host "Code is running as administrator — go on executing the script..." -ForegroundColor Green}

function Toggle-Spooler(){
    $Status = (Get-Service -Name Spooler).Status
    if($Status -eq 'Running'){Stop-Service -Name Spooler}

    if($Status -eq 'Stopped'){Start-Service -Name Spooler}
    $NewStatus = (Get-Service -Name Spooler).Status
    if($NewStatus -eq 'Running'){write-host "Remeber to run again to stop after you are done printing" -ForegroundColor Red}

    if($NewStatus -eq 'Stopped'){write-host "You are no longer vulnerable to printnightmare through print spooler" -ForegroundColor Green}
    Read-host "Print Spooler is $NewStatus" Press Enter to exit
}

toggle-spooler
#Start-Process powershell toggle-spooler -runas