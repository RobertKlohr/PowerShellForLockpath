function Get-LockpathUserCount {
    [CmdletBinding(SupportsShouldProcess)]
    [OutputType([int])]
    [Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSShouldProcess', '', Justification = 'Methods called within here make use of PSShouldProcess, and the switch is passed on to them inherently.')]

    param(
        [array] $Filter = $null
    )

    Write-LockpathInvocationLog

    $params = @{ }
    $params = @{
        'UriFragment' = 'SecurityService/GetUserCount'
        'Method'      = 'POST'
        'Description' = "Getting User Count with Filter: $Filter"
        'Body'        = '' #$Filter | ConvertTo-Json
    }

    $result = Invoke-LockpathRestMethod @params

    return $result
}
