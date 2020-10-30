function Import-LockpathConfiguration {
    #FIXME Update to new coding standards

    #FIXME Clean up help
    <#
    .SYNOPSIS
        Loads in the default configuration values, and then updates the individual properties
        with values that may exist in a file.

    .DESCRIPTION
        Loads in the default configuration values, and then updates the individual properties
        with values that may exist in a file.

        The Git repo for this module can be found here: http://aka.ms/PowerShellForGitHub

    .PARAMETER Path
        The file that may or may not exist with a serialized version of the configuration
        values for this module.

    .OUTPUTS
        PSCustomObject

    .NOTES
        Internal helper method.
        No side-effects.

    .EXAMPLE
        Import-GitHubConfiguration -Path 'c:\foo\config.json'

        Creates a new default config object and updates its values with any that are found
        within a deserialized object from the content in $Path.  The configuration object
        is then returned.
#>


    [CmdletBinding(
        ConfirmImpact = 'Low',
        PositionalBinding = $false,
        SupportsShouldProcess = $true)]

    [Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSShouldProcess', '', Justification = 'Methods called within here make use of PSShouldProcess, and the switch is passed on to them inherently.')]

    param(
        [Parameter(Mandatory)]
        [string] $Path
    )

    # Write-LockpathInvocationLog -Confirm:$false -WhatIf:$false

    # Create a configuration object with all the default values.
    $config = [PSCustomObject]@{
        'acceptHeader'          = [String] 'application/json'
        'configurationFilePath' = [System.IO.Path]::Combine([Environment]::GetFolderPath('ApplicationData'), 'PowerShellForLockpath', 'PowerShellForLockpathConfiguration.json')
        'credential'            = [PSCredential]::Empty
        'credentialFilePath'    = [System.IO.Path]::Combine([Environment]::GetFolderPath('LocalApplicationData'), 'PowerShellForLockpath', 'PowerShellForLockpathCredential.xml')
        'instanceName'          = [String]::Empty
        'instancePort'          = [Uint32] 4443
        'instanceProtocol'      = [String] 'https'
        'logPath'               = [System.IO.Path]::Combine([Environment]::GetFolderPath('MyDocuments'), 'PowerShellForLockpath', 'PowerShellForLockpath.log')
        'logProcessId'          = [Boolean] $false
        'logRequestBody'        = [Boolean] $false
        'logTimeAsUtc'          = [Boolean] $false
        'MethodContainsBody'    = [String[]] ('Delete', 'Post')
        'pageIndex'             = [Uint32] 0
        'pageSize'              = [Uint32] 100
        'retryDelaySeconds'     = [Uint32] 30
        'runAsSystem'           = [Boolean] $true
        'UserAgent'             = "PowerShell/$($PSVersionTable.PSVersion.ToString()) PowerShellForLockpath"
        'webRequestTimeoutSec'  = [Uint32] 0
        'webSession'            = [Boolean] $false
    }

    # Update the values with any that we find in the configuration file.
    $jsonObject = Read-LockpathConfiguration -Path $Path
    Get-Member -InputObject $config -MemberType NoteProperty |
    ForEach-Object {
        $name = $_.Name
        $type = $config.$name.GetType().Name
        $config.$name = Resolve-LockpathConfigurationPropertyValue -InputObject $jsonObject -Name $name -Type $type -DefaultValue $config.$name
    }

    return $config
}
