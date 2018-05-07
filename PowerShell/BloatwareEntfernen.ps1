$CurrentlyAdmin = (New-Object Security.Principal.WindowsPrincipal $([Security.Principal.WindowsIdentity]::GetCurrent())).IsInRole([Security.Principal.WindowsBuiltinRole]::Administrator)
If (-Not $CurrentlyAdmin)
{
    Start-Process powershell.exe -Verb runAs -ArgumentList "-NoLogo -ExecutionPolicy Bypass -File $PSCommandPath"
    Exit
}

$packages = "*A278AB0D*","*Duolingo*","*king.com*","46928bounde.EclipseManager","64885BlueEdge.OneCalendar","AdobeSystemsIncorporated.AdobePhotoshopExpress","DolbyLaboratories.DolbyAccess",
"Microsoft.BingNews","Microsoft.BingTranslator","Microsoft.BingWeather","Microsoft.GetHelp","Microsoft.Messaging","Microsoft.Microsoft3DViewer","Microsoft.MicrosoftOfficeHub",
"Microsoft.MicrosoftSolitaireCollection","Microsoft.MSPaint","Microsoft.Office.OneNote","Microsoft.Office.Sway","Microsoft.OneConnect","Microsoft.People","Microsoft.Print3D","Microsoft.SkypeApp",
"Microsoft.Wallet","Microsoft.WindowsCalculator","Microsoft.WindowsFeedbackHub","Microsoft.Xbox.TCUI","Microsoft.XboxApp","Microsoft.XboxApp","Microsoft.XboxGameOverlay","Microsoft.XboxIdentityProvider",
"Microsoft.XboxSpeechToTextOverlay","Microsoft.ZuneMusic","Microsoft.ZuneVideo","XINGAG.XING","Microsoft.NetworkSpeedTest"

Write-Output "Deinstalliere App-Packete"

foreach ($p in $packages) {
$job = Start-Job {param($p); Get-AppxPackage $p | Remove-AppxPackage } -ArgumentList $p
Wait-Job $job
Write-Output (Receive-Job $job)
}

$provisions = "*Microsoft.BingWeather*","*Microsoft.Messaging*","*Microsoft.Microsoft3DViewer*","*Microsoft.MicrosoftSolitaireCollection*","*Microsoft.Office.OneNote*","*Microsoft.Print3D*","*Microsoft.MSPaint*",
"*Microsoft.Wallet*","*Microsoft.WindowsFeedbackHub*","*Microsoft.Xbox.TCUI*","*Microsoft.XboxApp*","*Microsoft.XboxGameOverlay*","*Microsoft.XboxIdentityProvider*","*Microsoft.XboxSpeechToTextOverlay*",
"*Microsoft.ZuneMusic*","*Microsoft.ZuneVideo*"

Write-Output "Deinstalliere App-Provisionen"

foreach ($p in $provisions) {
Get-appxprovisionedpackage –online | where-object {$_.packagename –like $p} | remove-appxprovisionedpackage –online *>$null
}

Write-Output "Fertig!"
Pause
