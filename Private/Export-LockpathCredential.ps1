# Copyright (c) Robert Klohr. All rights reserved.
# Licensed under the MIT License.

function Export-LockpathCredential {
    <#
    .SYNOPSIS
        Attempts to export the API credential to the local file system.

    .DESCRIPTION
        Attempts to export the API credential to the local file system.

        The Git repo for this module can be found here: https://git.io/powershellforlockpath

    .PARAMETER Cookie
        A .Net cookie object.

    .PARAMETER Uri
        Uri of the cookie.

    .EXAMPLE
        Export-LockpathCredential

    .INPUTS
        System.Net.Cookie

    .OUTPUTS
        None

    .NOTES
        Private helper method.

    .LINK
        https://git.io/powershellforlockpathhelp
    #>

    [CmdletBinding(
        ConfirmImpact = 'Low',
        PositionalBinding = $false,
        SupportsShouldProcess = $true
    )]

    param(
        [Parameter(
            Mandatory = $true
        )]
        [PSCredential]  $Credential
    )

    $level = 'Debug'
    $functionName = ($PSCmdlet.CommandRuntime.ToString())
    $service = 'PrivateHelper'

    $logParameters = [ordered]@{
        'Confirm'      = $false
        'FunctionName' = $functionName
        'Level'        = $level
        'Message'      = $null
        'Service'      = $service
        'Result'       = $null
        'WhatIf'       = $false
    }

    Write-LockpathInvocationLog @logParameters

    try {
        Export-Clixml -InputObject $Credential -Path $Script:LockpathConfig.credentialFilePath -Depth 10 -Force
        $message = 'success'
    } catch {
        $message = 'failed'
        $level = 'Warning'
    } finally {
        Write-LockpathLog -Confirm:$false -WhatIf:$false -Message $message -FunctionName $functionName -Level $level -Service $service
    }
}
