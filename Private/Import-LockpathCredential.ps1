# Copyright (c) Robert Klohr. All rights reserved.
# Licensed under the MIT License.

function Import-LockpathCredential {
    <#
    .SYNOPSIS
        Attempts to import the API credential from the local file system.

    .DESCRIPTION
        Attempts to import the API credential from the local file system.

        First the will try to use the credential already cached in memory.
        If not found, will look to see if there is a file with the API credential
        stored as a SecureString.

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
        SupportsShouldProcess = $true
    )]

    [OutputType([System.Void])]

    param()

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


    $shouldProcessTarget = "Importing API credential from $($Script:LockpathConfig.credentialFilePath)."

    if ($PSCmdlet.ShouldProcess($shouldProcessTarget)) {
        try {
            $Script:LockpathConfig.credential = Import-Clixml -Path $Script:LockpathConfig.credentialFilePath
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
