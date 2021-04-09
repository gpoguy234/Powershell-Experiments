# find stuff fast un user profiles
dir -path C:\Users -Directory |
    foreach { dir -Path $_.FullName -File -Recurse -Include *.tiff,*.btu,*.txt |
                Select-Object -ExpandProperty FullName }
