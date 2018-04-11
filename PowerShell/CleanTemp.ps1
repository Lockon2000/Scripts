Remove-Item -Path $env:TEMP\* -Recurse -Force
Remove-Item -Path C:\Windows\Temp\* -Recurse -Force
Remove-Item -Path C:\Windows\SoftwareDistribution\Download\* -Recurse -Force
Remove-Item -Path C:\Windows\Prefetch\* -Recurse -Force
Remove-Item -Path 'C:\Windows\$NT*' -Recurse -Force

vssadmin delete shadows /All /Quiet

cleanmgr /SAGERUN:1