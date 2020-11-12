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

    Write-LockpathInvocationLog -Confirm:$false -WhatIf:$false

    $params = @{
        'UriFragment' = 'SecurityService/Logout'
        'Method'      = 'GET'
        'Description' = "Sending logout to $($script:configuration.instanceName)"
    }

    if ($PSCmdlet.ShouldProcess("Logout from: $([environment]::NewLine) $($script:configuration.instanceName)", $($script:configuration.instanceName), 'Logout from:')) {
        [String] $result = Invoke-LockpathRestMethod @params -Confirm:$false
        return $result
        return $result
    } else {
        Write-LockpathLog -Message "$($PSCmdlet.CommandRuntime.ToString()) ShouldProcess confirmation was denied." -Level Verbose -Confirm:$false -WhatIf:$false
    }
}
