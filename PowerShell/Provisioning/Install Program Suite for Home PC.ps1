# Elevate the session if not already elevated, as admin privileges are needed
$CurrentlyAdmin = (New-Object Security.Principal.WindowsPrincipal $([Security.Principal.WindowsIdentity]::GetCurrent())).IsInRole([Security.Principal.WindowsBuiltinRole]::Administrator)
If (-Not $CurrentlyAdmin)
{
    # Get the path to the currently running PowerShell version
    $Path = (Get-Process -id $PID | Get-Item | Select -ExpandProperty Fullname)

    Start-Process $Path -Verb runAs -ArgumentList "-NoLogo -ExecutionPolicy Bypass -File `"$PSCommandPath`""
    Exit
}


# Installation Step
# It would be preferable  to make all the installation with just one command to get a better statistic at the end, but
# I don't know a way to pass individual install and package arguments when installing several packages at once.

# Core
choco install -y 'chocolateygui'
choco install -y 'choco-cleaner'
choco install -y 'autohotkey'
choco install -y 'dual-monitor-tools'

# Programs
choco install -y '7zip'
choco install -y 'gimp'
choco install -y 'thunderbird'
choco install -y 'drawio'
choco install -y 'ipe'
choco install -y 'vlc'
choco install -y 'pdf24' -params '"/Basic"'

# Browsers
choco install -y 'firefox'
choco install -y 'firefox-dev' --pre
choco install -y 'googlechrome'

# Hardware
choco install -y 'hwinfo'
choco install -y 'cpu-z'
choco install -y 'gpu-z'

# Entertainment
choco install -y 'steam'
choco install -y 'origin'
choco install -y 'uplay'
choco install -y 'battle.net'


# Pin down strongly auto updating packages
choco pin add -n='thunderbird'
choco pin add -n='firefox'
choco pin add -n='firefox-dev'
choco pin add -n='googlechrome'
choco pin add -n='steam'
choco pin add -n='origin'
choco pin add -n='uplay'
choco pin add -n='battle.net'


# Pause, so as to observe results
Pause

