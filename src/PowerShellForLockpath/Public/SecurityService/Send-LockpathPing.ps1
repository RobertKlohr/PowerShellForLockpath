function Send-LockpathPing {
    <#
    .SYNOPSIS
        Refreshes a valid session.
    .DESCRIPTION
        Refreshes a valid session.
    .EXAMPLE
        Send-LockpathPing
    .INPUTS
        None.
    .OUTPUTS
        System.String
    .NOTES
        The authentication account must have access to the API.
    .LINK
        https://github.com/RobertKlohr/PowerShellForLockpath
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
        $result = Invoke-LockpathRestMethod @params -Confirm:$false
        return $result
    } else {
        Write-LockpathLog -Message "$($PSCmdlet.CommandRuntime.ToString()) ShouldProcess confirmation was denied." -Level Verbose -Confirm:$false -WhatIf:$false
    }
}
