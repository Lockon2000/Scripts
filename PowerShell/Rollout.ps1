param([Parameter(Mandatory=$true)] [string]$CommitMessage, [switch]$Private, [switch]$NoUSB, [switch]$NoDeployToProfile, [switch]$NoCommit, [switch]$NoPush)


Write-Output "-------------------------------------------------"
Write-Output "`nPhase 1: Distribution"

Copy-Item -Path "C:\Users\mabdelwahab\Arbeit\PowerShell-Skripte\*" -Destination "C:\Users\mabdelwahab\Arbeit\Scripts\PowerShell" -Exclude "README.md","Microsoft.PowerShell_profile.ps1" -PassThru
if (-not $Private) {
    Copy-Item -Path "C:\Users\mabdelwahab\Arbeit\PowerShell-Skripte\*" -Destination "\\odin\it\admin\Skripte" -Exclude "README.md","Microsoft.PowerShell_profile.ps1","Rollout.ps1" -PassThru
    if (-not $NoUSB) {
        Copy-Item -Path "C:\Users\mabdelwahab\Arbeit\PowerShell-Skripte\*" -Destination "E:\Skripte" -Exclude "README.md","Microsoft.PowerShell_profile.ps1","Rollout.ps1" -PassThru
    }
}


if (-not $NoDeployToProfile) {
    Write-Output "`n-------------------------------------------------"
    Write-Output "`nPhase 2: Profile Deployment"

    Copy-Item -Path "C:\Users\mabdelwahab\Arbeit\PowerShell-Skripte\Microsoft.PowerShell_profile.ps1" -Destination "C:\Users\mabdelwahab\Documents\WindowsPowerShell" -PassThru
    foreach ($file in (Dir "C:\Users\mabdelwahab\Arbeit\PowerShell-Skripte\*.psm1")) {
        Copy-Item -Path $file.fullname -Destination "C:\Users\mabdelwahab\Documents\WindowsPowerShell\Modules\$($file.name[0..($file.name.Length-6)] -join '')\" -PassThru
    }
}


if (-not $NoCommit) {
    Write-Output "`n-------------------------------------------------"
    Write-Output "`nPhase 3: Repository Update"

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


Write-Output "`n******************Finished!!*********************"
