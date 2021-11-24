############################################################################################################
# Title:    get-eventLogs.ps1
# Description: use this script to obatin event logs from the local computer
# Author:   Matt Elliott
# Date:     Oct 06, 2021
# Modified: Nov 23, 2021 - added additional log collection and check for c:\temp folder
############################################################################################################

# Self-elevate the script if required
if (-Not ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] 'Administrator')) {
 if ([int](Get-CimInstance -Class Win32_OperatingSystem | Select-Object -ExpandProperty BuildNumber) -ge 6000) {
  $CommandLine = "-File `"" + $MyInvocation.MyCommand.Path + "`" " + $MyInvocation.UnboundArguments
  Start-Process -FilePath PowerShell.exe -Verb Runas -ArgumentList $CommandLine
  Exit
 }
}
try {
    #check if c:\temp exists - create if not
    if(!(Test-Path C:\temp)){ mkdir c:\temp}
    #Get-EventLog -LogName Application -ComputerName localhost 
    $logsToGet = @("Application","Security","System","Windows PowerShell") 
    $computer = $ENV:COMPUTERNAME
    $path = "c:\temp"
    cd $path
    
    mkdir $computer
    Write-Host "Exporting logs from $computer"
    Foreach ($log in $logsToGet) {
    wevtutil epl $log "$path\$($computer)\$($computer)_($log).evtx" /remote:$computer /overwrite:true
}
# run through again with any logs with a / in the name since we also want to collect "Microsoft-Windows-PowerShell/Operational","Microsoft-Windows-Sysmon/Operational")
    $logsToGet2 = @("Microsoft-Windows-PowerShell/Operational","Microsoft-Windows-Sysmon/Operational","Microsoft-Windows-WinRM/Operational") 
    Write-Host "Exporting MORE logs from $computer"
    Foreach ($log in $logsToGet2) {
    [string]$logname = $log
    $logname = $logname.Replace("/","-")
    wevtutil epl $log "$path\$($computer)\$($computer)_($logname).evtx" /remote:$computer /overwrite:true
}
    write-host "file saved to $path\$($computer)\ " -BackgroundColor Green -ForegroundColor Black
    write-host "Make sure to backup to secure location and delete from machine asap" -BackgroundColor Red -ForegroundColor yellow
}
catch{
    error
    write-host "failed to perform command" -BackgroundColor Red -ForegroundColor yellow
}
read-host "press any key to exit"
