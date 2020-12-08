function Send-LockpathPing {
    <#
    .SYNOPSIS
        Refreshes a valid session.

    .DESCRIPTION
        Refreshes a valid session.

        The Git repo for this module can be found here: https://github.com/RobertKlohr/PowerShellForLockpath

    .EXAMPLE
        Send-LockpathPing

    .INPUTS
        None.

    .OUTPUTS
        String

    .NOTES
        Native API Request: https://[InstanceName]:[InstancePort]/SecurityService/Ping

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

    Write-LockpathInvocationLog -Confirm:$false -WhatIf:$false -Service SecurityService

    $params = @{
        'UriFragment' = 'SecurityService/Ping'
        'Method'      = 'GET'
        'Description' = "Sending Ping API request to $($Script:LockpathConfig.instanceName) to extend session."
    }

    if ($PSCmdlet.ShouldProcess("Refresh session for: $($Script:LockpathConfig.instanceName)", $($Script:LockpathConfig.instanceName), 'Refresh session for:')) {
        [String] $result = Invoke-LockpathRestMethod @params -Confirm:$false
        return $result
    } else {
        Write-LockpathLog -Confirm:$false -WhatIf:$false -Message 'ShouldProcess confirmation was denied.' -Level Verbose -FunctionName ($PSCmdlet.CommandRuntime.ToString()) -Service ReportService
    }
}
