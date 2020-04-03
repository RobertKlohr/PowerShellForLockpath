function Import-Configuration {
    [CmdletBinding(SupportsShouldProcess)]
    [Diagnostics.CodeAnalysis.SuppressMessageAttribute("PSShouldProcess", "", Justification = "Methods called within here make use of PSShouldProcess, and the switch is passed on to them inherently.")]
    param(
        [string] $Path
    )

    $logPath = [String]::Empty
    $documentsFolder = [System.Environment]::GetFolderPath('MyDocuments')
    if (-not [System.String]::IsNullOrEmpty($documentsFolder)) {
        $logPath = Join-Path -Path $documentsFolder -ChildPath 'PowerShellForLockpath.log'
    }

    # Create a configuration object with all the default values.
    $config = [PSCustomObject]@{
        'defaultNoStatus'       = $false
        'disableLogging'        = ([String]::IsNullOrEmpty($logPath))
        'disableSmarterObjects' = $false
        'instanceName'          = [String]::Empty
        'instancePort'          = 4443
        'instanceProtocol'      = 'https'
        'logPath'               = $logPath
        'logProcessId'          = $false
        'logRequestBody'        = $false
        'logTimeAsUtc'          = $false
        'pageIndex'             = 0
        'pageSize'              = 1000
        'retryDelaySeconds'     = 30
        'runAsSystem'           = $true
        'webRequestTimeoutSec'  = 0
    }

    # Update the values with any that we find in the configuration file.
    $jsonObject = Read-Configuration -Path $Path
    Get-Member -InputObject $config -MemberType NoteProperty |
    ForEach-Object {
        $name = $_.Name
        $type = $config.$name.GetType().Name
        $config.$name = Resolve-PropertyValue -InputObject $jsonObject -Name $name -Type $type -DefaultValue $config.$name
    }

    return $config
}
