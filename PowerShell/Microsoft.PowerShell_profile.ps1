Import-Module LockLib 3>$null


New-Alias -Name sublime -Value "C:\Program Files\Sublime Text 3\sublime_text.exe"
New-Alias -Name m -Value more
New-Alias -Name less -Value more


function Prompt {
    Write-Color -Text $env:username, "@", $env:computername, " ", (get-location), "`n" -Color Red,DarkCyan,Yellow,White,Green,White
    "PS> "
}