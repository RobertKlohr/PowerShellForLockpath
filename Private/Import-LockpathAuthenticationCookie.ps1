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
        'FunctionName' = $functionName
        'Level'        = $level
        'Message'      = $null
        'Service'      = $service
        'Result'       = $null
    }

    Write-LockpathInvocationLog @logParameters

    $shouldProcessTarget = "Importing authentication cookie from $($Script:LockpathConfig.authenticationCookieFilePath)."

    if ($PSCmdlet.ShouldProcess($shouldProcessTarget)) {
        try {
            $Script:LockpathConfig.authenticationCookie = Import-Clixml -Path $Script:LockpathConfig.authenticationCookieFilePath
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
