function Group-Pivot {
    <#
        .Example
$data = ConvertFrom-Csv @"
foo,bar,baz,zoo
one,A,1,x
one,B,2,y
one,C,3,z
two,A,4,q
two,B,5,w
two,C,6,t
"@

Group-Pivot -data $data -index foo -columns bar -values baz 

foo A B C
--- - - -
one 1 2 3
two 4 5 6
    #>
    param(
        $data,
        $index,
        $columns,
        $values
    )

    $columnNames = ($data | Group-Object $columns).Name | Sort-Object
    
    $g = $data | Group-Object $index | Sort-Object name

    foreach ($group in $g) {
        
        $h = [ordered]@{}
        
        $h.$index = $group.name
        foreach ($name in $columnNames) { $h.$name = $null }
        foreach ($item in $group.group) {
            if ($null -eq $h.($item.$columns)) {
                $h.($item.$columns) = $item.$values
            }
            else {
                if ($h.($item.$columns) -isnot [array]) {
                    $h.($item.$columns) = @($h.($item.$columns))
                }
                $h.($item.$columns) += $item.$values
            }             
        }
        [pscustomobject]$h
    }
}