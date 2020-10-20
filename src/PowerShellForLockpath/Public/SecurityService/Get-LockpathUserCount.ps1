function Get-LockpathUserCount {
    [CmdletBinding(
        ConfirmImpact = 'Low',
        PositionalBinding = $false,
        SupportsShouldProcess = $true)]
    [OutputType('System.Int32')]
    [Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSShouldProcess', '', Justification = 'Methods called within here make use of PSShouldProcess, and the switch is passed on to them inherently.')]

    param(
        [array] $Filter = $null
    )

    # Filter Syntax an array of hashtables
    # (@{Shortname = "AccountType"; FilterType = 5; Value = 1 }, @{ Shortname = "Deleted"; FilterType = 5; Value = "true" })

    $filterString = $null

    #FIXME do I need the {} below around the $FILTER variable?
    if (${$Filter}) {
        $fieldCount = 0
        $filterString = '['
        foreach ($filterField in $Filter) {
            $fieldCount++
            $filterString = $filterString + '{"Field":{"ShortName":"' + $filterField.ShortName + '"},' + '"FilterType":"' + $filterField.FilterType + '",' + '"Value":"' + $filterField.Value + '"}'
            if ($fieldCount -ne $Filter.Count) {
                $filterString = $filterString + ','
            }
            $filterString = $filterString + "]"
        }
    }

    Write-LockpathInvocationLog

    $params = @{ }
    $params = @{
        'UriFragment' = 'SecurityService/GetUserCount'
        'Method'      = 'POST'
        'Description' = "Getting User Count with Filter: $filterString"
        'Body'        = $filterString
    }

    $result = Invoke-LockpathRestMethod @params

    return $result
}
