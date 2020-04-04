function Get-Configuration {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory)]
        [ValidateSet(
            'defaultNoStatus',
            'disableLogging',
            'disableSmarterObjects',
            'instanceName',
            'instancePort',
            'instanceProtocol',
            'logPath',
            'logProcessId',
            'logRequestBody',
            'logTimeAsUtc',
            'retryDelaySeconds',
            'runAsSystem',
            'webRequestTimeoutSec')]
        [string] $Name
    )

    return $script:configuration.$Name
}
