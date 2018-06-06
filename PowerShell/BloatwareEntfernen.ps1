$CurrentlyAdmin = (New-Object Security.Principal.WindowsPrincipal $([Security.Principal.WindowsIdentity]::GetCurrent())).IsInRole([Security.Principal.WindowsBuiltinRole]::Administrator)
If (-Not $CurrentlyAdmin)
{
    Start-Process powershell.exe -Verb runAs -ArgumentList "-NoLogo -ExecutionPolicy Bypass -File $PSCommandPath"
    Exit
}

$packages = "*828B5831*","Microsoft.MinecraftUWP","828B5831.HiddenCityMysteryofShadows","Nordcurrent.CookingFever","*A278AB0D*","*Duolingo*","*king.com*","46928bounde.EclipseManager","64885BlueEdge.OneCalendar","AdobeSystemsIncorporated.AdobePhotoshopExpress","DolbyLaboratories.DolbyAccess","Microsoft.BingNews","Microsoft.BingTranslator","Microsoft.BingWeather","Microsoft.GetHelp","Microsoft.Messaging","Microsoft.Microsoft3DViewer","Microsoft.MicrosoftOfficeHub","Microsoft.MicrosoftSolitaireCollection","Microsoft.Office.OneNote","Microsoft.Office.Sway","Microsoft.OneConnect","Microsoft.People","Microsoft.Print3D","Microsoft.Wallet","Microsoft.WindowsFeedbackHub","Microsoft.Xbox.TCUI","Microsoft.XboxApp","Microsoft.XboxApp","Microsoft.XboxGameOverlay","Microsoft.XboxIdentityProvider","Microsoft.XboxSpeechToTextOverlay","Microsoft.ZuneMusic","Microsoft.ZuneVideo","XINGAG.XING","Microsoft.NetworkSpeedTest","Microsoft.Getstarted"

$provisions = "*Microsoft.BingWeather*","*Microsoft.Messaging*","*Microsoft.Microsoft3DViewer*","*Microsoft.MicrosoftSolitaireCollection*","*Microsoft.Office.OneNote*","*Microsoft.Print3D*","*Microsoft.MSPaint*","*Microsoft.Wallet*","*Microsoft.WindowsFeedbackHub*","*Microsoft.Xbox.TCUI*","*Microsoft.XboxApp*","*Microsoft.XboxGameOverlay*","*Microsoft.XboxIdentityProvider*","*Microsoft.XboxSpeechToTextOverlay*","*Microsoft.ZuneMusic*","*Microsoft.ZuneVideo*"


$i = 1
[System.Collections.ArrayList]$notuninstalled = @()
foreach ($p in $packages) {
    $job = Start-Job {param($p); Get-AppxPackage $p | Remove-AppxPackage } -ArgumentList $p
    Wait-Job $job | Out-Null
    if (-not (Get-AppxPackage $p)) {
        Write-Progress -Activity "Deinstalliere App-Packete" -Status (([math]::Round($i/$packages.count*100)).toString()+"% Complete:") -PercentComplete ($i/$packages.count*100) -CurrentOperation "Deinstalliere $p"
        $i++
    } else {
        $notuninstalled += $p
    }
}

if ($notuninstalled) {
    Write-Output "Folgende Apps wurden nicht deinstalliert: " $notuninstalled
}

Write-Output "Deinstallation von Apps fertig"

$i = 1
[System.Collections.ArrayList]$notuninstalled = @()
foreach ($p in $provisions) {
    Get-appxprovisionedpackage –online | where-object {$_.packagename –like $p} | remove-appxprovisionedpackage –online *>$null
    if (-not (Get-appxprovisionedpackage –online | where-object {$_.packagename –like $p})) {
        Write-Progress -Activity "Deinstalliere App-Provisionen" -Status (([math]::Round($i/$provisions.count*100)).toString()+"% Complete:") -PercentComplete ($i/$provisions.count*100) -CurrentOperation "Deinstalliere $p"
        $i++
    } else {
        $notuninstalled += $p
    }
}

if ($notuninstalled) {
    Write-Output "Folgende Provisionen wurden nicht entfernt: " $notuninstalled
}

Write-Output "Deinstallation von App-Provisionen fertig"

function Pin-App {
    param([parameter(mandatory=$true)][ValidateNotNullOrEmpty()][string[]]$appname,
        [switch]$unpin)

    $actionstring = @{$true='Von "Start" lösen|Unpin from Start';$false='An "Start" anheften|Pin to Start'}[$unpin.IsPresent]
    $action = @{$true='unpinned from';$false='pinned to'}[$unpin.IsPresent]
    $apps = (New-Object -Com Shell.Application).NameSpace('shell:::{4234d49b-0245-4df3-b780-3893943456e1}').Items() | ?{$_.Name -in $appname}
    
    if($apps){
        $notfound = compare $appname $apps.Name -PassThru
        if ($notfound){write-error "These App(s) were not found: $($notfound -join ",")"}

        foreach ($app in $apps) {
            $appaction = $app.Verbs() | ?{$_.Name.replace('&','') -match $actionstring}
            if ($appaction) {
                $appaction | %{$_.DoIt(); return "App '$($app.Name)' $action Start"}
            } else {
                write-error "App '$($app.Name)' is already pinned to start or action not supported."
            }
        }
    } else {
        write-error "App(s) not found: $($appname -join ",")"
    }
}

$apps = (New-Object -Com Shell.Application).NameSpace('shell:::{4234d49b-0245-4df3-b780-3893943456e1}').Items()
$apps | % {pin-app $_.name -unpin} *>$null

Write-Output "Alle Kacheln vom Startmenü entfernt"

Write-Output "Fertig!"
Pause