
# Copyright (c) Robert Klohr. All rights reserved.
# Licensed under the MIT License.

function Reset-LockpathConfiguration {
    <#
    .SYNOPSIS
        Deletes the configuration file and creates a new file with all default configuration values.

    .DESCRIPTION
        Deletes the configuration file and creates a new file with all default configuration values.

        This function can be used to fix a configuration file that is missing or corrupt.

        The Git repo for this module can be found here: https://git.io/powershellforlockpath

    .PARAMETER SessionOnly
        If this is specified then only the configuration values that were made during this session will be discarded and the configuration file will be reloaded.

    .EXAMPLE
        Reset-LockpathConfiguration

        Deletes the local configuration file and calls Set-LockpathConfiguration to create a new configuration file.

    .EXAMPLE
        Reset-LockpathConfiguration -SessionOnly

        Initializes the current sessions with default configuration values and attempts to reload the configuration file.

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
        ConfirmImpact = 'Low',
        PositionalBinding = $false,
        SupportsShouldProcess = $true
    )]

    [OutputType([System.String])]

    param(
        [Switch] $SessionOnly
    )

    $level = 'Verbose'
    $functionName = ($PSCmdlet.CommandRuntime.ToString())
    $service = 'PublicHelper'

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

    if ($PSCmdlet.ShouldProcess($shouldProcessTarget)) {
        Initialize-LockpathConfiguration
        $logParameters.Message = 'Success: ' + $shouldProcessTarget
        if (-not $SessionOnly) {
            $shouldProcessTarget = "Reseting configuration in memory and configuration file at $($Script:LockpathConfig.configurationFilePath). This has not cleared your API credential.  Call Remove-LockpathCredential to accomplish that."
            try {
                $null = Remove-Item -Path $Script:LockpathConfig.configurationFilePath -Force -ErrorAction SilentlyContinue -ErrorVariable ev
                $null = New-Item -Path $Script:LockpathConfig.configurationFilePath -Force
                $Script:LockpathConfig | Set-LockpathConfiguration
                $logParameters.Message = 'Success: ' + $shouldProcessTarget
            } catch {
                $logParameters.Level = 'Error'
                $logParameters.Message = 'Failed: ' + $shouldProcessTarget
                $logParameters.Result = $_.Exception.Message
            } finally {
                Write-LockpathLog @logParameters
            }
        }
        return $result
    }
}
