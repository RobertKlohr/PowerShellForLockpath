# Copyright (c) Robert Klohr. All rights reserved.
# Licensed under the MIT License.

function Export-LockpathCredential {
    <#
    .SYNOPSIS
        Attempts to export the API credential to the local file system.

    .DESCRIPTION
        Attempts to export the API credential to the local file system.

        The Git repo for this module can be found here: https://git.io/powershellforlockpath

    .PARAMETER Credential
        A PSCredential object.

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

    [OutputType([System.Void])]

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

    $shouldProcessTarget = 'Exporting Credential'

    if ($PSCmdlet.ShouldProcess($shouldProcessTarget)) {
        try {
            Export-Clixml -InputObject $Credential -Path $Script:LockpathConfig.credentialFilePath -Depth $Script:LockpathConfig.conversionDepth -Force
            $logParameters.Message = 'Success: ' + $shouldProcessTarget
        } catch {
            $logParameters.Level = 'Error'
            $logParameters.Message = 'Failed: ' + $shouldProcessTarget
            $logParameters.Result = $_.Exception.Message
        } finally {
            Write-LockpathLog @logParameters
        }
    }
}
