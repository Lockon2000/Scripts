function ToArray {
    param($Arraylike)

    [system.collections.arraylist]$a = @()
    foreach ($b in $Arraylike){
        [void]$a.add($b)
    }
    return $a
}
