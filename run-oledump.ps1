<#

.SYNOPSIS
    run-oledump is a tool which uses OLEDUMP.PY to inspect email messages reported as potential phishing messages.

.DESCRIPTION
    run-oledump makes use of Didier Stevens suite of tools to inspect email messages.  The intent was to quickly assess which messages require further inspection.   
    All reported messages need to be copied to the system directory C:\test\oledump_V0_0_33.   When messages are no longer needed they can be moved to C:\test\oledump_V0_0_33\files or deleted


.EXAMPLE
	powershell.exe -executionpolicy bypass .\run-oledump.ps1 
    
    Standard report includes filename, sender, receiver (blank if multiple), message body, and attachment details
    output will sent to the screen
    
.EXAMPLE
	powershell.exe -executionpolicy bypass .\run-oledump.ps1 -Report -NewFile "inspect-emails-03-15-2018.txt"
    
    Standard report includes filename, sender, receiver (blank if multiple), message body, and attachment details
    Output will be sent to the filename specified. Will delete any existing files with same name

.EXAMPLE
	powershell.exe -executionpolicy bypass .\run-oledump.ps1 -Report -Brief -NewFile "inspect-emails-03-15-2018.txt" 
    
    Basic report includes filename, sender, receiver (blank if multiple),and attachment details
    Output will be sent to the filename specified. Will delete any existing files with same name
      
.AUTHOR
    Matt Elliott

.REVISION
    v5.0
    Updates to operations - basic URL filtering now dumped to seperate file (i.e. URLs-inspect-emails-03-15-2018.txt)

.Date
    March 20, 2018
#>
#working - simple PoC
#ls *.msg | % {Write-Output "File: $_.Name" ; C:\Python27\python.exe oledump.py -p plugin_msg -q $_.Name | find /V " ?"}

# define switches
[cmdletbinding()]
param([string]$NewFile, [switch]$Report, [switch]$Brief, [string]$Homepath = "C:\test\run-oledump\V0_0_33\", [switch]$ListUnicode) # Change $Homepath as needed for oledump version upgrades

#variables
$env:PATHEXT += ";.py"
$ReportsFolder = "Reports\"
$urlID = "URLs-"
$startPath = $Homepath  #define starting location and where messages will be found
$i = 1 

function get-sender ($obj) {
    $messageSenderID = @($obj | Select-String "Sender email")#get sender address location
    $messagesenderParts = @($messageSenderID -split ':') #format sender address location info
    $messageSenderStream = [int]$messagesenderParts[0] # get sender address identifier - set to integer
    $messageSender = C:\Python27\python.exe oledump.py -s $messageSenderStream -t utf8 $message.Name #get sender address
    return $messageSender
}
function get-receiver ($obj) {
    $messageRecvrID = @($obj | Select-String "7-bit email");#get receiver address location
    $messageRecvrParts = @($messageRecvrID -split ':'); #format receiver address location info
    $messageRecvrStream = [int]$messageRecvrParts[0]; # get receiver address identifier - set to integer
    $messageRecvr = C:\Python27\python.exe oledump.py -s $messageRecvrStream -t utf8 $message.Name; #get receiver address
    return $messageRecvr
}
function get-message ($obj) {
    $messageBody = @($obj | Select-String "UNI Message Body") #get message body location
    $messagebodyParts = @($messageBody -split ':') #format message body location info
    $messageBodyStream = [int]$messagebodyParts[0] # get message body identifier - set to integer
    $messageContent = @(C:\Python27\python.exe oledump.py -s $messageBodyStream -d $message.Name) #get message body content
    return $messageContent
}
function get-attachmentNames ($obj) {
    $attachments = @($obj | Select-String "UNI Attach long filename")  #look for attachment filenames
    write-output "attachment filename references:"
    #Display attachment names or indicate no message attachments
    if ($attachments.Count -ge 1) {Write-output "there are attachments - listing attachment filename stream ID's: " ; foreach ($item in $attachments) {[int]$a,$b,$c = $item -Split ":" ; $name = C:\Python27\python.exe oledump.py -s $a -t utf16 $message.Name ; Write-output $a $name }} else {Write-output ""}
}
function get-attachments ($obj) {
    $attachmentsData = @($obj | Select-String "Attachment data")  #look for attachments
    write-output "attachment data references:"
    #List attachments and save copy to local folder (name based on "subject-streamID.file" naming convention
    if ($attachmentsData.Count -ge 1) {Write-output "there are attachments - listing attachment data stream ID's: " ; foreach ($item in $attachmentsData) {[int]$d,$e,$f = $item -Split ":" ; <#C:\Python27\python.exe oledump.py -s $d -d $message.Name | out-file ($($message.Name)+"-"+$d+".file")#> ; write-output $d }} else {Write-output ""}
}

<#function get-UNI ($obj) {
    $AllUNI = @($obj | Select-String " UNI")#get all UNICODE stream locations
    <#$ALLUNIIDs = @($ALLUNI -split ':') #format sender address location info
    $ALLUNIStream = [int]$ALLUNIIDs[0] # get sender address identifier - set to integer
    $messageUNIIDs = C:\Python27\python.exe oledump.py -s $ALLUNIStream -t utf8 $message.Name #get sender address#>
  <#  return $ALLUNI
}#>

function get-URLs ($input) {
    #$input | select-string "\<*\>"
    $input | select-string "/"
    #$input | select-string "h t t p"
    #Add more filters as needed
}


### MAIN BODY ###
#switch to defined path
cd $startPath
$messages = ls *.msg #enumerate messsage files

if ($Report -and (!$Brief)) {
    if (Test-Path $NewFile) {Remove-Item $NewFile -force}
    $filename = $NewFile
    #find msg files, enumerate streams, look for interesting stuff output to a file (Full Report)
    foreach ($message in $messages) {
        $attachments = 0 #set attachments to Zero
        "$i --> Filename: $message.Name " | Out-File -FilePath $filename -Append #display message name
        $obj = @(C:\Python27\python.exe oledump.py -p plugin_msg -q $message.Name) #analyze msfg file step #1
            if ($ListUnicode) {
                get-UNI($obj) | Out-File -FilePath $filename -Append;
            }
        "--------Sender----------" | Out-File -FilePath $filename -Append;
         get-sender ($obj) | Out-File  -FilePath $filename -Append;
        "----------Receiver------------" | Out-File -FilePath $filename -Append; 
         get-receiver($obj) | Out-File  -FilePath $filename -Append;
        "---------start of message body----------------" | Out-File  -FilePath $filename -Append;
         #get-message($obj) | Out-File  -FilePath $filename -Append;
         $msgBody = get-message($obj); 
         $msgBody | Out-File  -FilePath $filename -Append ;
        "----------end of message body-----------------"  | Out-File  -FilePath $filename -Append ; 
        "----------Links----------------"  | Out-File  -FilePath $filename -Append ; 
         $msgBody | get-URLs | Out-File  -FilePath $filename -Append ;
        "----------Attachments----------"  | Out-File  -FilePath $filename -Append ; 
        get-attachmentNames($obj) | Out-File  -FilePath $filename -Append;
        get-attachments($obj) | Out-File  -FilePath $filename -Append;
        
        "-----------End of message--------------------"  | Out-File  -FilePath $filename -Append
        $i++ 
        }
    }
    if ($Report -and $Brief) {
    if (Test-Path $NewFile) {Remove-Item $NewFile -force}
    $filename = $NewFile
    #find msg files, enumerate streams, look for interesting stuff output to a file (Summary)
    foreach ($message in $messages) {
        $attachments = 0 #set attachments to Zero
        "$i --> Filename: $message.Name " | Out-File -FilePath $filename -Append #display message name
        $obj = @(C:\Python27\python.exe oledump.py -p plugin_msg -q $message.Name) #analyze msfg file step #1

        "--------Sender----------" | Out-File -FilePath $filename -Append;
         get-sender ($obj) | Out-File  -FilePath $filename -Append;
        "----------Receiver------------" | Out-File -FilePath $filename -Append; 
         get-receiver($obj) | Out-File  -FilePath $filename -Append;

        "----------Links----------------"  | Out-File  -FilePath $filename -Append ; 
         $msgBody = get-message($obj); 
         $msgBody | get-URLs | Out-File  -FilePath $filename -Append ;
        "----------Attachments----------"  | Out-File  -FilePath $filename -Append ; 
        
        get-attachmentNames($obj) | Out-File  -FilePath $filename -Append;
        get-attachments($obj) | Out-File  -FilePath $filename -Append;
        
        "-----------End of message--------------------"  | Out-File  -FilePath $filename -Append
        $i++ 
        }
    }
    if ((!$Report) -and (!$Brief)) {

    #find msg files, enumerate streams, look for interesting stuff output to the desk (Full Results)
    foreach ($message in $messages) {
        $attachments = 0 #set attachments to Zero
        Write-Output "$i --> Filename: $message.Name " #display message name
        $obj = @(C:\Python27\python.exe oledump.py -p plugin_msg -q $message.Name) #analyze msfg file step #1

        write-output "--------Sender----------" ; 
         get-sender ($obj);
        write-output "----------Receiver------------" ; 
         get-receiver($obj);
        write-host "---------start of message body----------------" ;
         $msgBody = get-message($obj); 
         write-host $msgBody ;
        write-host "----------end of message body-----------------" ; 
        write-host "----------Links----------------";
        write-host get-URLs($msgBody);
        write-host "----------Attachments----------";
        get-attachmentNames($obj);
        get-attachments($obj);
        write-output "-----------End of message--------------------";
        $i++ 
        }
    }
    if ((!$Report) -and $Brief) {

    #find msg files, enumerate streams, look for interesting stuff - output to the desk (Summary)
    foreach ($message in $messages) {
        $attachments = 0 #set attachments to Zero
        Write-Output "$i --> Filename: $message.Name " #display message name
        $obj = @(C:\Python27\python.exe oledump.py -p plugin_msg -q $message.Name) #analyze msfg file step #1

        write-output "--------Sender----------" ; 
         get-sender ($obj);
        write-output "----------Receiver------------" ; 
         get-receiver($obj);
        write-host "----------Links----------------";
         $msgBody = get-message($obj);
        write-host get-URLs($msgBody);
        write-host "----------Attachments----------" ; 
        get-attachmentNames($obj);
        get-attachments($obj);        
        write-output "-----------End of message--------------------";
        $i++ 
        }
    }
    
    else {write-output "complete" ; if($filename) {notepad $filename}}
