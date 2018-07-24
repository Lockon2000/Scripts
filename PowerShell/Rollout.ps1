param([Parameter(Mandatory=$true)] [string]$commitMessage, [Parameter(Mandatory=$true)] [bool]$private)


Copy-Item -Path "C:\Users\mabdelwahab\Arbeit\PowerShell-Skripte\*" -Destination "C:\Users\mabdelwahab\Arbeit\Scripts\PowerShell" -Exclude "*.md"
if (-not $private) {
    Copy-Item -Path "C:\Users\mabdelwahab\Arbeit\PowerShell-Skripte\*" -Destination "\\odin\it\software\Skripte" -Exclude "*.md"
    Copy-Item -Path "C:\Users\mabdelwahab\Arbeit\PowerShell-Skripte\*" -Destination "E:\Skripte" -Exclude "*.md"
}


Set-Location "C:\Users\mabdelwahab\Arbeit\PowerShell-Skripte"
git add .
Write-Output "Commiting"
git commit -m $commitMessage
Write-Output "`nPushing"
git push

Write-Output "`n"

Set-Location "C:\Users\mabdelwahab\Arbeit\Scripts\PowerShell"
git add .
Write-Output "Commiting"
git commit -m $commitMessage
Write-Output "`nPushing"
git push

Write-Output "`nFinished!!"