function Send-LockpathLogout {
    [CmdletBinding()]
    [OutputType([Boolean])]

    param()

    Write-InvocationLog

    $params = @{ }
    $params = @{
        'UriFragment' = 'SecurityService/Logout'
        'Method'      = 'GET'
        'Description' = "Sending logout to $($script:configuration.instanceName)"
    }

    return Invoke-LockpathRestMethod @params
}
