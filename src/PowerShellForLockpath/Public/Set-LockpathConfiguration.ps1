function Set-LockpathConfiguration {
    [CmdletBinding()]

    param(
        [ValidatePattern('^(?!https?:).*')]

        [switch] $DefaultNoStatus,

        [switch] $DisableLogging,

        [switch] $DisableSmarterObjects,

        [string] $InstanceName,

        [ValidateRange(0, 65535)]
        [int] $InstancePort,

        [string] $InstancePortocol,

        [string] $LogPath,

        [switch] $LogProcessId,

        [switch] $LogRequestBody,

        [switch] $LogTimeAsUtc,

        [int] $PageIndex,

        [int] $PageSize,

        [int] $RetryDelaySeconds,

        [boolean] $RunAsSystem,

        [switch] $SessionOnly,

        [ValidateRange(0, 3600)]
        [int] $WebRequestTimeoutSec
    )

    $persistedConfig = $null
    if (-not $SessionOnly) {
        $persistedConfig = Read-Configuration -Path $script:configurationFilePath
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
        Save-Configuration -Configuration $persistedConfig -Path $script:configurationFilePath
    }

}
