function Set-LockpathConfiguration {
    <#
    .SYNOPSIS
        Change the value of a configuration property for the module, for the session only, or saved to disk.

    .DESCRIPTION
        Change the value of a configuration property for the module, for the session only, or saved to disk.

        To change any of the boolean/switch properties to false, specify the switch,
        immediately followed by ":$false" with no space.

        The Git repo for this module can be found here: https://github.com/RobertKlohr/PowerShellForLockpath

    .PARAMETER Credential
        The username and password used to access the Lockpath instance.

    .PARAMETER InstanceName
        The URI of the Lockpath instance where all requests will be made.

    .PARAMETER InstancePort
        The portnumber of the Lockpath instance where all requests will be made.

    .PARAMETER LogPath
        The location of the log file where all activity will be written.

    .PARAMETER LogProcessId
        If specified, the Process ID of the current PowerShell session will be included in each
        log entry.  This can be useful if you have concurrent PowerShell sessions all logging
        to the same file, as it would then be possible to filter results based on ProcessId.

    .PARAMETER LogRequestBody
        If specified, the JSON body of the REST request will be logged to verbose output.
        This can be helpful for debugging purposes.

    .PARAMETER LogTimeAsUtc
        If specified, all times logged will be logged as UTC instead of the local timezone.

    .PARAMETER PageIndex
        The index of the page of result to return.

    .PARAMETER PageSize
        The size of the page results to return.

    .PARAMETER RunAsSystem
        Specifies if the records being imported or updated will show the created by and/or updated by attributes as
        the system. If set to false the creator and/or updated by attributes will be set to the account used to
        authenticate the API call.

    .PARAMETER SessionOnly
        By default, this method will store the configuration values in a local file so that changes
        persist across PowerShell sessions.  If this switch is provided, the file will not be
        created/updated and the specified configuration changes will only remain in memory/effect
        for the duration of this PowerShell session.

    .PARAMETER UserAgent
        The UserAgent string that is sent with each API request.

    .PARAMETER WebRequestTimeoutSec
        The number of seconds that should be allowed before an API request times out.  A value of
        0 indicates an infinite timeout, however experience has shown that PowerShell doesn't seem
        to always honor infinite timeouts.  Hence, this value can be configured if need be.

    .PARAMETER WebSession
        The WebSession object that it used to make subsequent API requests after the initial login.

    .EXAMPLE
        Set-LockpathConfiguration -InstanceName <yourhost>.keylightgrc.com

        Changes the Lockpath instance name to <yourhost>.keylightgrc.com. These settings will be persisted across future PowerShell sessions.

    .EXAMPLE
        Set-LockpathConfiguration -PageSize 1000 -SessionOnly

        Sets the pageSize value to 1000 for this session only.

    .INPUTS
        Microsoft.PowerShell.Commands.WebRequestSession, String, UInt32

    .OUTPUTS
        None.

    .NOTES
        None.

    .LINK
        https://github.com/RobertKlohr/PowerShellForLockpath/wiki
    #>

    [CmdletBinding(
        ConfirmImpact = 'Low',
        PositionalBinding = $false,
        SupportsShouldProcess = $true)]
    [OutputType('System.String')]

    [Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSShouldProcess', '', Justification = 'Methods called within here make use of PSShouldProcess, and the switch is passed on to them inherently.')]

    param(
        [securestring] $Credential,

        [ValidatePattern('^(?!https?:).*')]
        [String] $InstanceName,

        [ValidateRange(0, 65535)]
        [Int64] $InstancePort,

        [ValidatePattern('^https?$')]
        [String] $InstancePortocol,

        [String] $LogPath,

        [switch] $LogProcessId,

        [switch] $LogRequestBody,

        [switch] $LogTimeAsUtc,

        [ValidateRange('NonNegative')]
        [Int64] $PageIndex,

        [ValidateRange('Positive')]
        [Int64] $PageSize,

        [Boolean] $RunAsSystem,

        [switch] $SessionOnly,

        [ValidateLength(1, 256)]
        [String] $UserAgent,

        [ValidateRange('NonNegative')]
        [Int64] $WebRequestTimeoutSec,

        [Microsoft.PowerShell.Commands.WebRequestSession] $WebSession
    )

    $properties = Get-Member -InputObject $script:configuration -MemberType NoteProperty | Select-Object -ExpandProperty Name
    foreach ($name in $properties) {
        if ($PSBoundParameters.ContainsKey($name)) {
            $value = $PSBoundParameters.$name
            if ($value -is [switch]) {
                $value = $value.ToBool()
            }
            $script:configuration.$name = $value
        }
    }

    if (-not $SessionOnly) {
        try {
            $null = New-Item -Path $script:configuration.configurationFilePath -Force
            ConvertTo-Json -InputObject $script:configuration | Set-Content -Path $script:configuration.configurationFilePath -Force
            Write-LockpathLog -Message 'Successfully saved configuration to disk.' -Level Verbose
        } catch {
            Write-LockpathLog -Message 'Failed to save configuration to disk.  It will remain for this PowerShell session only.' -Level Warning
        }
    }
}
