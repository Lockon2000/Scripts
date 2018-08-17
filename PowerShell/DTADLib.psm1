$cred = Import-Clixml -Path C:\Users\mabdelwahab\Arbeit\Administration\cred.xml


function Get-Clients {
    param([string[]]$Department="all", [string]$PCType="all", [string[]]$Exclude)
    [System.Collections.ArrayList]$list = @()

    if ("all" -in $Department) {
        foreach ($file in (dir 'C:\Users\mabdelwahab\Arbeit\Administration\PowerShell Clients')) {
            $dep = $file.name.Substring(7,$file.name.Length-11)
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
            foreach ($pc in (Get-Content "C:\Users\mabdelwahab\Arbeit\Administration\PowerShell Clients\Clients$dep.txt")) {
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

New-Alias gcli -Value Get-Clients


Export-ModuleMember -Variable * -Function * -Alias *