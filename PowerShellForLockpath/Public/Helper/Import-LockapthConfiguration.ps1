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
        SupportsShouldProcess = $true)]

    [Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSShouldProcess', '', Justification = 'Methods called within here make use of PSShouldProcess, and the switch is passed on to them inherently.')]

    param(
        [System.IO.FileInfo] $FilePath = $Script:LockpathConfig.configurationFilePath
    )

    $level = 'Verbose'
    $functionName = ($PSCmdlet.CommandRuntime.ToString())
    $service = 'PublicHelper'

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
        Write-LockpathLog -Confirm:$false -WhatIf:$false -Message 'Failed to load configuration file. Current configuration is using all default values and will not work until you at least call Set-LockpathConfiguration -InstaneName "instancename".' -Level $level
    }

    # Normally Write-LockpathInvocationLog -Confirm:$false -WhatIf:$false -FunctionName $functionName  -Level $level -Service $service
    # configuration to be loaded first.
    Write-LockpathInvocationLog -Confirm:$false -WhatIf:$false -FunctionName $functionName -Level $level -Service $service

}
