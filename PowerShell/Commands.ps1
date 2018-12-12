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
Set-ItemProperty -Path "Registry::HKLM\System\CurrentControlSet\Services\<theservice>" -Name "DelayedAutostart" -Value 1 -Type DWORD


# Chocolatey profile
$ChocolateyProfile = "$env:ChocolateyInstall\helpers\chocolateyProfile.psm1"
if (Test-Path($ChocolateyProfile)) {
  Import-Module "$ChocolateyProfile"
}


# Programmatically make a shortcut start with admin privilages
$bytes = [System.IO.File]::ReadAllBytes("<path-to-shortcut>")
$bytes[0x15] = $bytes[0x15] -bor 0x20   #set byte 21 (0x15) bit 6 (0x20) ON

[System.IO.File]::WriteAllBytes("<path-to-shortcut>", $bytes)