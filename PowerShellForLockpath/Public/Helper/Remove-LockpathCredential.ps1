
function Remove-LockpathCredential {
    <#
    .SYNOPSIS
        Allows the user to remove the API credential used for authentication.

    .DESCRIPTION
        Allows the user to remove the API credential used for authentication.

        The Git repo for this module can be found here: https://github.com/RobertKlohr/PowerShellForLockpath

    .PARAMETER SessionOnly
        Removes the API credential from the session and does not delete the credential stored in the local file.

    .EXAMPLE
        Set-LockpathCredential

        Removes the API credential from the session AND deletes the credential from the local file.

    .EXAMPLE
        Set-LockpathCredential -SessionOnly

        Removes the API credential from the session.

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
        ConfirmImpact = 'Medium',
        PositionalBinding = $false,
        SupportsShouldProcess = $true)]
    [OutputType('System.String')]

    [Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSShouldProcess', '', Justification = 'Methods called within here make use of PSShouldProcess, and the switch is passed on to them inherently.')]

    param(
        [Switch] $SessionOnly
    )

    Write-LockpathInvocationLog -Confirm:$false -WhatIf:$false

    if ($PSCmdlet.ShouldProcess('Cleared API credential (websession) from memory')) {
        if (-not $SessionOnly) {
            if ($PSCmdlet.ShouldProcess('Deleting API credential from the session and local file')) {
                Remove-Item -Path $Script:LockpathConfig.credentialFilePath, -Force -ErrorAction SilentlyContinue -ErrorVariable ev
                Write-LockpathLog -Message "Removed the API credential file $($Script:LockpathConfig.credentialFilePath) from file system." -Level Warning -ErrorRecord $ev[0]

                if (($null -ne $ev) -and ($ev.Count -gt 0) -and ($ev[0].FullyQualifiedErrorId -notlike 'PathNotFound*')) {
                    Write-LockpathLog -Message "Experienced a problem trying to remove the API credential file $($Script:LockpathConfig.credentialFilePath)." -Level Warning -ErrorRecord $ev[0]
                }
            }
        }
        $Script:LockpathConfig.webSession = $null
        Write-LockpathLog -Message 'Cleared API credential (websession) from memory.' -Level Verbose
    }
}
