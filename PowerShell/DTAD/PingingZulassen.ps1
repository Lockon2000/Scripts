$CurrentlyAdmin = (New-Object Security.Principal.WindowsPrincipal $([Security.Principal.WindowsIdentity]::GetCurrent())).IsInRole([Security.Principal.WindowsBuiltinRole]::Administrator)
If (-Not $CurrentlyAdmin)
{
    Start-Process powershell.exe -Verb runAs -ArgumentList "-NoLogo -ExecutionPolicy Bypass -File `"$PSCommandPath`""
    Exit
}

Write-Output "Lasse Pings zu:"
netsh advfirewall firewall add rule name="Enable Echo Ping Request" protocol="icmpv4:8,any" dir=in action=allow
