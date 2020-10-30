function Get-LockpathCredential {
    <#
    .SYNOPSIS
        Gets the API credentials for use in the rest of the module.

    .DESCRIPTION
        Gets the API credentials for use in the rest of the module.

        First the will try to use the credential already cached in memory.
        If not found, will look to see if there is a file with the API credential stored
        as a SecureString.

        The Git repo for this module can be found here: https://github.com/RobertKlohr/PowerShellForLockpath

    .EXAMPLE
        Get-LockpathCredential

    .INPUTS
        System.IO.FileInfo

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

    param()

    Write-LockpathInvocationLog -Confirm:$false -WhatIf:$false

    $credential = $(Get-LockpathConfiguration -Name 'credential')

    if ($null -ne $credential.UserName) {
        return $credential
    } else {
        try {
            $content = Import-Clixml -Path $(Get-LockpathConfiguration -Name 'credentialFilePath')
            $credential = New-Object System.Management.Automation.PSCredential $content.Username, $content.Password
            Write-LockpathLog -Message 'Restoring login credentials from file. These values can be cleared by calling Remove-LockpathCredential.' -Level Verbose
            $script:configuration | Add-Member NoteProperty -Name 'credential' -Value $credential -Force
            return $credential
        } catch {
            Write-LockpathLog -Message 'The credential configuration file for this module is in an invalid state.  Use Set-LockpathCredential to reset.' -Level Warning
        }
    }
}
