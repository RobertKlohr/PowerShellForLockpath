# Copyright (c) Robert Klohr. All rights reserved.
# Licensed under the MIT License.

function Import-LockpathAuthenticationCookie {
    <#
    .SYNOPSIS
        Attempts to import the API authentication cookie from the local file system.

    .DESCRIPTION
        Attempts to import the API authentication cookie from the local file system.

        The Git repo for this module can be found here: https://git.io/powershellforlockpath

    .EXAMPLE
        Import-LockpathAuthenticationCookie

    .INPUTS
        IO.FileInfo

    .OUTPUTS
        String

    .NOTES
        Private helper method.

    .LINK
        https://git.io/powershellforlockpathhelp
    #>

    [Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSShouldProcess', '', Justification = 'Methods called within here make use of PSShouldProcess, and the switch is passed on to them inherently.')]

    [CmdletBinding(
        ConfirmImpact = 'Low',
        PositionalBinding = $false,
        SupportsShouldProcess = $true
    )]

    param()

    $level = 'Debug'
    $functionName = ($PSCmdlet.CommandRuntime.ToString())
    $service = 'PrivateHelper'

    Write-LockpathInvocationLog -Confirm:$false -WhatIf:$false -FunctionName $functionName -Level $level -Service $service

    try {
        $cookie = Import-Clixml -Path $Script:LockpathConfig.authenticationCookieFilePath
        $Script:LockpathConfig.authenticationCookie = $cookie
        Write-LockpathLog -Confirm:$false -WhatIf:$false -FunctionName $functionName -Level $level -Service $service -Message "Imported authentication cookie from $($Script:LockpathConfig.authenticationCookieFilePath)"
        return $cookie
    } catch {
        Write-LockpathLog -Confirm:$false -WhatIf:$false -FunctionName $functionName -Level 'Warning' -Service $service -Message 'Unable to import the authentication cookie from the local file storage.'
    }
}
