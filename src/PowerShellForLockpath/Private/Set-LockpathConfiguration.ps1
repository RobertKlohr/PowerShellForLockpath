function Set-LockpathConfiguration {
    <#
        .SYNOPSIS
            Change the value of a configuration property for the PowerShellForLockpath module,
            for the session and by defatult store the configuration values in a local file.

        .DESCRIPTION
            Change the value of a configuration property for the PowerShellForLockpath module,
            for the session and by defatult store the configuration values in a local file.

            A single call to this method can set any number or combination of properties.

            To change any of the boolean/switch properties to false, specify the switch,
            immediately followed by ":$false" with no space.

            The Git repo for this module can be found here: https://github.com/RjKGitHub/PowerShellForLockpath/

        .PARAMETER ApiHostName
            The hostname of the Lockpath instance to communicate with.  Do not include the HTTP/S prefix.

        .PARAMETER DisableLogging
            Specify this switch to stop the module from logging all activity to a log file located
            at the location specified by LogPath.

        .PARAMETER LogPath
            The location of the log file that all activity will be written to if DisableLogging remains $false.

        .PARAMETER SessionOnly
            By default, this method will store the configuration values in a local file so that changes
            persist across PowerShell sessions.  If this switch is provided, the file will not be
            created/updated and the specified configuration changes will only remain in memory/effect
            for the duration of this PowerShell session.

        .EXAMPLE
            Set-LockpathConfiguration

        .EXAMPLE
            Set-LockpathConfiguration -ApiHostName "lockpath.keylightrc.com" -DisableLogging -SessionOnly

            Sets all requests to connect to lockpath.keylightgrc.com,
            disables the logging of any activity to the logfile specified in LogPath, but for this session only.

    #>
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
