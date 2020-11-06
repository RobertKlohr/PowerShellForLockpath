function Get-LockpathConfiguration {
    # TODO remove this function and it's dependencies and replace with $script:configuration.$Name
    <#
    .SYNOPSIS
        Gets the currently configured value for the requested configuration setting.

    .DESCRIPTION
        Gets the currently configured value for the requested configuration setting.

        Always returns the value for this session, which may or may not be the persisted
        setting (that all depends on whether or not the setting was previously modified
        during this session using Set-LockpathConfiguration -SessionOnly).

        The Git repo for this module can be found here: https://github.com/RobertKlohr/PowerShellForLockpath

    .PARAMETER Name
        The name of the configuration whose value is desired.

    .EXAMPLE
        Get-LockpathConfiguration -Name instanceName

        Gets the currently configured value for instanceName for this PowerShell session
        (which may or may not be the same as the persisted configuration value, depending on
        whether this value was modified during this session with Set-LockpathConfiguration -SessionOnly).

    .INPUTS
        String

    .OUTPUTS
        String

    .NOTES
        Private helper method.

    .LINK
        https://github.com/RobertKlohr/PowerShellForLockpath/wiki
    #>

    [CmdletBinding(
        ConfirmImpact = 'Low',
        PositionalBinding = $false,
        SupportsShouldProcess = $true)]

    [Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSShouldProcess', '', Justification = 'Methods called within here make use of PSShouldProcess, and the switch is passed on to them inherently.')]

    param(
        [Parameter(
            Mandatory = $true,
            Position = 0)]
        [ValidateSet(
            'acceptHeader',
            'configurationFilePath',
            'credentialFilePath',
            'credential',
            'instanceName',
            'instancePort',
            'instanceProtocol',
            'logPath',
            'logProcessId',
            'logRequestBody',
            'logTimeAsUtc',
            'MethodContainsBody',
            'pageIndex',
            'pageSize',
            'runAsSystem',
            'UserAgent',
            'webRequestTimeoutSec',
            'webSession')]
        [String] $Name
    )

    return $script:configuration.$Name
}
