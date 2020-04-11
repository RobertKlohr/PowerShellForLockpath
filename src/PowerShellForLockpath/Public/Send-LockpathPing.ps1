function Send-LockpathPing {
    [CmdletBinding(SupportsShouldProcess)]
    [OutputType([string])]
    [Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSShouldProcess', '', Justification = 'Methods called within here make use of PSShouldProcess, and the switch is passed on to them inherently.')]

    param()

    Write-InvocationLog

    $params = @{ }
    $params = @{
        'UriFragment' = 'SecurityService/Ping'
        'Method'      = 'GET'
        'Description' = "Sending Ping API call to $($script:configuration.instanceName) to keep session alive."
    }

    return Invoke-LockpathRestMethod @params
}
