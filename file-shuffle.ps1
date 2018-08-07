
$file = "External E-Mail.msg"
$filenameonly = $file.Split(".")[0]
$savePath = "C:\test\msg"

function shuffle_fileName($file){
#does message already exist with this filename - if so list last
    if (Test-Path $file){
        #file exists 
        Write-Host "$file exists!"
        #- check for multiple messages
        $searchstr = ($file.Split(".")[0])+"-*.msg";
        $list = @(ls $searchstr);
        if($list.count -gt 1){
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

cd $savePath
shuffle_fileName($file)

