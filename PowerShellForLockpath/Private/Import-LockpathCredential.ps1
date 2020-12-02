function Import-LockpathCredential {
    <#
    .SYNOPSIS
        Attempts to import the API credential from the local file system.

    .DESCRIPTION
        Attempts to import the API credential from the local file system.

        First the will try to use the credential already cached in memory. If not found, will look to see if there
        is a file with the API credential stored as a SecureString.

        The Git repo for this module can be found here: https://github.com/RobertKlohr/PowerShellForLockpath

    .EXAMPLE
        Import-LockpathCredential

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

    $credential = $Script:configuration.credential

    if ($null -ne $credential.UserName) {
        return $credential
    } else {
        try {
            $content = Import-Clixml -Path $Script:configuration.credentialFilePath
            $credential = New-Object System.Management.Automation.PSCredential $content.Username, $content.Password
            Write-LockpathLog -Message 'Importing API credential from file. This value can be cleared by calling Remove-LockpathCredential.' -Level Verbose
            $Script:configuration.credential = $credential
            return $credential
        } catch {
            Write-LockpathLog -Message 'The credential configuration file for this module is in an invalid state.  Use Set-LockpathCredential to reset.' -Level Warning
        }
    }
}
