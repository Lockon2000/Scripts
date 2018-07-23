param([Parameter(Mandatory=$true)] [string]$commitMessage, [bool]$private)


Copy-Item -Path "C:\Users\mabdelwahab\Arbeit\PowerShell-Skripte\*" -Destination "C:\Users\mabdelwahab\Arbeit\Scripts\PowerShell" -Exclude "*.md"
if (-not $private) {
    Copy-Item -Path "C:\Users\mabdelwahab\Arbeit\PowerShell-Skripte\*" -Destination "\\odin\it\software\Skripte" -Exclude "*.md"
    Copy-Item -Path "C:\Users\mabdelwahab\Arbeit\PowerShell-Skripte\*" -Destination "E:\Skripte" -Exclude "*.md"
}

Write-Output "Begin with commiting..."

Set-Location "C:\Users\mabdelwahab\Arbeit\PowerShell-Skripte"
git add .
git commit -m $commitMessage
git push

Write-Output "`n`n"

Set-Location "C:\Users\mabdelwahab\Arbeit\Scripts\PowerShell"
git add .
git commit -m $commitMessage
git push

Write-Output "`nFinished!!"