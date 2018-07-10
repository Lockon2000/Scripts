# Creating a HKCR Registry drive
New-PSDrive -Name HKCR -PSProvider Registry -Root HKEY_CLASSES_ROOT