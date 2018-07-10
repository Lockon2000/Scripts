function Write-Color([String[]]$Text, [ConsoleColor[]]$Color) {
    for ($i = 0; $i -lt $Text.Length; $i++) {
        Write-Host $Text[$i] -Foreground $Color[$i] -NoNewLine
    }
}

function prompt {
    Write-Color -Text $env:username, "@", $env:computername, " ", (get-location), "`n" -Color Red,DarkCyan,Yellow,White,Green,White
    "PS> "
}

function elevate {
    $CurrentlyAdmin = (New-Object Security.Principal.WindowsPrincipal $([Security.Principal.WindowsIdentity]::GetCurrent())).IsInRole([Security.Principal.WindowsBuiltinRole]::Administrator)
    if (-Not $CurrentlyAdmin)
    {
        Start-Process powershell.exe -Verb runAs
        Exit
    } else {
        Write-Output "You have already Admin Privileges"
    }
}

New-PSDrive -Name HKCR -PSProvider Registry -Root HKEY_CLASSES_ROOT

New-Alias -Name sublime -Value "C:\Program Files\Sublime Text 3\sublime_text.exe"
New-Alias -Name m -Value more
New-Alias -Name less -Value more
