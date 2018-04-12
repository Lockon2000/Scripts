$drives = Get-WmiObject win32_logicaldisk
$total1 = 0
ForEach ($drive in $drives) {
    $total1 = $total1 + $drive.FreeSpace
}

If ((Get-Host).Version.Major -gt 2){
    Remove-Item -Path $env:TEMP\* -Recurse -Force *>$null
    Remove-Item -Path C:\Windows\Temp\* -Recurse -Force *>$null
    Remove-Item -Path C:\Windows\SoftwareDistribution\Download\* -Recurse -Force *>$null
    Remove-Item -Path C:\Windows\Prefetch\* -Recurse -Force *>$null
    Remove-Item -Path 'C:\Windows\$NT*' -Recurse -Force *>$null

    vssadmin delete shadows /All /Quiet *>$null

    cleanmgr /SAGERUN:1 | Out-Null
}
Else {
    Remove-Item -Path $env:TEMP\* -Recurse -Force 
    Remove-Item -Path C:\Windows\Temp\* -Recurse -Force
    Remove-Item -Path C:\Windows\SoftwareDistribution\Download\* -Recurse -Force
    Remove-Item -Path C:\Windows\Prefetch\* -Recurse -Force
    Remove-Item -Path 'C:\Windows\$NT*' -Recurse -Force

    vssadmin delete shadows /All /Quiet | Out-Null

    cleanmgr /SAGERUN:1 | Out-Null

}

$drives = Get-WmiObject win32_logicaldisk
$total2 = 0
ForEach ($drive in $drives) {
    $total2 = $total2 + $drive.FreeSpace
}

Write-Host Der freigegebene Speicherplatz beträgt (($total2 - $total1)/(1024*1024)) MBs `n
Pause