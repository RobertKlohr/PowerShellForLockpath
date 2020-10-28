function Read-LockpathCredential {
    #FIXME Update to new coding standards

    <#
    .SYNOPSIS
        Gets the API credentials for use in the rest of the module.

    .DESCRIPTION
        Gets the API credentials for use in the rest of the module.

        The Git repo for this module can be found here: https://github.com/RobertKlohr/PowerShellForLockpath

    .PARAMETER Path
        Path to the file storing the API credentials. If not provided defaults to the path in the configuration file.

    .INPUTS
        System.String

    .OUTPUTS
        System.String

    .NOTES
        Internal-only helper method.

    .LINK
        https://github.com/RobertKlohr/PowerShellForLockpath/wiki
    #>
    [CmdletBinding(
        ConfirmImpact = 'Low',
        PositionalBinding = $false,
        SupportsShouldProcess = $true)]

    [Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSShouldProcess', '', Justification = 'Methods called within here make use of PSShouldProcess, and the switch is passed on to them inherently.')]

    param(
        [string] $Path
    )

    Write-LockpathInvocationLog

    $content = Import-Clixml -Path $Path -ErrorAction Ignore

    if (-not [String]::IsNullOrEmpty($content)) {
        try {
            $accessCredentials = New-Object System.Management.Automation.PSCredential $content.Username, $content.Password
            Write-LockpathLog -Message 'Restoring login credentials from file.  These values can be cleared by calling Remove-LockpathCredential.' -Level Verbose
            return $accessCredentials
        } catch {
            Write-LockpathLog -Message 'The configuration file for this module is in an invalid state.  Use Reset-LockpathConfiguration to recover.' -Level Warning
        }
    }
}
