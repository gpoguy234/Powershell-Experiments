Get-WinEvent -LogName OpenSSH/Operational -MaxEvents 10000 | Where { $_.Message -match "Accepted|Failed|Starting" } | fl -Property TimeCreated,Message

Get-WinEvent -LogName Application -MaxEvents 10000 | Where { $_.Message -match "fail" } | fl -Property TimeCreated,Message

Get-WinEvent -LogName Security -MaxEvents 10000 | Where { $_.Id -match "4624|4625|4627|4634|4648|4672" } | fl -Property TimeCreated,Message

Get-WinEvent -LogName Security -MaxEvents 10000 | Where { $_.Id -match "4625" } | fl -Property TimeCreated,Message

Get-WinEvent -path <pathtofile>\security.evtx -MaxEvents 10000 | Where { $_.Id -match "4624|4625|4627|4634|4648|4672" } | fl -Property TimeCreated,Message
