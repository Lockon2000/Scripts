function ToArray {
    param($Arraylike)

    [system.collections.arraylist]$a = @()
    foreach ($b in $Arraylike){
        [void]$a.add($b)
    }
    return $a
}


function Elevate-PSSession {
    param([switch]$Preserve)

    $CurrentlyAdmin = (New-Object Security.Principal.WindowsPrincipal $([Security.Principal.WindowsIdentity]::GetCurrent())).IsInRole([Security.Principal.WindowsBuiltinRole]::Administrator)
    
    if (-Not $CurrentlyAdmin)
    {
        Start-Process powershell.exe -Verb runAs
        if (-not $Preserve) {
            Exit
        }
    } else {
        Write-Output "You have already Admin Privileges"
    }
}


function Write-Color([String[]]$Text, [ConsoleColor[]]$Color) {
    for ($i = 0; $i -lt $Text.Length; $i++) {
        Write-Host $Text[$i] -Foreground $Color[$i] -NoNewLine
    }
}