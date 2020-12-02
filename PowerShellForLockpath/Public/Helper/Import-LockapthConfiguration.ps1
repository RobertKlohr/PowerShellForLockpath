function Import-LockpathConfiguration {
    <#
    .SYNOPSIS
        Loads in the configuration file from the local file system and then updates the configuration in memory with
        values that may exist in the file.

    .DESCRIPTION
        Loads in the configuration file from the local file system and then updates the configuration in memory with
        values that may exist in the file.

        The Git repo for this module can be found here: https://github.com/RobertKlohr/PowerShellForLockpath

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
        https://github.com/RobertKlohr/PowerShellForLockpath/wiki
    #>

    [CmdletBinding(
        ConfirmImpact = 'Low',
        PositionalBinding = $false,
        SupportsShouldProcess = $true)]

    [Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSShouldProcess', '', Justification = 'Methods called within here make use of PSShouldProcess, and the switch is passed on to them inherently.')]

    param(
        [System.IO.FileInfo] $FilePath = $Script:configuration.configurationFilePath
    )

    Write-LockpathInvocationLog -ExcludeParameter FilePath -Confirm:$false -WhatIf:$false

    # Update the values with any that we find in the configuration file.

    $savedConfiguration = Import-LockpathConfiguration -FilePath $FilePath
    If ($null -eq $savedConfiguration) {
        Write-LockpathLog -Message 'Failed to load configuration file.  Current configuration is using all default values and will not work until you at least call Set-LockpathConfiguration -InstaneName "instancename".' -Level Warning
        return
    }
    Get-Member -InputObject $Script:configuration -MemberType NoteProperty |
    ForEach-Object {
        $name = $_.Name
        $type = $Script:configuration.$name.GetType().Name
        if (Resolve-LockpathConfigurationPropertyValue -InputObject $savedConfiguration -Name $name -Type $type -DefaultValue $Script:configuration.$name) {
            $Script:configuration.$name = $savedConfiguration.$name
        }
    }
    $Script:configuration.authenticationCookie = Import-LockpathAuthenticationCookie
}
