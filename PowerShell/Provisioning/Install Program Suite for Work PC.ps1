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
choco install -y 'microsoft-windows-terminal'
choco install -y 'powershell-core' --install-arguments='"ADD_EXPLORER_CONTEXT_MENU_OPENPOWERSHELL=1 REGISTER_MANIFEST=1"' 
choco install -y 'powershell-preview' --install-arguments='"ADD_EXPLORER_CONTEXT_MENU_OPENPOWERSHELL=1 REGISTER_MANIFEST=1"' 
choco install -y 'cascadiafonts'

# Developement
choco install -y 'python'
choco install -y 'nodejs'
choco install -y 'php' 
choco install -y 'sass'
choco install -y 'git'
choco install -y 'sublimetext3'
choco install -y 'sublimemerge'
choco install -y 'vscode'
choco install -y 'filezilla'
choco install -y 'heroku-cli'

# Programs
choco install -y '7zip'
choco install -y 'iobit-uninstaller'
choco install -y 'gimp'
choco install -y 'thunderbird'
choco install -y 'drawio'
choco install -y 'vlc'
choco install -y 'pdf24' -params '"/Basic"'

# Browsers
choco install -y 'firefox'
choco install -y 'firefox-dev' --pre
choco install -y 'googlechrome'
choco install -y 'opera'

# Hardware
choco install -y 'hwinfo'
choco install -y 'cpu-z'
choco install -y 'gpu-z'

# Virtualization
choco install -y 'virtualbox'
choco install -y 'vagrant'

# Databases
choco install -y 'dbeaver'


# Pin down strongly auto updating packages
choco pin add -n='firefox'
choco pin add -n='firefox-dev'
choco pin add -n='googlechrome'
choco pin add -n='opera'
choco pin add -n='thunderbird'
choco pin add -n='steam'


# Pause, so as to observe results
Pause

