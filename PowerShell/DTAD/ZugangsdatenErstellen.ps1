$Cred = @{}
$Cred.Admin = @{}
$Cred.Admin.Desktop = Get-Credential -UserName admin -Message "Gib bitte das Admin-Kennwort f�r Desktops ein!"
$Cred.Admin.Laptop = Get-Credential -User admin -Message "Gib bitte das Admin-Kennwort f�r Laptops ein!"
$Cred.User = Get-Credential -UserName user -Message "Gib bitte das User-Kennwort f�r Desktops und Laptops ein!"

Export-Clixml -InputObject $Cred -Path "C:\Users\$env:Username\Documents\WindowsPowerShell\cred.xml"