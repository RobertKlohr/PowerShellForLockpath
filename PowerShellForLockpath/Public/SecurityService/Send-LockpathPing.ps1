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

    # [string] $functionName = $MyInvocation.MyCommand

    # Write-Debug -Message "Debug $functionName" -

    # Write-Error -Message "Error $functionName"

    # Write-Warning -Message "Warning $functionName"

    # Write-Verbose -Message "Verbose $functionName"

    # Write-Information -MessageData "Verbose $functionName"

    Write-LockpathInvocationLog -Confirm:$false -WhatIf:$false

    $params = @{
        'UriFragment' = 'SecurityService/Ping'
        'Method'      = 'GET'
        'Description' = "Sending Ping API request to $($Script:configuration.instanceName) to extend session."
    }

    # if ($PSCmdlet.ShouldProcess("Refresh session for: $([environment]::NewLine) $($Script:configuration.instanceName)", $($Script:configuration.instanceName), 'Refresh session for:')) {
    if ($PSCmdlet.ShouldProcess("Refresh session for: $($Script:configuration.instanceName)", $($Script:configuration.instanceName), 'Refresh session for:')) {
        [String] $result = Invoke-LockpathRestMethod @params -Confirm:$false
        Write-Information $result
        return
    } else {
        Write-LockpathLog -Message "$($PSCmdlet.CommandRuntime.ToString()) ShouldProcess confirmation was denied." -Level Verbose -Confirm:$false -WhatIf:$false
    }
}
