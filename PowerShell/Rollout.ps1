param([Parameter(Mandatory=$true)] [string]$CommitMessage, [switch]$Private, [switch]$NoUSB, [switch]$NoCommit, [switch]$NoPush)


Copy-Item -Path "C:\Users\mabdelwahab\Arbeit\PowerShell-Skripte\*" -Destination "C:\Users\mabdelwahab\Arbeit\Scripts\PowerShell" -Exclude "*.md" -PassThru
if (-not $Private) {
    Copy-Item -Path "C:\Users\mabdelwahab\Arbeit\PowerShell-Skripte\*" -Destination "\\odin\it\admin\Skripte" -Exclude "README.md","Rollout.ps1" -PassThru
    if (-not $NoUSB) {
        Copy-Item -Path "C:\Users\mabdelwahab\Arbeit\PowerShell-Skripte\*" -Destination "E:\Skripte" -Exclude "README.md","Rollout.ps1" -PassThru
    }
}

Write-Output "`n"

if (-not $NoCommit) {
    Set-Location "C:\Users\mabdelwahab\Arbeit\PowerShell-Skripte"
    git add .
    Write-Output "=== Commiting ==="
    git commit -m $CommitMessage
    if (-not $NoPush) {
        Write-Output "`n=== Pushing ==="
        git push
    }

    Write-Output "`n"

    Set-Location "C:\Users\mabdelwahab\Arbeit\Scripts\PowerShell"
    git add .
    Write-Output "=== Commiting ==="
    git commit -m $CommitMessage
    if (-not $NoPush) {
        Write-Output "`n=== Pushing ==="
        git push
    }
}

Write-Output "`nFinished!!"