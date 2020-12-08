function Send-LockpathLogout {
    <#
    .SYNOPSIS
        Terminates the active session.

    .DESCRIPTION
        Terminates the active session.

        The Git repo for this module can be found here: https://github.com/RobertKlohr/PowerShellForLockpath

    .EXAMPLE
        Send-LockpathLogout

    .INPUTS
        None.

    .OUTPUTS
        String

    .NOTES
        Native API Request: https://[InstanceName]:[InstancePort]/SecurityService/Logout

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

    Write-LockpathInvocationLog -Service SecurityService

    $params = @{
        'UriFragment' = 'SecurityService/Logout'
        'Method'      = 'GET'
        'Description' = "Sending logout to $($Script:LockpathConfig.instanceName)"
    }

    if ($PSCmdlet.ShouldProcess("Logout from: $([environment]::NewLine) $($Script:LockpathConfig.instanceName)", $($Script:LockpathConfig.instanceName), 'Logout from:')) {
        [String] $result = Invoke-LockpathRestMethod @params -Confirm:$false
        return $result
    } else {
        Write-LockpathLog -Message "$($PSCmdlet.CommandRuntime.ToString()) ShouldProcess confirmation was denied." -Level Verbose -Service ReportService
    }
}
