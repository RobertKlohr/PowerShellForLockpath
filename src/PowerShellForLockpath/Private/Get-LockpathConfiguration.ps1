function Get-LockpathConfiguration {
    #TODO Create Help Section
    #TODO Update to new coding standards
    [CmdletBinding(
        ConfirmImpact = 'Low',
        PositionalBinding = $false,
        SupportsShouldProcess = $true)]

    [Diagnostics.CodeAnalysis.SuppressMessageAttribute("PSShouldProcess", "", Justification = "Methods called within here make use of PSShouldProcess, and the switch is passed on to them inherently.")]

    param(
        [Parameter(Mandatory)]
        [ValidateSet(
            'acceptHeader',
            'configurationFilePath',
            'credentialFilePath',
            'instanceName',
            'instancePort',
            'instanceProtocol',
            'logPath',
            'logRequestBody',
            'logTimeAsUtc',
            'MethodContainsBody',
            'pageIndex',
            'pageSize',
            'retryDelaySeconds',
            'runAsSystem',
            'UserAgent',
            'webRequestTimeoutSec',
            'webSession')]
        [string] $Name
    )

    return $script:configuration.$Name
}
