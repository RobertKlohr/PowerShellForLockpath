# Copyright (c) Robert Klohr. All rights reserved.
# Licensed under the MIT License.

function Import-LockpathConfiguration {
    <#
    .SYNOPSIS
        Loads in the configuration file from the local file system and then updates the configuration in memory with
        values that may exist in the file.

    .DESCRIPTION
        Loads in the configuration file from the local file system and then updates the configuration in memory with
        values that may exist in the file.

        The Git repo for this module can be found here: https://git.io/powershellforlockpath

    .PARAMETER FilePath
        The file containing a JSON serialized version of the configuration values for this module.

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
        [System.IO.FileInfo] $FilePath = $Script:LockpathConfig.configurationFilePath
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

    $shouldProcessTarget = 'Loading Configuration File'

    if ($PSCmdlet.ShouldProcess($shouldProcessTarget)) {
        try {
            $savedLockpathConfig = Import-Clixml -Path $FilePath
            Get-Member -InputObject $Script:LockpathConfig -MemberType NoteProperty |
            ForEach-Object {
                $name = $_.Name
                $type = $Script:LockpathConfig.$name.GetType().Name
                if (Resolve-LockpathConfigurationPropertyValue -InputObject $savedLockpathConfig -Name $name -Type $type -DefaultValue $Script:LockpathConfig.$name) {
                    $Script:LockpathConfig.$name = $savedLockpathConfig.$name
                }
            }
            $Script:LockpathConfig.authenticationCookie = Import-LockpathAuthenticationCookie
            # $Script:LockpathConfig.credential = Import-LockpathCredential
            Import-LockpathCredential
        } catch {
            # Normally Write-LockpathInvocationLog runs first, but the configuration needs to be loaded
            Write-LockpathInvocationLog @logParameters
            $logParameters.Level = 'Error'
            $logParameters.Message = 'failed: ' + $shouldProcessTarget + 'Current configuration is using all default values and will not work until you at least call Set-LockpathConfiguration -InstaneName "instancename".'
            $logParameters.result = $_.Exception.Message
        } finally {
            Write-LockpathLog @logParameters
        }
    }
}
