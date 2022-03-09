
# Copyright (c) Robert Klohr. All rights reserved.
# Licensed under the MIT License.

function Remove-LockpathCredential {
    <#
    .SYNOPSIS
        Allows the user to remove the API credential used for authentication.

    .DESCRIPTION
        Allows the user to remove the API credential used for authentication.

        The Git repo for this module can be found here: https://git.io/powershellforlockpath

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
        https://git.io/powershellforlockpathhelp
    #>

    [CmdletBinding(
        ConfirmImpact = 'Medium',
        PositionalBinding = $false,
        SupportsShouldProcess = $true
    )]
    [OutputType('System.String')]

    param(
        [Switch] $SessionOnly
    )

    $level = 'Verbose'
    $functionName = ($PSCmdlet.CommandRuntime.ToString())
    $service = 'PublicHelper'

    if ($Script:LockpathConfig.loggingLevel -eq 'Debug') {
        Write-LockpathInvocationLog -Confirm:$false -WhatIf:$false -FunctionName $functionName -Level $level -Service $service
    }

    if ($PSCmdlet.ShouldProcess('Cleared API credential (websession) from memory')) {
        if (-not $SessionOnly) {
            if ($PSCmdlet.ShouldProcess('Deleting API credential from the session and local file')) {
                Remove-Item -Path $Script:LockpathConfig.credentialFilePath, -Force -ErrorAction SilentlyContinue -ErrorVariable ev
                Write-LockpathLog -Confirm:$false -WhatIf:$false -Message "Removed the API credential file $($Script:LockpathConfig.credentialFilePath) from file system." -Level $level -ErrorRecord $ev[0]

                if (($null -ne $ev) -and ($ev.Count -gt 0) -and ($ev[0].FullyQualifiedErrorId -notlike 'PathNotFound*')) {
                    Write-LockpathLog -Confirm:$false -WhatIf:$false -Message "Experienced a problem trying to remove the API credential file $($Script:LockpathConfig.credentialFilePath)." -Level $level -ErrorRecord $ev[0]
                }
            }
        }
        $Script:LockpathConfig.webSession = $null
        Write-LockpathLog -Confirm:$false -WhatIf:$false -Message 'Cleared API credential (websession) from memory.' -Level $level
    }
}
