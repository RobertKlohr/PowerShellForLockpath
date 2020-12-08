function Send-LockpathLogin {
    <#
    .SYNOPSIS
        Creates an active session.

    .DESCRIPTION
        Creates an active session.

        The Git repo for this module can be found here: https://github.com/RobertKlohr/PowerShellForLockpath

    .PARAMETER KeepAlive
        After a successful login starts Send-LockpathPing as a background job that runs based on value of the parameter.

        The default interval of the background job is set in minutes by using Set-LockpathConfiguration -KeepAlive 60.

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

    param(
        [Switch] $KeepAlive
    )

    Write-LockpathInvocationLog -Service SecurityService

    $credential = Import-LockpathCredential
    $hashBody = [ordered]@{
        'username' = $credential.username
        'password' = $credential.GetNetworkCredential().Password
    }

    $params = @{
        'UriFragment' = 'SecurityService/Login'
        'Method'      = 'POST'
        'Description' = "Sending login to $($Script:LockpathConfig.instanceName) with Username $($credential.username) and Password: <redacted>"
        'Body'        = (ConvertTo-Json -Depth $Script:LockpathConfig.jsonConversionDepth -Compress -InputObject $hashBody)
    }

    if ($PSCmdlet.ShouldProcess("Login to: $([environment]::NewLine) $($Script:LockpathConfig.instanceName)", $Script:LockpathConfig.instanceName, 'Login to:')) {
        [String] $result = Invoke-LockpathRestMethod @params -Login -Confirm:$false
        if ($KeepAlive) {
            Send-LockpathKeepAlive
        }
        return $result
    } else {
        Write-LockpathLog -Message "$($PSCmdlet.CommandRuntime.ToString()) ShouldProcess confirmation was denied." -Level Verbose -Service SecurityService
    }
}
