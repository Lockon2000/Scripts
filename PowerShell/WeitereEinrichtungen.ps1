Write-Output "Lasse Pings zu:"
netsh advfirewall firewall add rule name="Enable Echo Ping Request" protocol="icmpv4:8,any" dir=in action=allow

Write-Output "�ndere den Starttyp vom WinRM-Service zu nicht verz�gert:"
Set-ItemProperty -Path "Registry::HKLM\System\CurrentControlSet\Services\WinRM\" -Name "DelayedAutostart" -Value 0 -Type DWORD