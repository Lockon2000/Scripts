$CurrentlyAdmin = (New-Object Security.Principal.WindowsPrincipal $([Security.Principal.WindowsIdentity]::GetCurrent())).IsInRole([Security.Principal.WindowsBuiltinRole]::Administrator)
If (-Not $CurrentlyAdmin)
{
    Start-Process powershell.exe -Verb runAs -ArgumentList "-NoLogo -ExecutionPolicy Bypass -File $PSCommandPath"
    Exit
}

$packages = "*A278AB0D*","*Duolingo*","*king.com*","46928bounde.EclipseManager","64885BlueEdge.OneCalendar","AdobeSystemsIncorporated.AdobePhotoshopExpress","DolbyLaboratories.DolbyAccess","Microsoft.BingNews","Microsoft.BingTranslator","Microsoft.BingWeather","Microsoft.GetHelp","Microsoft.Messaging","Microsoft.Microsoft3DViewer","Microsoft.MicrosoftOfficeHub","Microsoft.MicrosoftSolitaireCollection","Microsoft.Office.OneNote","Microsoft.Office.Sway","Microsoft.OneConnect","Microsoft.People","Microsoft.Print3D","Microsoft.Wallet","Microsoft.WindowsFeedbackHub","Microsoft.Xbox.TCUI","Microsoft.XboxApp","Microsoft.XboxApp","Microsoft.XboxGameOverlay","Microsoft.XboxIdentityProvider","Microsoft.XboxSpeechToTextOverlay","Microsoft.ZuneMusic","Microsoft.ZuneVideo","XINGAG.XING","Microsoft.NetworkSpeedTest"

$provisions = "*Microsoft.BingWeather*","*Microsoft.Messaging*","*Microsoft.Microsoft3DViewer*","*Microsoft.MicrosoftSolitaireCollection*","*Microsoft.Office.OneNote*","*Microsoft.Print3D*","*Microsoft.MSPaint*","*Microsoft.Wallet*","*Microsoft.WindowsFeedbackHub*","*Microsoft.Xbox.TCUI*","*Microsoft.XboxApp*","*Microsoft.XboxGameOverlay*","*Microsoft.XboxIdentityProvider*","*Microsoft.XboxSpeechToTextOverlay*","*Microsoft.ZuneMusic*","*Microsoft.ZuneVideo*"

Write-Output "Deinstalliere App-Packete"

$i = 1
[System.Collections.ArrayList]$notuninstalled = @()
foreach ($p in $packages) {
    $job = Start-Job {param($p); Get-AppxPackage $p | Remove-AppxPackage } -ArgumentList $p
    Wait-Job $job | Out-Null
    if (-not (Get-AppxPackage $p)) {
        Write-Output "$i von $($packages.count)"
        $i++
    }
    else {
        $notuninstalled += $p
    }
}

if ($notuninstalled) {
    Write-Output "Folgende Apps wurden nicht deinstalliert: " $notuninstalled
}

Write-Output "Deinstalliere App-Provisionen"

$i = 1
[System.Collections.ArrayList]$notuninstalled = @()
foreach ($p in $provisions) {
    Get-appxprovisionedpackage –online | where-object {$_.packagename –like $p} | remove-appxprovisionedpackage –online *>$null
    if (-not (Get-appxprovisionedpackage –online | where-object {$_.packagename –like $p})) {
        Write-Output "$i von $($provisions.count)"
        $i++
    }
    else {
        $notuninstalled += $p
    }
}

if ($notuninstalled) {
    Write-Output "Folgende Provisionen wurden nicht entfernt: " $notuninstalled
}

Write-Output "Fertig!"
Pause