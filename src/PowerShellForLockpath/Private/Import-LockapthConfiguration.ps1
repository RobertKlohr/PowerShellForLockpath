function Import-LockpathConfiguration {
    #FIXME Update to new coding standards
    [CmdletBinding(
        ConfirmImpact = 'Low',
        PositionalBinding = $false,
        SupportsShouldProcess = $true)]

    [Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSShouldProcess', '', Justification = 'Methods called within here make use of PSShouldProcess, and the switch is passed on to them inherently.')]

    param(
        [Parameter(Mandatory)]
        [string] $Path
    )

    # Write-LockpathInvocationLog

    # Create a configuration object with all the default values.
    $config = [PSCustomObject]@{
        'acceptHeader'          = [String] 'application/json'
        'configurationFilePath' = [System.IO.Path]::Combine([Environment]::GetFolderPath('ApplicationData'), 'PowerShellForLockpath', 'PowerShellForLockpathConfiguration.json')
        'credentialFilePath'    = [System.IO.Path]::Combine([Environment]::GetFolderPath('LocalApplicationData'), 'PowerShellForLockpath', 'PowerShellForLockpathCredential.xml')
        'instanceName'          = [String]::Empty
        'instancePort'          = [Uint32] 4443
        'instanceProtocol'      = [String] 'https'
        'logPath'               = [System.IO.Path]::Combine([Environment]::GetFolderPath('MyDocuments'), 'PowerShellForLockpath', 'PowerShellForLockpath.log')
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
        'credential'            = [PSCredential]::Empty
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
