$cred = Import-Clixml -Path C:\Users\mabdelwahab\Arbeit\Administration\cred.xml


function Get-Clients {
    param([string[]]$Department="all", [string]$PCType="all", [string[]]$Exclude)
    [System.Collections.ArrayList]$list = @()

    if ("all" -in $Department) {
        foreach ($file in (dir '\\odin\it\admin\Skripte\PowerShell Clients')) {
            $dep = $file.name[7..($file.name.Length-5)] -join ""
            if ($dep -notin $Exclude) {
                foreach ($pc in (Get-Content $file.FullName)) {
                    $pc = $pc -split " "

                    if ($pc[0] -notin $Exclude) {
                        if ($PCType -eq "all") {
                            $list += $pc[0]
                        } else {
                            if ($pc[1] -eq $PCType) {
                                $list += $pc[0]
                            }
                        }
                    }
                }
            }
        }
    } else {
        foreach ($dep in $Department) {
            foreach ($pc in (Get-Content "\\odin\it\admin\Skripte\PowerShell Clients\Clients$dep.txt")) {
                $pc = $pc -split " "

                if ($pc[0] -notin $Exclude) {
                    if ($PCType -eq "all") {
                        $list += $pc[0]
                    } else {
                        if ($pc[1] -eq $PCType) {
                            $list += $pc[0]
                        }
                    }
                }
            }
        }
    }

    return $list
}

function New-ClientSession {
    param([string[]]$Department="all", [string]$PCType="all", [string[]]$Exclude)

    if ($PCType -eq "all") {
        $Desktops = Get-Clients -Department $Department -PCType "d" -Exclude $Exclude
        $Laptops = Get-Clients -Department $Department -PCType "l" -Exclude $Exclude

        if (($Desktops.Length -ne 0) -and ($Laptops.Length -ne 0)) {
            return (New-PSSession -ComputerName $Desktops -Credential $cred.admin.desktop) + (New-PSSession -ComputerName $Laptops -Credential $cred.admin.laptop)
        } elseif ($Desktops.Length -ne 0) {
            return (New-PSSession -ComputerName $Desktops -Credential $cred.admin.desktop)
        } else {
            return (New-PSSession -ComputerName $Laptops -Credential $cred.admin.laptop)
        }

    }
}

function New-NamedClientSession {
    param([string[]]$Department="all", [string]$PCType="all", [string[]]$Exclude)

    $global:sess = New-ClientSession -Department $Department -PCType $PCType -Exclude $Exclude
    Write-Host "Eine neue Remote Session wurde hergestellt und in der Variable `"sess`" gespeichert."
}

function Invoke-ClientCommand {
    if ($args.Length -eq 0) {
        Write-Host "Gib einen Ausdruck ein!!"
    } else {
        if (Test-Path Variable:global:sess) {
            $cmd = [ScriptBlock]::Create($args)
            Invoke-Command -Session $sess -ScriptBlock $cmd
        } else {
            Write-Host "Du hast keine Session (sess) definiert!"
            $ncsnArgs = @{}

            $temp = Read-Host "Welche Abteilungen? (Gib eine Komma-separierte List an! - Standard `"all`"):" 
            if ($temp.Length -ne 0) {
                $ncsnArgs.Department = $temp -split ","
            }

            $temp = Read-Host "Desktops oder Laptops? (Standard `"all`"):" 
            if ($temp.Length -ne 0) {
                $ncsnArgs.PCType = $temp
            }

            $temp = Read-Host "Möchtest du was Ausschließen? (Gib eine Komma-separierte List an! - Standard `"None`"):"
            if ($temp.Length -ne 0) {
                $ncsnArgs.Exclude = $temp -split ","
            }

            $global:sess = New-ClientSession @ncsnArgs
            $cmd = [ScriptBlock]::Create($args)
            Invoke-Command -Session $sess -ScriptBlock $cmd
        }
    }
}

function Invoke-StructuredClientCommand {
    if ($args.Length -eq 0) {
        Write-Host "Gib einen Ausdruck ein!!"
    } else {
        Invoke-ClientCommand ([string]$args) | Sort -Property PSComputerName | Format-Table -GroupBy PSComputerName
    }
}


New-Alias gcli -Value Get-Clients
New-Alias ncsn -Value New-ClientSession
New-Alias nncsn -Value New-NamedClientSession
New-Alias iccm -Value Invoke-ClientCommand
New-Alias isccm -Value Invoke-StructuredClientCommand


Export-ModuleMember -Variable * -Function * -Alias *