function Import-LockpathCredential {
    <#
    .SYNOPSIS
        Attempts to import the API credential from the local file system.

    .DESCRIPTION
        Attempts to import the API credential from the local file system.

        First the will try to use the credential already cached in memory. If not found, will look to see if there
        is a file with the API credential stored as a SecureString.

        The Git repo for this module can be found here: https://git.io/powershellforlockpath

    .EXAMPLE
        Import-LockpathCredential

    .INPUTS
        IO.FileInfo

    .OUTPUTS
        String

    .NOTES
        Private helper method.

    .LINK
        https://git.io/powershellforlockpathhelp
    #>

    [CmdletBinding(
        ConfirmImpact = 'Low',
        PositionalBinding = $false,
        SupportsShouldProcess = $true)]

    [Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSShouldProcess', '', Justification = 'Methods called within here make use of PSShouldProcess, and the switch is passed on to them inherently.')]

    param()

    $level = 'Debug'
    $functionName = ($PSCmdlet.CommandRuntime.ToString())
    $service = 'PrivateHelper'

    Write-LockpathInvocationLog -Confirm:$false -WhatIf:$false -FunctionName $functionName -Level $level -Service $service

    if ($null -ne $Script:LockpathConfig.credential.UserName) {
        return
    } else {
        try {
            $Script:LockpathConfig.credential = Import-Clixml -Path $Script:LockpathConfig.credentialFilePath
            Write-LockpathLog -Confirm:$false -WhatIf:$false -FunctionName $functionName -Level $level -Service $service -Message 'Importing API credential from file.'
        } catch {
            Write-LockpathLog -Confirm:$false -WhatIf:$false -FunctionName $functionName -Level 'Warning' -Service $service -Message 'The credential configuration file for this module is in an invalid state.'
        }
    }
}
