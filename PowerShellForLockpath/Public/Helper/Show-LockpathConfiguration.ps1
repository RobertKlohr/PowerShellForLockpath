function Show-LockpathConfiguration {
    <#
    .SYNOPSIS
        Shows the current module configuration.

    .DESCRIPTION
        Shows the current module configuration.

        By default returns the configuration for this session.  This may not be different than the configuration
        saved to file if the session configuration was updated using Set-LockpathConfiguration -SessionOnly.

        The Git repo for this module can be found here: https://github.com/RobertKlohr/PowerShellForLockpath

    .PARAMETER Saved
        Shows the configuration saved to file instead of the session configuration.

    .EXAMPLE
        Show-LockpathConfiguration

        By default, this method will show the configuration in memory for this session.

    .EXAMPLE
        Show-LockpathConfiguration -Persisted

        Gets the configuration saved to file and show that configuration.

    .INPUTS
        None.

    .OUTPUTS
        String

    .NOTES
        Public helper method.

    .LINK
        https://github.com/RobertKlohr/PowerShellForLockpath/wiki
    #>

    [CmdletBinding(
        ConfirmImpact = 'Low',
        PositionalBinding = $false,
        SupportsShouldProcess = $true)]
    [OutputType('System.String')]

    [Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSShouldProcess', '', Justification = 'Methods called within here make use of PSShouldProcess, and the switch is passed on to them inherently.')]

    param(
        [Switch] $Saved,

        [IO.FileInfo] $FilePath = $Script:configuration.configurationFilePath
    )

    Write-LockpathInvocationLog -Confirm:$false -WhatIf:$false

    if ($Saved) {
        Read-LockpathConfiguration -FilePath $FilePath

    } else {
        return $Script:configuration
    }
}
