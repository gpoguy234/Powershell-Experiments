<#
.SYNOPSIS
  Name: query-Inbox-saveFiles.ps1
  The purpose of this script is to download all .msg attachments from unread emails in a specified mailbox
  
.DESCRIPTION
  The purpose of this script is to download all .msg attachments from unread emails in a specified mailbox
    Make sure to change the inboxEmail and savePath variables and place this script in the savePath folder for best results


.PARAMETER savePath
  Specify $savePath variable (default is C:\test\msg)
  
.PARAMETER inboxEmail
  Specify $inboxEmail variable

.NOTES
    Updated:      2018-10-15 (cleanup for GIT upload)  
    Release Date: 2018-10-15
   
  Author: Matt Elliott

.EXAMPLE
  Run the query-Inbox-saveFiles.ps1 from powershell or right-click -> Run in powershell


#>


###############################Logs################################################## 
$date = get-date -format d 
$date = $date.ToString().Replace(“/”, “-”) 
$time = get-date -format t 
$time = $time.ToString().Replace(":", "-") 
$time = $time.ToString().Replace(" ", "") 
 
$log1 = ".\Logs" + "\" + "Processed_" + $date + "_.log" 
 
$logs = ".\Logs" + "\" + "Powershell" + $date + "_" + $time + "_.txt" 
 
Start-Transcript -Path $logs  
 
$date1 = get-date 

###############################Variables############################################# 
##### Change me to whatever path you want to save files - make sure to place the script in this folder too
$savePath = "C:\test\msg"
##### Change me to the target outlook mailbox address - where attachments will be downloaded from
$inboxEmail = "mailbox@company.org"

###############################Functions############################################# 


function shuffle_fileName($file){
#does message already exist with this filename - if so list last
    if (Test-Path $file){
        #file exists 
        Write-Host "$file exists!"
        #- check for multiple messages
        $searchstr = ($file.Split(".")[0])+"-*.msg";
        $list = ls $searchstr;
        if($list.count -gt 0){
            $index = $list.Count
            $filename = ($list[($index-1)]).Name
            write-host "Also messages up to $filename exists!"
            #Fix the name
            $LastTwo = $filename.Split(".")[0] #-replace '-02', '-03'
            $LastTwo = $LastTwo.Substring($LastTwo.get_Length()-2)
            $newNum = [Int]$LastTwo + 01
            $newname = $filename -replace $LastTwo , $newNum.ToString("00")
            Write-Host "saving file as $newname"
        }
        else{
            $newname = $file -replace ".msg", '-01.msg'
            Write-Host "saving file as $newname"
            #shuffle_fileName($file,$savePath)
        }
        return($newname)
    }
    else {
        # OK save original file name
        Write-Host "$file no existe!"
        return($file)
    }
}

###############################QueryMessages######################################### 
cd $savePath
$ol=New-Object -ComObject Outlook.Application
for($i=1;$i -le $ol.Session.Accounts.Count;$i++ ){
    if($ol.Session.Accounts.Item($i).DisplayName -eq $inboxEmail){
	    Write-Host $ol.Session.Accounts.Item($i).DisplayName -fore green -NoNewLine
	    $ol.Session.Accounts.Item($i).DeliveryStore.GetDefaultFolder(6).Items.Count
        $messages = $ol.Session.Accounts.Item($i).DeliveryStore.GetDefaultFolder(6).Items.Restrict('[UnRead] = True')
        foreach ($item in $messages) {
            write-host "subject: $item.TaskSubject ";
            ############################Save Messages############################### 
            $item.attachments | foreach { 
                Write-Host $_.filename 
                $attr = $_.filename 
                add-content $log1 "Attachment: $attr" 
                $a = $_.filename 
                If ($a.Contains("msg")) { 
                    $savename = shuffle_fileName($a)
                    $_.saveasfile((Join-Path $savePath $savename))
                    sleep -Seconds 1
                } 
            } 
            $item.UnRead = 'False' # set email to "read"
            $attachment = $savePath + $a 
        }
    
    }
    
}