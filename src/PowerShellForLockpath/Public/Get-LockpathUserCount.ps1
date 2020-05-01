function Get-LockpathUserCount {
    [CmdletBinding(SupportsShouldProcess)]
    [OutputType([int])]
    [Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSShouldProcess', '', Justification = 'Methods called within here make use of PSShouldProcess, and the switch is passed on to them inherently.')]

    param(
        #TODO is string the correct type or should this be a PSCustomObject type?
        [string] $Filter = ''
    )

    Write-LockpathInvocationLog

    $params = @{ }
    $params = @{
        'UriFragment' = 'SecurityService/GetUserCount'
        'Method'      = 'POST'
        'Description' = "Getting User Count with Filter: $Filter"
        'Body'        = $Filter
    }

    $result = Invoke-LockpathRestMethod @params

    return $result
}
