function Send-LockpathLogin {
    [CmdletBinding(SupportsShouldProcess)]
    [OutputType([string])]
    [Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSShouldProcess', '', Justification = 'Methods called within here make use of PSShouldProcess, and the switch is passed on to them inherently.')]

    param()

    Write-InvocationLog

    $credential = Get-LockpathAuthentication
    $hashBody = @{ }
    $hashBody = [ordered]@{
        'username' = $credential.username
        'password' = $credential.GetNetworkCredential().Password
    }

    $params = @{ }
    $params = @{
        'UriFragment' = 'SecurityService/Login'
        'Method'      = 'POST'
        'Description' = "Sending login to $($script:configuration.instanceName) with Username $($credential.username) and Password: [redacted]"
        'Body'        = (ConvertTo-Json -InputObject $hashBody)
    }

    return Invoke-LockpathRestMethod @params
}
