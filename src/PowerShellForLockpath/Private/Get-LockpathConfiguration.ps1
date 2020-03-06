function Get-LockpathConfiguration {
    <#
    .SYNOPSIS
        Gets the currently configured value for the requested configuration setting.

    .DESCRIPTION
        Gets the currently configured value for the requested configuration setting.

        Always returns the value for this session, which may or may not be the persisted
        setting (that all depends on whether or not the setting was previously modified
        during this session using Set-GitHubConfiguration -SessionOnly).

        The Git repo for this module can be found here: http://aka.ms/PowerShellForGitHub

    .PARAMETER Name
        The name of the configuration whose value is desired.

    .EXAMPLE
        Get-GitHubConfiguration -Name WebRequestTimeoutSec

        Gets the currently configured value for WebRequestTimeoutSec for this PowerShell session
        (which may or may not be the same as the persisted configuration value, depending on
        whether this value was modified during this session with Set-GitHubConfiguration -SessionOnly).
#>
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
