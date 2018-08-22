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
        return (New-PSSession -ComputerName (Get-Clients -Department $Department -PCType "d" -Exclude $Exclude) -Credential $cred.admin.desktop) +
               (New-PSSession -ComputerName (Get-Clients -Department $Department -PCType "l" -Exclude $Exclude) -Credential $cred.admin.laptop)
    }
}

function Invoke-ClientCommand {
    if ($args.Length -eq 0) {
        Write-Host "Gib ein Cmdlet ein!!"
    } else {
        if (Test-Path Variable:global:sess) {
            $cmd = [ScriptBlock]::Create($args)
            Invoke-Command -Session $sess -ScriptBlock $cmd
        } else {
            Write-Host "Du hast keine Session (sess) definiert!"
            $ncsnArgs = @{}

            $temp = Read-Host "Welche Abteilungen? (Standard `"all`"):" 
            if ($temp.Length -ne 0) {
                $ncsnArgs.Department = $temp                
            }

            $temp = Read-Host "Desktops oder Laptops? (Standard `"all`"):" 
            if ($temp.Length -ne 0) {
                $ncsnArgs.PCType = $temp                
            }

            $temp = Read-Host "Möchtest du was Ausschließen? (Standard None):"
            if ($temp.Length -eq 0) {
                $ncsnArgs.Exclude = $temp
            }

            $global:sess = New-ClientSession @ncsnArgs
            $cmd = [ScriptBlock]::Create($args)
            Invoke-Command -Session $sess -ScriptBlock $cmd
        }
    }
}


New-Alias gcli -Value Get-Clients
New-Alias ncsn -Value New-ClientSession
New-Alias iccm -Value Invoke-ClientCommand


Export-ModuleMember -Variable * -Function * -Alias *