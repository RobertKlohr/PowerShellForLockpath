function Import-LockpathConfiguration {
    [CmdletBinding(SupportsShouldProcess)]
    [Diagnostics.CodeAnalysis.SuppressMessageAttribute("PSShouldProcess", "", Justification = "Methods called within here make use of PSShouldProcess, and the switch is passed on to them inherently.")]
    param(
        [string] $Path
    )

    # Write-InvocationLog

    $logPath = [String]::Empty
    $documentsFolder = [System.Environment]::GetFolderPath('MyDocuments')
    if (-not [System.String]::IsNullOrEmpty($documentsFolder)) {
        $logPath = Join-Path -Path $documentsFolder -ChildPath 'PowerShellForLockpath.log'
    }

    # Create a configuration object with all the default values.
    $config = [PSCustomObject]@{
        'configurationFilePath' = [System.IO.Path]::Combine([Environment]::GetFolderPath('ApplicationData'), 'PowerShellForLockpath', 'PowerShellForLockpathConfiguration.json')
        'credentialFilePath'    = [System.IO.Path]::Combine([Environment]::GetFolderPath('LocalApplicationData'), 'PowerShellForLockpath', 'PowerShellForLockpathCredential.xml')
        'acceptHeader'          = 'application/json'
        'instanceName'          = [String]::Empty
        'instancePort'          = 4443
        'instanceProtocol'      = 'https'
        'logPath'               = $logPath
        'logRequestBody'        = $false
        'logTimeAsUtc'          = $false
        'MethodContainsBody'    = ("Delete", "Post")
        'pageIndex'             = 0
        'pageSize'              = 1000
        'retryDelaySeconds'     = 30
        'runAsSystem'           = $true
        'UserAgent'             = "PowerShell/$($PSVersionTable.PSVersion.ToString(2)) PowerShellForLockpath"
        'webRequestTimeoutSec'  = 0
        'webSession'            = $false
    }

    # Update the values with any that we find in the configuration file.
    $jsonObject = Read-LockpathConfiguration -Path $Path
    Get-Member -InputObject $config -MemberType NoteProperty |
    ForEach-Object {
        $name = $_.Name
        $type = $config.$name.GetType().Name
        $config.$name = Resolve-PropertyValue -InputObject $jsonObject -Name $name -Type $type -DefaultValue $config.$name
    }

    return $config
}
