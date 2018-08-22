To inject the Powershell.reg and Background_Powershell.reg files you must first make Administrators
have full access rights in the registry for the relevant registrykeys. Also for the Ubuntu stuff.

Also it doesn't work just by injecting the regkeys. Because they add and change regvalues but don't
remove any. In particular the Extended value.