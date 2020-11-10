function Send-LockpathLogin {
    <#
    .SYNOPSIS
        Creates an active session.

    .DESCRIPTION
        Creates an active session.

        The Git repo for this module can be found here: https://github.com/RobertKlohr/PowerShellForLockpath

    .EXAMPLE
        Send-LockpathLogin

    .INPUTS
        None.

    .OUTPUTS
        String

    .NOTES
        Native API Request: https://[InstanceName]:[InstancePort]/SecurityService/Login

        The authentication account must have access to the API.

    .LINK
        https://github.com/RobertKlohr/PowerShellForLockpath/wiki
    #>

    [CmdletBinding(
        ConfirmImpact = 'Low',
        PositionalBinding = $false,
        SupportsShouldProcess = $true)]
    [OutputType('System.String')]

    param()

    Write-LockpathInvocationLog -Confirm:$false -WhatIf:$false

    $credential = Read-LockpathCredential
    $hashBody = [ordered]@{
        'username' = $credential.username
        'password' = $credential.GetNetworkCredential().Password
    }

    $params = @{
        'UriFragment' = 'SecurityService/Login'
        'Method'      = 'POST'
        'Description' = "Sending login to $($script:configuration.instanceName) with Username $($credential.username) and Password: <redacted>"
        'Body'        = (ConvertTo-Json -Depth $script:configuration.jsonConversionDepth -Compress -InputObject $hashBody)
    }

    if ($PSCmdlet.ShouldProcess("Login to: $([environment]::NewLine) $($script:configuration.instanceName)", $script:configuration.instanceName, 'Login to:')) {
        [String] $result = Invoke-LockpathRestMethod @params -Confirm:$false
        return $result
    } else {
        Write-LockpathLog -Message "$($PSCmdlet.CommandRuntime.ToString()) ShouldProcess confirmation was denied." -Level Verbose -Confirm:$false -WhatIf:$false
    }
}
