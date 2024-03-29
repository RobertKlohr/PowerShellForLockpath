﻿# Copyright (c) Robert Klohr. All rights reserved.
# Licensed under the MIT License.

function Import-LockpathConfiguration {
    <#
    .SYNOPSIS
        Loads in the configuration file from the local file system and then updates the configuration in memory with values that may exist in the file.

    .DESCRIPTION
        Loads in the configuration file from the local file system and then updates the configuration in memory with values that may exist in the file.

        The Git repo for this module can be found here: https://git.io/powershellforlockpath

    .PARAMETER FilePath
        The file containing a JSON serialized version of the configuration values for this module.

    .PARAMETER Show
        Returns the configuration loaded from the file in addition to setting the session configuration object.

    .EXAMPLE
        Import-LockpathConfiguration -Path 'c:\temp\config.json'

        Creates a new default config object and updates its values with any that are found within a deserialized object from the content in $FilePath.  The configuration object is then returned.

    .INPUTS
        System.IO.FileInfo

    .OUTPUTS
        PSCustomObject

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

    [OutputType([System.Void])]

    param(
        [Switch] $Show,

        [System.IO.FileInfo] $FilePath = $Script:LockpathConfig.configurationFilePath
    )

    $level = 'Verbose'
    $functionName = ($PSCmdlet.CommandRuntime.ToString())
    $service = 'PublicHelper'

    $logParameters = [ordered]@{
        'FunctionName' = $functionName
        'Level'        = $level
        'Message'      = "Executing cmdlet: $functionName"
        'Service'      = $service
        'Result'       = "Executing cmdlet: $functionName"
    }

    $shouldProcessTarget = 'Loading Configuration File'

    if ($PSCmdlet.ShouldProcess($shouldProcessTarget)) {
        try {
            $savedLockpathConfig = Import-Clixml -Path $FilePath
            # The following configuration settings are never saved to the file system
            $nonPersistantSettings = @('authenticationCookie', 'credential', 'productVersion', 'vendorName')
            Get-Member -InputObject $Script:LockpathConfig -MemberType NoteProperty |
            ForEach-Object {
                $name = $_.Name
                $type = $Script:LockpathConfig.$name.GetType().Name
                # Skip nonpersistant configuration settings
                if (-not $nonPersistantSettings.Contains($name)) {
                    if (Resolve-LockpathConfigurationPropertyValue -InputObject $savedLockpathConfig -Name $name -Type $type -DefaultValue $Script:LockpathConfig.$name) {
                        $Script:LockpathConfig.$name = $savedLockpathConfig.$name
                    }
                }
            }
            # Normally Write-LockpathInvocationLog is run first in a cmdlet but we need to
            # import the configuration before using.
            Write-LockpathInvocationLog @logParameters
            Import-LockpathAuthenticationCookie
            Import-LockpathCredential
            $logParameters.Message = 'Success: ' + $shouldProcessTarget
            if ($Show) {
                return $savedLockpathConfig
            }
        } catch {
            $logParameters.Level = 'Error'
            $logParameters.Message = 'Failed: ' + $shouldProcessTarget + 'Current configuration is using all default values and will not work until you at least call Set-LockpathConfiguration -InstaneName "instancename".'
            $logParameters.Result = $_.Exception.Message
        } finally {
            Write-LockpathLog @logParameters
        }
    }
}
