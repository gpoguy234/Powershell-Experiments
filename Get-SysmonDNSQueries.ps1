﻿get-winevent -LogName Microsoft-Windows-Sysmon/Operational -FilterXPath 'Event[System[EventRecordID > 0 and EventID = 22]] and Event[EventData [Data[@Name="QueryStatus"] = 0]]' | %{([xml]$_.ToXml())} | %{ ("{0},{1}" -f $_.Event.System.Execution.ProcessID, ($_.Event.EventData.Data | Where-Object {$_.Name -eq 'QueryName' -or $_.Name -eq 'QueryResults' -or $_.Name -eq 'Image' -or $_.Name -eq 'ProcessID' -or $_.Name -eq 'UtcTime'}  | Select-Object '#text' | ConvertTo-Csv -NoTypeInformation | Select -Skip 1 | Out-String  | %{$_.replace('"', '')} ).replace("`r`n",',')  )}