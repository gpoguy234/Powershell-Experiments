# find stuff fast un user profiles  - must be running as local admin or System user
$Profiles = dir C:\Users -Directory
foreach ($UserFolder in $Profiles){
    dir -path C:\Users\$UserFolder -Directory |
        foreach { dir -Path $_.FullName -File -Recurse -Include *.tiff,*.btu,*.txt |
                Select-Object -ExpandProperty FullName }
}
