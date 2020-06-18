$CurrentlyAdmin = (New-Object Security.Principal.WindowsPrincipal $([Security.Principal.WindowsIdentity]::GetCurrent())).IsInRole([Security.Principal.WindowsBuiltinRole]::Administrator)
If (-Not $CurrentlyAdmin)
{
    # Get the path to the currently running PowerShell version
    $Path = (Get-Process -id $PID | Get-Item | Select -ExpandProperty Fullname)

    Start-Process $Path -Verb runAs -ArgumentList "-NoLogo -ExecutionPolicy Bypass -File `"$PSCommandPath`""
    Exit
}

$Drives = Get-WmiObject win32_logicaldisk
$TotalBefore = 0
ForEach ($Drive in $Drives) {
    $TotalBefore = $TotalBefore + $Drive.FreeSpace
}

If ((Get-Host).Version.Major -gt 2){
    Remove-Item -Path '$env:TEMP\*' -Recurse -Force *>$null
    Remove-Item -Path 'C:\Windows\Temp\*' -Recurse -Force *>$null
    Remove-Item -Path 'C:\Windows\SoftwareDistribution\Download\*' -Recurse -Force *>$null
    Remove-Item -Path 'C:\Windows\Prefetch\*' -Recurse -Force *>$null
    Remove-Item -Path 'C:\Windows\$NT*' -Recurse -Force *>$null

    vssadmin delete shadows /All /Quiet *>$null

    cleanmgr /SAGERUN:1 | Out-Null
}
Else {
    Remove-Item -Path '$env:TEMP\*' -Recurse -Force 
    Remove-Item -Path 'C:\Windows\Temp\*' -Recurse -Force
    Remove-Item -Path 'C:\Windows\SoftwareDistribution\Download\*' -Recurse -Force
    Remove-Item -Path 'C:\Windows\Prefetch\*' -Recurse -Force
    Remove-Item -Path 'C:\Windows\$NT*' -Recurse -Force

    vssadmin delete shadows /All /Quiet | Out-Null

    cleanmgr /SAGERUN:1 | Out-Null

}

$Drives = Get-WmiObject win32_logicaldisk
$TotalAfter = 0
ForEach ($Drive in $Drives) {
    $TotalAfter = $TotalAfter + $Drive.FreeSpace
}

Write-Host Der freigegebene Speicherplatz beträgt (($TotalAfter - $TotalBefore)/(1024*1024)) MBs `n
Pause