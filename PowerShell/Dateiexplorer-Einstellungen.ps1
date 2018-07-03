$ExplorerAdvancedKey = 'HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced'
$ExplorerCabinetStateKey = 'HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\CabinetState\'
Set-ItemProperty $ExplorerAdvancedKey Hidden 1
Set-ItemProperty $ExplorerAdvancedKey HideFileExt 0
Set-ItemProperty $ExplorerAdvancedKey ShowSuperHidden 1
Set-ItemProperty $ExplorerAdvancedKey HideDrivesWithNoMedia 0
Set-ItemProperty $ExplorerAdvancedKey SeparateProcess 1
Set-ItemProperty $ExplorerAdvancedKey PersistBrowsers 1
Set-ItemProperty $ExplorerAdvancedKey NavPaneShowAllFolders 1
Set-ItemProperty $ExplorerAdvancedKey NavPaneExpandToCurrentFolder 1
Set-ItemProperty $ExplorerCabinetStateKey FullPath 1

Write-Output "Registrykeys wurden geändert!"
Read-Host -Prompt "Drücke Enter um zu beenden..."