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
        'Method'      = 'Post'
        'Body'        = (ConvertTo-Json -InputObject $hashBody)
        'Description' = "Login to $($script:configuration.instanceName) with $($credential.username)"
    }
    Invoke-LockpathRestMethod @params

    Write-InvocationLog
}
