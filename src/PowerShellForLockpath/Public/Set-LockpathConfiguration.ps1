function Set-LockpathConfiguration {
        #TODO Create Help Section
    #TODO Update to new coding standards
    [CmdletBinding(
        ConfirmImpact = 'Low',
        PositionalBinding = $false,
        SupportsShouldProcess = $true)]
    [OutputType('System.String')]
    [Diagnostics.CodeAnalysis.SuppressMessageAttribute("PSShouldProcess", "", Justification = "Methods called within here make use of PSShouldProcess, and the switch is passed on to them inherently.")]

    param(
        [ValidatePattern('^(?!https?:).*')]

        [string] $InstanceName,

        [ValidateRange(0, 65535)]
        [int] $InstancePort,

        [string] $InstancePortocol,

        [string] $LogPath,

        [switch] $LogRequestBody,

        [switch] $LogTimeAsUtc,

        [int] $PageIndex,

        [int] $PageSize,

        [int] $RetryDelaySeconds,

        [boolean] $RunAsSystem,

        [switch] $SessionOnly,

        [string] $UserAgent,

        [ValidateRange(0, 3600)]
        [int] $WebRequestTimeoutSec,

        [Microsoft.PowerShell.Commands.WebRequestSession] $WebSession
    )

    $persistedConfig = $null
    if (-not $SessionOnly) {
        $persistedConfig = Read-LockpathConfiguration -Path $script:configurationFilePath
    }

    $properties = Get-Member -InputObject $script:configuration -MemberType NoteProperty | Select-Object -ExpandProperty Name
    foreach ($name in $properties) {
        if ($PSBoundParameters.ContainsKey($name)) {
            $value = $PSBoundParameters.$name
            if ($value -is [switch]) {
                $value = $value.ToBool()
            }
            $script:configuration.$name = $value

            if (-not $SessionOnly) {
                Add-Member -InputObject $persistedConfig -Name $name -Value $value -MemberType NoteProperty -Force
            }
        }
    }

    if (-not $SessionOnly) {
        Save-LockpathConfiguration -Configuration $persistedConfig -Path $script:ConfigurationFilePath
    }

}
