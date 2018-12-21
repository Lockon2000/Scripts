Set-ItemProperty "HKLM:\SYSTEM\CurrentControlSet\Control\Session Manager\Power\" -Name HiberbootEnabled -Value 0

Write-Out "Fertig!!"
Pause