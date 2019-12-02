# Elevate the session if not already elevated, as admin privileges are needed
$CurrentlyAdmin = (New-Object Security.Principal.WindowsPrincipal $([Security.Principal.WindowsIdentity]::GetCurrent())).IsInRole([Security.Principal.WindowsBuiltinRole]::Administrator)
If (-Not $CurrentlyAdmin)
{
    Start-Process powershell.exe -Verb runAs -ArgumentList "-NoLogo -ExecutionPolicy Bypass -File `"$PSCommandPath`""
    Exit
}


# Installation Step
# We make it in as few different commands as possible in order to get a meaning full statistic at the end
choco install 'chocolateygui' `
              'choco-cleaner' `
              'autohotkey' `
              'dual-monitor-tools' `
              'hwinfo' `
              'cpu-z' `
              'gpu-z' `
              '7zip' `
              'gimp' `
              'whatsapp' `
              'google-backup-and-sync' `
              'jdownloader' `
              'iobit-uninstaller' `
              'firefox' `
              'googlechrome' `
              'opera' `
              'python' `
              'git' `
              'sublimetext3' `
              'sublimemerge' `
              'vscode' `
              'filezilla' `
              'virtualbox' `
              'vagrant' `
              'thunderbird' `
              'anaconda3' `
              'drawio' `
              'steam' `
              'origin' `
              'uplay' `
              -y

choco install 'firefox-dev' -y --pre


# Pin down strongly auto updating packages
choco pin add -n='firefox'
choco pin add -n='firefox-dev'
choco pin add -n='googlechrome'
choco pin add -n='opera'
choco pin add -n='thunderbird'
choco pin add -n='steam'


# Pause, so as to observe results
Pause

