function Set-LockpathConfiguration {
    [CmdletBinding()]

    param(
        [ValidatePattern('^(?!https?:)(?!api\.)(?!www\.).*')]
        [string] $ApiHostName,

        [string] $ApplicationInsightsKey,

        [string] $AssemblyPath,

        [switch] $DefaultNoStatus,

        [string] $DefaultOwnerName,

        [string] $DefaultRepositoryName,

        [switch] $DisableLogging,

        [switch] $DisablePiiProtection,

        [switch] $DisableSmarterObjects,

        [switch] $DisableTelemetry,

        [string] $LogPath,

        [switch] $LogProcessId,

        [switch] $LogRequestBody,

        [switch] $LogTimeAsUtc,

        [int] $RetryDelaySeconds,

        [switch] $SuppressNoTokenWarning,

        [switch] $SuppressTelemetryReminder,

        [ValidateRange(0, 3600)]
        [int] $WebRequestTimeoutSec,

        [switch] $SessionOnly
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
        Save-LockpathConfiguration -Configuration $persistedConfig -Path $script:configurationFilePath
    }

}
