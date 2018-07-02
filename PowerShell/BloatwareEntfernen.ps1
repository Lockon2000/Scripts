Write-Output "in Arbeit ...."

# Check wether the session is elevated or not
$CurrentlyAdmin = (New-Object Security.Principal.WindowsPrincipal $([Security.Principal.WindowsIdentity]::GetCurrent())).IsInRole([Security.Principal.WindowsBuiltinRole]::Administrator)

# Things to do without privileges (uninstall apps, unping apps from start menu)

if (-not $CurrentlyAdmin) {
    # Uninstall Apps

    $packagesToSpareNamed = @("Microsoft.RemoteDesktop"
                              "Microsoft.WebMediaExtensions"
                              "Microsoft.Win32WebViewHost"
                              "Microsoft.Windows.CloudExperienceHost"
                              "Microsoft.AAD.BrokerPlugin"
                              "Microsoft.Windows.ShellExperienceHost"
                              "windows.immersivecontrolpanel"
                              "Microsoft.Windows.Cortana"
                              "Microsoft.MicrosoftEdge"
                              "Microsoft.Windows.ContentDeliveryManager"
                              "microsoft.windowscommunicationsapps"
                              "Microsoft.Windows.Photos"
                              "Microsoft.WindowsStore"
                              "Microsoft.WindowsCamera"
                              "Windows.PrintDialog"
                              "Microsoft.Windows.SecureAssessmentBrowser"
                              "Microsoft.Windows.SecondaryTileExperience"
                              "Microsoft.Windows.SecHealthUI"
                              "Microsoft.Windows.PinningConfirmationDialog"
                              "Microsoft.Windows.Apprep.ChxApp"
                              "Microsoft.Windows.AssignedAccessLockApp"
                              "Microsoft.LockApp"
                              "Microsoft.Windows.OOBENetworkCaptivePortal"
                              "Microsoft.PPIProjection"
                              "Microsoft.Windows.HolographicFirstRun"
                              "Microsoft.AccountsControl"
                              "Microsoft.Windows.ParentalControls"
                              "Microsoft.Windows.OOBENetworkConnectionFlow"
                              "Microsoft.Windows.PeopleExperienceHost"
                              "Microsoft.CredDialogHost"
                              "Microsoft.WindowsAlarms"
                              "Microsoft.SkypeApp"
                              "Microsoft.WindowsSoundRecorder"
                              "Microsoft.WindowsMaps"
                              "Microsoft.WindowsCalculator"
                              "Microsoft.StorePurchaseApp"
                              "Microsoft.Office.OneNote"
                              "Microsoft.MSPaint"
                              "Microsoft.MicrosoftStickyNotes"
                              "Microsoft.Services.Store.Engagement"
                              "Microsoft.Services.Store.Engagement"
                              "Microsoft.DesktopAppInstaller"
                              "Microsoft.Advertising.Xaml"
                              "Microsoft.Advertising.Xaml"
                              "Microsoft.XboxGameCallableUI"
                              "1527c705-839a-4832-9118-54d4Bd6a0c89"
                              "c5e2524a-ea46-4f67-841f-6a9465d9d515"
                              "E2A4F912-2574-4A75-9BB0-0D023378592B"
                              "F46D4000-FD22-4DB4-AC8E-4E1DDDE828FE"
                              "InputApp"
                              "Microsoft.ECApp"
                              "Microsoft.BioEnrollment"
                              "Windows.CBSPreview"
                              "Microsoft.AsyncTextService"
                              "Microsoft.MicrosoftEdgeDevToolsClient"
                              "Microsoft.Windows.CapturePicker")
    $packagesToSpareWildcard = @("*Microsoft.NET*"
                                 "*Microsoft.VCLibs*"
                                 "*Microsoft.LanguageExperiencePack*")
    [System.Collections.ArrayList]$packagesToSpare = @()
    $packagesToSpareNamed | % {$packagesToSpare += (Get-AppxPackage $_).name}
    $packagesToSpareWildcard | % {$packagesToSpare += (Get-AppxPackage $_).name}
    [System.Collections.ArrayList]$packages = @()
    Get-AppxPackage | % {if ($_.name -notin $packagesToSpare) {$packages += $_}}

    [System.Collections.ArrayList]$stillinstalled = @()
    $i = 1
    foreach ($p in $packages) {
        $job = Start-Job {param($p); $p | Remove-AppxPackage} -ArgumentList $p
        Wait-Job $job | Out-Null
        if (-not (Get-AppxPackage $p.name)) {
            Write-Progress -Activity "Deinstalliere App-Packete" -Status (([math]::Round($i/$packages.count*100)).toString()+"% Complete:") `
                -PercentComplete ($i/$packages.count*100) -CurrentOperation "$($p.name) deinstalliert"
            $i++
        }
        else {
            $stillinstalled += $p
        }
    }

    if ($stillinstalled) {
        Write-Output "Folgende Apps wurden nicht deinstalliert: " $stillinstalled.name
    }

    Write-Output "Deinstallation von Apps fertig"


    # Remove pinned apps from Start menu

    function Pin-App {
        param(
            [parameter(mandatory=$true)][ValidateNotNullOrEmpty()][string[]]$appname,
            [switch]$unpin
        )
        $actionstring = @{$true='Von "Start" lösen|Unpin from Start';$false='An "Start" anheften|Pin to Start'}[$unpin.IsPresent]
        $action = @{$true='unpinned from';$false='pinned to'}[$unpin.IsPresent]
        $apps = (New-Object -Com Shell.Application).NameSpace('shell:::{4234d49b-0245-4df3-b780-3893943456e1}').Items() | ?{$_.Name -in $appname}
        
        if($apps){
            $notfound = compare $appname $apps.Name -PassThru
            if ($notfound){write-error "These App(s) were not found: $($notfound -join ",")"}

            foreach ($app in $apps){
                $appaction = $app.Verbs() | ?{$_.Name.replace('&','') -match $actionstring}
                if ($appaction){
                    $appaction | %{$_.DoIt(); return "App '$($app.Name)' $action Start"}
                }else{
                    write-error "App '$($app.Name)' is already pinned to start or action not supported."
                }
            }
        }else{
            write-error "App(s) not found: $($appname -join ",")"
        }
    }

    $apps = (New-Object -Com Shell.Application).NameSpace('shell:::{4234d49b-0245-4df3-b780-3893943456e1}').Items()
    $apps | % {pin-app $_.name -unpin} *>$null

    Write-Output "Alle Kacheln vom Startmenü entfernt"
}


# Elevate the Session if not already elevated

If (-Not $CurrentlyAdmin)
{
    Start-Process powershell.exe -Verb runAs -ArgumentList "-NoLogo -ExecutionPolicy Bypass -File `"$PSCommandPath`""
}


# Things to do with admin privileges (disable Microsoft Consumer Experiance, remove app provisions)

if ($CurrentlyAdmin) {
    # Disable Microsoft Consumer Experience

    if (Test-Path HKLM:\SOFTWARE\Policies\Microsoft\Windows\CloudContent\) {
        if (-not (Get-ItemProperty -Path HKLM:\SOFTWARE\Policies\Microsoft\Windows\CloudContent\).DisableWindowsConsumerFeatures) {
            Set-ItemProperty -Path HKLM:\SOFTWARE\Policies\Microsoft\Windows\CloudContent\ -Name DisableWindowsConsumerFeatures -Value 1
            Write-Output "Microsoft Consumer Experience wurde deaktiviert"
        } else {
            Write-Output "Microsoft Consumer Experience ist schon deaktiviert"
        }
    } else {
        New-Item -Path HKLM:\SOFTWARE\Policies\Microsoft\Windows\ -Name CloudContent | Out-Null
        Set-ItemProperty -Path HKLM:\SOFTWARE\Policies\Microsoft\Windows\CloudContent\ -Name DisableWindowsConsumerFeatures -Value 1
        Write-Output "Microsoft Consumer Experience wurde deaktiviert"
    }


    # Remove Provisions

    $provisionsToWipe = @("*Microsoft.BingWeather*"
                          "*Microsoft.Messaging*"
                          "*Microsoft.Microsoft3DViewer*"
                          "*Microsoft.MicrosoftSolitaireCollection*"
                          "*Microsoft.Office.OneNote*"
                          "*Microsoft.Print3D*"
                          "*Microsoft.MSPaint*"
                          "*Microsoft.Wallet*"
                          "*Microsoft.WindowsFeedbackHub*"
                          "*Microsoft.Xbox.TCUI*"
                          "*Microsoft.XboxApp*"
                          "*Microsoft.XboxGameOverlay*"
                          "*Microsoft.XboxIdentityProvider*"
                          "*Microsoft.XboxSpeechToTextOverlay*"
                          "*Microsoft.ZuneMusic*"
                          "*Microsoft.ZuneVideo*")
    [System.Collections.ArrayList]$provisions = @()
    foreach ($p in $provisionsToWipe) {
        Get-AppxProvisionedPackage -Online | % {if ($_.packagename -like $p) {$provisions += $_}}
    }

    $i = 1
    [System.Collections.ArrayList]$stillinstalled = @()
    foreach ($p in $provisions) {
        $p | remove-AppxProvisionedPackage -online *>$null
        if (-not (Get-AppxProvisionedPackage -online | ? {$_.packagename -like $p.packagename})) {
            Write-Progress -Activity "Deinstalliere App-Provisionen" -Status (([math]::Round($i/$provisions.count*100)).toString()+"% Complete:") `
                -PercentComplete ($i/$provisions.count*100) -CurrentOperation "$($p.packagename) gelöscht"
            $i++
        }
        else {
            $stillinstalled += $p
        }
    }

    if ($stillinstalled) {
        Write-Output "Folgende Provisionen wurden nicht entfernt: " $stillinstalled.packagename
    }

    Write-Output "Deinstallation von App-Provisionen fertig"
}


# Done!

Write-Output "Fertig!"
Pause