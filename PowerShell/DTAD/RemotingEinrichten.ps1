$CurrentlyAdmin = (New-Object Security.Principal.WindowsPrincipal $([Security.Principal.WindowsIdentity]::GetCurrent())).IsInRole([Security.Principal.WindowsBuiltinRole]::Administrator)
If (-Not $CurrentlyAdmin)
{
    Start-Process powershell.exe -Verb runAs -ArgumentList "-NoLogo -ExecutionPolicy Bypass -File `"$PSCommandPath`""
    Exit
}


Enable-PSRemoting -SkipNetworkProfileCheck -Force

Write-Output "Ändere den Starttyp vom WinRM-Service zu nicht verzögert:"
Set-ItemProperty -Path "Registry::HKLM\System\CurrentControlSet\Services\WinRM\" -Name "DelayedAutostart" -Value 0 -Type DWORD

Write-Output "Ferting!"
Pause