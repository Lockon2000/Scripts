$Cred = @{}
$Cred.Admin = @{}
$Cred.Admin.Desktop = Get-Credential -UserName admin -Message "Gib bitte das Admin-Kennwort für Desktops ein!"
$Cred.Admin.Laptop = Get-Credential -User admin -Message "Gib bitte das Admin-Kennwort für Laptops ein!"
$Cred.User = Get-Credential -UserName user -Message "Gib bitte das User-Kennwort für Desktops und Laptops ein!"

Export-Clixml -InputObject $Cred -Path "C:\Users\$env:Username\Documents\WindowsPowerShell\cred.xml"