function Get-LockpathConfiguration {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory)]
        [ValidateSet(
            'ApiHostName',
            'ApplicationInsightsKey',
            'AssemblyPath',
            'DefaultNoStatus',
            'DefaultOwnerName',
            'DefaultRepositoryName',
            'DisableLogging',
            'DisablePiiProtection',
            'DisableSmarterObjects',
            'DisableTelemetry',
            'LogPath',
            'LogProcessId',
            'LogRequestBody',
            'LogTimeAsUtc',
            'RetryDelaySeconds',
            'SuppressNoTokenWarning',
            'SuppressTelemetryReminder',
            'TestConfigSettingsHash',
            'WebRequestTimeoutSec')]
        [string] $Name
    )

    return $script:configuration.$Name
}
