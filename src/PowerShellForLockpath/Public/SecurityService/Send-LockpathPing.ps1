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
        'UriFragment' = 'SecurityService/Ping'
        'Method'      = 'GET'
        'Description' = "Sending Ping API call to $($script:configuration.instanceName) to keep session alive."
    }

    if ($PSCmdlet.ShouldProcess("Refresh session for: $([environment]::NewLine) $($script:configuration.instanceName)", $($script:configuration.instanceName), 'Refresh session for:')) {
        [String] $result = Invoke-LockpathRestMethod @params -Confirm:$false
        return $result
    } else {
        Write-LockpathLog -Message "$($PSCmdlet.CommandRuntime.ToString()) ShouldProcess confirmation was denied." -Level Verbose -Confirm:$false -WhatIf:$false
    }
}
