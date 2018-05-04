$CurrentlyAdmin = (New-Object Security.Principal.WindowsPrincipal $([Security.Principal.WindowsIdentity]::GetCurrent())).IsInRole([Security.Principal.WindowsBuiltinRole]::Administrator)
If (-Not $CurrentlyAdmin)
{
    Start-Process powershell.exe -Verb runAs -ArgumentList "-NoLogo -ExecutionPolicy Bypass -File $PSCommandPath"
    Exit
}

Get-AppxPackage 64885BlueEdge.OneCalendar | Remove-AppxPackage
Get-AppxPackage A278AB0D.DisneyMagicKingdoms | Remove-AppxPackage
Get-AppxPackage A278AB0D.MarchofEmpires | Remove-AppxPackage
Get-AppxPackage DolbyLaboratories.DolbyAccess | Remove-AppxPackage
Get-AppxPackage Microsoft.BingNews | Remove-AppxPackage
Get-AppxPackage Microsoft.BingWeather | Remove-AppxPackage
Get-AppxPackage Microsoft.BingWeather | Remove-AppxPackage
Get-AppxPackage Microsoft.GetHelp | Remove-AppxPackage
Get-AppxPackage Microsoft.MSPaint | Remove-AppxPackage
Get-AppxPackage Microsoft.Messaging | Remove-AppxPackage
Get-AppxPackage Microsoft.Microsoft3DViewer | Remove-AppxPackage
Get-AppxPackage Microsoft.MicrosoftOfficeHub | Remove-AppxPackage
Get-AppxPackage Microsoft.MicrosoftSolitaireCollection | Remove-AppxPackage
Get-AppxPackage Microsoft.Office.OneNote | Remove-AppxPackage
Get-AppxPackage Microsoft.OneConnect | Remove-AppxPackage
Get-AppxPackage Microsoft.People | Remove-AppxPackage
Get-AppxPackage Microsoft.Print3D | Remove-AppxPackage
Get-AppxPackage Microsoft.SkypeApp | Remove-AppxPackage
Get-AppxPackage Microsoft.Wallet | Remove-AppxPackage
Get-AppxPackage Microsoft.WindowsCalculator | Remove-AppxPackage
Get-AppxPackage Microsoft.WindowsFeedbackHub | Remove-AppxPackage
Get-AppxPackage Microsoft.Xbox.TCUI | Remove-AppxPackage
Get-AppxPackage Microsoft.XboxApp | Remove-AppxPackage
Get-AppxPackage Microsoft.XboxApp | Remove-AppxPackage
Get-AppxPackage Microsoft.XboxGameOverlay | Remove-AppxPackage
Get-AppxPackage Microsoft.XboxIdentityProvider | Remove-AppxPackage
Get-AppxPackage Microsoft.XboxSpeechToTextOverlay | Remove-AppxPackage
Get-AppxPackage Microsoft.ZuneMusic | Remove-AppxPackage
Get-AppxPackage Microsoft.ZuneVideo | Remove-AppxPackage
Get-AppxPackage XINGAG.XING | Remove-AppxPackage
Get-AppxPackage king.com.BubbleWitch3Saga | Remove-AppxPackage
Get-AppxPackage king.com.CandyCrushSodaSaga | Remove-AppxPackage


Get-appxprovisionedpackage –online | where-object {$_.packagename –like "*Microsoft.BingWeather*"} | remove-appxprovisionedpackage –online *>$null
Get-appxprovisionedpackage –online | where-object {$_.packagename –like "*Microsoft.Messaging*"} | remove-appxprovisionedpackage –online *>$null
Get-appxprovisionedpackage –online | where-object {$_.packagename –like "*Microsoft.Microsoft3DViewer*"} | remove-appxprovisionedpackage –online *>$null
Get-appxprovisionedpackage –online | where-object {$_.packagename –like "*Microsoft.MicrosoftSolitaireCollection*"} | remove-appxprovisionedpackage –online *>$null
Get-appxprovisionedpackage –online | where-object {$_.packagename –like "*Microsoft.Office.OneNote*"} | remove-appxprovisionedpackage –online *>$null
Get-appxprovisionedpackage –online | where-object {$_.packagename –like "*Microsoft.Print3D*"} | remove-appxprovisionedpackage –online *>$null
Get-appxprovisionedpackage –online | where-object {$_.packagename –like "*Microsoft.Wallet*"} | remove-appxprovisionedpackage –online *>$null
Get-appxprovisionedpackage –online | where-object {$_.packagename –like "*Microsoft.WindowsFeedbackHub*"} | remove-appxprovisionedpackage –online *>$null
Get-appxprovisionedpackage –online | where-object {$_.packagename –like "*Microsoft.Xbox.TCUI*"} | remove-appxprovisionedpackage –online *>$null
Get-appxprovisionedpackage –online | where-object {$_.packagename –like "*Microsoft.XboxApp*"} | remove-appxprovisionedpackage –online *>$null
Get-appxprovisionedpackage –online | where-object {$_.packagename –like "*Microsoft.XboxGameOverlay*"} | remove-appxprovisionedpackage –online *>$null
Get-appxprovisionedpackage –online | where-object {$_.packagename –like "*Microsoft.XboxIdentityProvider*"} | remove-appxprovisionedpackage –online *>$null
Get-appxprovisionedpackage –online | where-object {$_.packagename –like "*Microsoft.XboxSpeechToTextOverlay*"} | remove-appxprovisionedpackage –online *>$null
Get-appxprovisionedpackage –online | where-object {$_.packagename –like "*Microsoft.ZuneMusic*"} | remove-appxprovisionedpackage –online *>$null
Get-appxprovisionedpackage –online | where-object {$_.packagename –like "*Microsoft.ZuneVideo*"} | remove-appxprovisionedpackage –online *>$null


Write-Output "Fertig!"
Pause
