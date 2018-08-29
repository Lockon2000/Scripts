# Creating a HKCR Registry drive
New-PSDrive -Name HKCR -PSProvider Registry -Root HKEY_CLASSES_ROOT


# To elevate the session if needed in a script
$CurrentlyAdmin = (New-Object Security.Principal.WindowsPrincipal $([Security.Principal.WindowsIdentity]::GetCurrent())).IsInRole([Security.Principal.WindowsBuiltinRole]::Administrator)
If (-Not $CurrentlyAdmin)
{
    Start-Process powershell.exe -Verb runAs -ArgumentList "-NoLogo -ExecutionPolicy Bypass -File `"$PSCommandPath`""
    Exit
}


# To change a service startup type: 0 for instantly and 1 for delayed
Set-ItemProperty -Path "Registry::HKLM\System\CurrentControlSet\Services\theservice" -Name "DelayedAutostart" -Value 1 -Type DWORD


# Chocolatey profile
$ChocolateyProfile = "$env:ChocolateyInstall\helpers\chocolateyProfile.psm1"
if (Test-Path($ChocolateyProfile)) {
  Import-Module "$ChocolateyProfile"
}
