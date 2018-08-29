$Cred = Import-Clixml -Path "C:\Users\$env:Username\Documents\WindowsPowerShell\cred.xml"
$CredAdminDesktop = $Cred.Admin.Desktop
$CredAdminLaptop = $Cred.Admin.Laptop
$CredUser = $Cred.User

Remove-Variable Cred


function Get-Client {
    param([string[]]$Include="all", [ValidateSet("all","d","l")] [string]$PCType="all", [string[]]$Exclude, [switch]$ReturnPCObj)
    [System.Collections.ArrayList]$List = @()
    if (-not (Test-Path variable:Departments)) {
        $Departments = (Dir "\\odin\it\admin\Skripte\PowerShell Clients" | Foreach-Object {($_.name[7..($_.name.Length-5)] -join "").ToLower()})
    }

    if ("all" -in $Include) {
        foreach ($File in (Dir '\\odin\it\admin\Skripte\PowerShell Clients')) {
            $Department = $File.Name[7..($File.Name.Length-5)] -join ""
            if ($Department -notin $Exclude) {
                foreach ($Line in (Get-Content $File.Fullname)) {
                    $Line = $Line.split("|")
                    $PC = @{Name=$Line[0]; MAC=$Line[1]; Type=$Line[2]}

                    if ($PC.Name -notin $Exclude) {
                        if ($PCType -eq "all") {
                            if ($ReturnPCObj) {
                                [void]$List.Add($PC)
                            } else {
                                [void]$List.Add($PC.Name)
                            }
                        } else {
                            if ($PC.Type -eq $PCType) {
                                if ($ReturnPCObj) {
                                    [void]$List.Add($PC)
                                } else {
                                    [void]$List.Add($PC.Name)
                                }
                            }
                        }
                    }
                }
            }
        }
    } else {
        foreach ($DepartmentOrPC in $Include) {
            if ($DepartmentOrPC -in $Departments) {
                if ($DepartmentOrPC -notin $Exclude) {
                    foreach ($Line in (Get-Content "\\odin\it\admin\Skripte\PowerShell Clients\Clients$DepartmentOrPC.txt")) {
                        $Line = $Line.split("|")
                        $PC = @{Name=$Line[0]; MAC=$Line[1]; Type=$Line[2]}

                        if ($PC.Name -notin $Exclude) {
                            if ($PCType -eq "all") {
                                if ($ReturnPCObj) {
                                    [void]$List.Add($PC)
                                } else {
                                    [void]$List.Add($PC.Name)
                                }
                            } else {
                                if ($PC.Type -eq $PCType) {
                                    if ($ReturnPCObj) {
                                        [void]$List.Add($PC)
                                    } else {
                                        [void]$List.Add($PC.Name)
                                    }
                                }
                            }
                        }
                    }
                }
            } else {
                if ($DepartmentOrPC -notin $Exclude) {
                    foreach ($PC in (Get-Client -ReturnPCObj)) {
                        if ($PC.Name -eq $DepartmentOrPC) {
                            if ($PCType -eq "all") {
                                if ($ReturnPCObj) {
                                    [void]$List.Add($PC)
                                } else {
                                    [void]$List.Add($PC.Name)
                                }
                            } else {
                                if ($PC.Type -eq $PCType) {
                                    if ($ReturnPCObj) {
                                        [void]$List.Add($PC)
                                    } else {
                                        [void]$List.Add($PC.Name)
                                    }
                                }
                            }
                            break
                        }
                    }
                }
            }
        }
    }

    return $List
}

function Enter-ClientSession {
    param([Parameter(Mandatory=$true)] [string]$PCName)

    $PC = Get-Client $PCName -ReturnPCObj
    if ($PC.Type -eq "d") {
        Enter-PSSession $PC.Name -Credential $CredAdminDesktop
    } else {
        Enter-PSSession $PC.Name -Credential $CredAdminLaptop
    }
}

function New-ClientSession {
    param([Parameter(Mandatory=$true)] [string[]]$Include, [ValidateSet("all","d","l")] [string]$PCType="all", [string[]]$Exclude, [switch]$Silent)

    if ($PCType -eq "all") {
        $Desktops = Get-Client -Include $Include -PCType "d" -Exclude $Exclude
        $Laptops = Get-Client -Include $Include -PCType "l" -Exclude $Exclude

        if (($Desktops.Count -ne 0) -and ($Laptops.Count -ne 0)) {
            $DesktopSessions = New-PSSession -ComputerName $Desktops -Credential $CredAdminDesktop
            $LaptopSessions = New-PSSession -ComputerName $Laptops -Credential $CredAdminLaptop

            $DesktopSessions + $LaptopSessions
        } elseif ($Desktops.Count -ne 0) {
            $DesktopSessions = New-PSSession -ComputerName $Desktops -Credential $CredAdminDesktop

            $DesktopSessions
        } else {
            $LaptopSessions = New-PSSession -ComputerName $Laptops -Credential $CredAdminLaptop

            $LaptopSessions
        }
    } elseif ($PCType -eq "d") {
        $Desktops = Get-Client -Include $Include -PCType "d" -Exclude $Exclude

        if ($Desktops.Count -ne 0) {
            $DesktopSessions = New-PSSession -ComputerName $Desktops -Credential $CredAdminDesktop

            $DesktopSessions
        }
    } else {
        $Laptops = Get-Client -Include $Include -PCType "l" -Exclude $Exclude

        if ($Laptops.Count -ne 0) {
            $LaptopSessions = New-PSSession -ComputerName $Laptops -Credential $CredAdminLaptop

            $LaptopSessions
        }
    }

    if (-not $Silent) {
        if ($DesktopSessions.Count + $LaptopSessions.Count -eq 0) {
            Write-Host "Keine der angegebenen Remote Session konnte hergestellt werden!!"
        } else {
            Write-Host "$($DesktopSessions.Count + $LaptopSessions.Count) neue Remote Session wurde\n hergestellt und in der Variable `"sess`" gespeichert."
        }
    }

    return
}

function New-NamedClientSession {
    param([Parameter(Mandatory=$true)] [string[]]$Include, [ValidateSet("all","d","l")] [string]$PCType="all", [string[]]$Exclude)

    $global:sess = New-ClientSession -Include $Include -PCType $PCType -Exclude $Exclude -Silent

    if ($sess.Count -eq 0) {
        Write-Host "Keine der angegebenen Remote Session konnte hergestellt werden!!"
    } else {
        Write-Host "$($sess.Count) neue Remote Session wurde\n hergestellt und in der Variable `"sess`" gespeichert."
    }
}

function Invoke-ClientCommand {
    param([Parameter(Position=0,ValueFromRemainingArguments=$true)] [string]$CmdInput, [string[]]$Include, [switch]$Assert)
    if ($CmdInput.Length -eq 0) {
        Write-Host "Gib einen Ausdruck ein!!"
        return
    } else {
        $Cmd = [ScriptBlock]::Create($CmdInput)
        [System.Collections.ArrayList]$global:producedOutput = @()
        [System.Collections.ArrayList]$global:producedNoOutput = @()
        New-Variable IncludeResolved -Scope Script -Force

        if (Test-Path Variable:global:sess) {
            if ($Include.Count -ne 0) {
                $script:IncludeResolved = Get-Client -Include $Include | Where {$_ -in ($sess).ComputerName}
                $NarrowedSession = Get-PSSession | Where ComputerName -in $IncludeResolved
                if ($NarrowedSession.Count -eq 0) {
                    Write-Host "Nach Filterung sind keine PCs mehr übrig geblieben!!"

                    if ($Assert) {
                        Assert-SuccessClientCommand -NumberOfContactedPCs 0
                    }

                    return
                }
                ($Output = Invoke-Command -Session $NarrowedSession -ScriptBlock $Cmd)
                foreach ($PC in $IncludeResolved) {
                    if ($PC -in $Output.PSComputerName) {
                        [void]$global:producedOutput.Add($PC)
                    } else {
                        [void]$global:producedNoOutput.Add($PC)
                    }
                }
            } else {
                ($Output = Invoke-Command -Session $sess -ScriptBlock $Cmd)
                foreach ($PC in $sess.ComputerName) {
                    if ($PC -in $Output.PSComputerName) {
                        [void]$global:producedOutput.Add($PC)
                    } else {
                        [void]$global:producedNoOutput.Add($PC)
                    }
                }
            }
        } else {
            Write-Host "Du hast keine Session (sess) definiert!"
            $ncsnArgs = @{}

            $temp = Read-Host "Welche Abteilungen? (Gib eine Komma-separierte List an! - Standard `"all`"):" 
            if ($temp.Length -ne 0) {
                $ncsnArgs.Include = $temp -split ","
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

            if ($Include.Count -ne 0) {
                $script:IncludeResolved = Get-Client -Include $Include | Where {$_ -in ($sess).ComputerName}
                $NarrowedSession = Get-PSSession | Where ComputerName -in $IncludeResolved
                if ($NarrowedSession.Count -eq 0) {
                    Write-Host "Nach Filterung sind keine PCs mehr übrig geblieben!!"

                    if ($Assert) {
                        Assert-SuccessClientCommand -NumberOfContactedPCs 0
                    }

                    return
                }
                ($Output = Invoke-Command -Session $NarrowedSession -ScriptBlock $Cmd)
                foreach ($PC in $IncludeResolved) {
                    if ($PC -in $Output.PSComputerName) {
                        [void]$global:producedOutput.Add($PC)
                    } else {
                        [void]$global:producedNoOutput.Add($PC)
                    }
                }
            } else {
                ($Output = Invoke-Command -Session $sess -ScriptBlock $Cmd)
                foreach ($PC in $sess.ComputerName) {
                    if ($PC -in $Output.PSComputerName) {
                       [void]$global:producedOutput.Add($PC)
                    } else {
                        [void]$global:producedNoOutput.Add($PC)
                    }
                }
            }
        }
    }

    if ($Assert) {
        if ($Include.Count -ne 0) {
            Assert-SuccessClientCommand -NumberOfContactedPCs $IncludeResolved.Count
        } else {
            Assert-SuccessClientCommand -NumberOfContactedPCs $sess.Count
        }
    }
    return
}

function Invoke-StructuredClientCommand {
    param([Parameter(Position=0,ValueFromRemainingArguments=$true)] [string]$CmdInput, [string[]]$Include, [switch]$Assert)
    if ($CmdInput.Length -eq 0) {
        Write-Host "Gib einen Ausdruck ein!!"
    } else {
        $Outputs = Invoke-ClientCommand -Include $Include $CmdInput | Group-Object -Property PSComputerName
        foreach ($Output in $Outputs) {
            $PCName = $Output.Name
            Write-Output "`nErgebnisse von PC: $PCName"
            $Output | Select -ExpandProperty Group | Out-Default
        }
    }

    if ($Assert) {
        if ($Include.Count -ne 0) {
            Assert-SuccessClientCommand -NumberOfContactedPCs $IncludeResolved.Count
        } else {
            Assert-SuccessClientCommand -NumberOfContactedPCs $sess.Count
        }
    }
    return
}

function Remove-ClientSession {
    $sess | Remove-PSSession
    Remove-Variable sess -Scope Global
}

function Assert-SuccessClientCommand {
    param([Int]$NumberOfContactedPCs)
    if ($NumberOfContactedPCs -eq 0) {
        Write-Host "`nEs wurden keine Hosts kontaktiert!"
    } elseif ($producedOutput.Count -eq $NumberOfContactedPCs) {
        Write-Host "`nAlle angegebenen Remote PCs haben Output produziert!"
    } else {
        Write-Host "`nFolgende PCs haben keinen Output produziert:"
        Write-Host "$producedNoOutput"
    }
}


New-Alias gcli  -Value Get-Client
New-Alias etcsn -Value Enter-ClientSession
New-Alias ncsn  -Value New-ClientSession
New-Alias nncsn -Value New-NamedClientSession
New-Alias iccm  -Value Invoke-ClientCommand
New-Alias isccm -Value Invoke-StructuredClientCommand
New-Alias rmcsn -Value Remove-ClientSession
New-Alias asccm -Value Assert-SuccessClientCommand


Export-ModuleMember -Variable * -Function * -Alias *