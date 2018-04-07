function Write-Color([String[]]$Text, [ConsoleColor[]]$Color) {
    for ($i = 0; $i -lt $Text.Length; $i++) {
        Write-Host $Text[$i] -Foreground $Color[$i] -NoNewLine
    }
}

function prompt {
    Write-Color -Text $env:username, "@", $env:computername, " ", (get-location), "`n" -Color Red,DarkCyan,Yellow,White,Green,White
    "PS> "
}

New-Alias -Name sublime -Value "C:\Program Files\Sublime Text 3\sublime_text.exe"