# Copyright (c) Robert Klohr. All rights reserved.
# Licensed under the MIT License.

function Show-LockpathConfiguration {
    <#
    .SYNOPSIS
        Shows the current module configuration.

    .DESCRIPTION
        Shows the current module configuration.

        By default returns the configuration for this session.  This may not be different than the configuration
        saved to file if the session configuration was updated using Set-LockpathConfiguration -SessionOnly.

        The Git repo for this module can be found here: https://git.io/powershellforlockpath

    .PARAMETER Saved
        Shows the configuration saved to file instead of the session configuration.

    .EXAMPLE
        Show-LockpathConfiguration

        By default, this method will show the configuration in memory for this session.

    .EXAMPLE
        Show-LockpathConfiguration -Persisted

        Gets the configuration saved to file and show that configuration.

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
        [Switch] $Saved,

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

    Write-LockpathInvocationLog @logParameters

    #TODO add try catch
    if ($PSCmdlet.ShouldProcess($shouldProcessTarget)) {
        if ($Saved) {
            $savedConfiguration = Import-LockpathConfiguration -FilePath $FilePath
            return $savedConfiguration
        } else {
            return $Script:LockpathConfig
        }
    }
}
