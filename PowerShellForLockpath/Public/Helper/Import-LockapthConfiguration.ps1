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
        [IO.FileInfo] $FilePath = $script:configuration.configurationFilePath
    )

    Write-LockpathInvocationLog -ExcludeParameter FilePath -Confirm:$false -WhatIf:$false

    # Update the values with any that we find in the configuration file.

    $savedConfiguration = Read-LockpathConfiguration -FilePath $FilePath
    If ($null -eq $savedConfiguration) {
        Write-LockpathLog -Message 'Failed to load configuration file.  Current configuration is using all default values and will not work until you at least call Set-LockpathConfiguration -InstaneName "instancename".' -Level Warning
        return
    }
    Get-Member -InputObject $script:configuration -MemberType NoteProperty |
    ForEach-Object {
        $name = $_.Name
        if ($name -ne 'credential' -AND $name -ne 'webSession') {
            $type = $script:configuration.$name.GetType().Name
            if ($type -eq 'String[]') {
                $script:configuration.$name = [String[]] $(Resolve-LockpathConfigurationPropertyValue -InputObject $savedConfiguration -Name $name -Type $type -DefaultValue $script:configuration.$name)
            } else {
                $script:configuration.$name = Resolve-LockpathConfigurationPropertyValue -InputObject $savedConfiguration -Name $name -Type $type -DefaultValue $script:configuration.$name
            }
        }
    }
}
