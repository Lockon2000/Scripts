function prompt {
    $env:username + "@" + $env:computername + " " + (get-location) + "`n" + "PS> "
}

New-Alias -Name sublime -Value "C:\Program Files\Sublime Text 3\sublime_text.exe"