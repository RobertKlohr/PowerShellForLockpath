function Read-LockpathAuthenticationCookie {
    <#
    .SYNOPSIS
        Attempts to read the API authentication cookie saved to the local file system.

    .DESCRIPTION
        Attempts to read the API authentication cookie saved to the local file system.

        The Git repo for this module can be found here: https://github.com/RobertKlohr/PowerShellForLockpath

    .EXAMPLE
        Read-LockpathAuthenticationCookie

    .INPUTS
        IO.FileInfo

    .OUTPUTS
        String

    .NOTES
        Private helper method.

    .LINK
        https://github.com/RobertKlohr/PowerShellForLockpath/wiki
    #>

    [CmdletBinding(
        ConfirmImpact = 'Low',
        PositionalBinding = $false,
        SupportsShouldProcess = $true)]

    [Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSShouldProcess', '', Justification = 'Methods called within here make use of PSShouldProcess, and the switch is passed on to them inherently.')]

    param()

    Write-LockpathInvocationLog -Confirm:$false -WhatIf:$false

    try {
        $cookie = Import-Clixml -Path $Script:configuration.authenticationCookieFilePath
        $Script:configuration.authenticationCookie = $cookie
        return $cookie
    } catch {
        Write-LockpathLog -Message 'Unable to read the authentication cookie from the local file storage.  Use Send-LockpathLogin to reset.' -Level Warning
    }
}
