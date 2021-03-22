Get-WinEvent -LogName OpenSSH/Operational -MaxEvents 10000 | Where { $_.Message -match "Accepted|Failed|Starting" } | fl -Property TimeCreated,Message

Get-WinEvent -LogName Application -MaxEvents 10000 | Where { $_.Message -match "fail" } | fl -Property TimeCreated,Message

