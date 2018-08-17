param([Parameter(Mandatory=$true)] [string]$CommitMessage, [switch]$Private, [switch]$NoCommit, [switch]$NoPush)


Copy-Item -Path "C:\Users\mabdelwahab\Arbeit\PowerShell-Skripte\*" -Destination "C:\Users\mabdelwahab\Arbeit\Scripts\PowerShell" -Exclude "*.md" -PassThru
if (-not $Private) {
    Copy-Item -Path "C:\Users\mabdelwahab\Arbeit\PowerShell-Skripte\*" -Destination "\\odin\it\software\Skripte" -Exclude "*.md" -PassThru
    Copy-Item -Path "C:\Users\mabdelwahab\Arbeit\PowerShell-Skripte\*" -Destination "E:\Skripte" -Exclude "*.md" -PassThru
}


if (-not $NoCommit) {
    Set-Location "C:\Users\mabdelwahab\Arbeit\PowerShell-Skripte"
    git add .
    Write-Output "Commiting"
    git commit -m $CommitMessage
    if (-not $NoPush) {
        Write-Output "`nPushing"
        git push
    }

    Write-Output "`n"

    Set-Location "C:\Users\mabdelwahab\Arbeit\Scripts\PowerShell"
    git add .
    Write-Output "Commiting"
    git commit -m $CommitMessage
    if (-not $NoPush) {
        Write-Output "`nPushing"
        git push
    }
}

Write-Output "`nFinished!!"