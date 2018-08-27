param([switch]$Private, [switch]$NoUSB,
      [switch]$NoDeployToProfile,
      [string]$CommitMessage, [switch]$NoCommit, [switch]$NoPush,
      [switch]$Help)

if ($Help) {
    Write-Host "Hilfe zum Rollout-Skript:`n"
               "Private: Dateien werden nur nach `"Scripts`" kopiert."
               "NoUSB: Dateien werden nicht zum Tools-USB kopiert. (Private darf nicht angegeben sein)"
               "-------"
               "NoDeployToProfile: Die Änderungen werden nicht zum aktuellen Profil augerollt."
               "-------"
               "CommitMessage: Die Nachricht für den Commit."
               "NoCommit: Keine Interaktion mit der Repository wird durchgeführt."
               "NoPush: Die Commits werden nicht zu Origin gepusht."
               "-------"
               "Help: Drucke Hilfe aus."

    return
}


Write-Output "-------------------------------------------------"
Write-Output "`nPhase 1: Distribution"

Copy-Item -Path "C:\Users\mabdelwahab\Arbeit\PowerShell-Skripte\*" -Destination "C:\Users\mabdelwahab\Arbeit\Scripts\PowerShell" -Exclude "README.md","Microsoft.PowerShell_profile.ps1" -PassThru
if (-not $Private) {
    Copy-Item -Path "C:\Users\mabdelwahab\Arbeit\PowerShell-Skripte\*" -Destination "\\odin\it\admin\Skripte" -Exclude "README.md","Microsoft.PowerShell_profile.ps1","Rollout.ps1" -PassThru
    if (-not $NoUSB) {
        Copy-Item -Path "C:\Users\mabdelwahab\Arbeit\PowerShell-Skripte\*" -Destination "D:\Skripte" -Exclude "README.md","Microsoft.PowerShell_profile.ps1","Rollout.ps1" -PassThru
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
