function Set-LockpathConfiguration {
    <#
    .SYNOPSIS
        Change the value of a configuration property for the module, for the session only, or saved to disk.

    .DESCRIPTION
        Change the value of a configuration property for the module, for the session only, or saved to disk.

        To change any of the Boolean/switch properties to false, specify the switch, immediately followed by
        ":$false" with no space.

        The Git repo for this module can be found here: https://git.io/powershellforlockpath

    .PARAMETER AcceptHeader
        The Accept Header for the APi request.

    .PARAMETER AuthenticationCookie
        The authentication cookie from the WebRequestSession object set during login.

    .PARAMETER ConfigurationFilePath
        The path to the configuration file.

    .PARAMETER Credential
        The username and password used to access the API instance.

    .PARAMETER CredentialFilePath
        The path to the credentail file.

    .PARAMETER FilePath
        The file that may or may not exist with a serialized version of the configuration values for this module.

    .PARAMETER InstanceName
        The URI of the API instance where all requests will be made.

        If just the host name is passed in the parameter '.keylightgrc.com' will be appended to the host name.

    .PARAMETER InstancePort
        The port number of the API instance where all requests will be made.

    .PARAMETER InstancePortocol
        The protocol (http, https) of the API instance where all requests will be made.

    .PARAMETER KeepAliveInterval
        The interval of the background job in minutes.

    .PARAMETER LoggingLevel
        The level of logging to write to the log file.  This is independent of console messages.

    .PARAMETER LogPath
        The location of the log file where all activity will be written.

    .PARAMETER LogRequestBody
        If specified, the JSON body of the REST request will be logged to verbose output. This can be helpful for
        debugging purposes.

    .PARAMETER LogTimeAsUtc
        If specified, all times logged will be logged as UTC instead of the local timezone.

    .PARAMETER MethodContainsBody
        Valid HTTP methods for this API that will include a message body.

    .PARAMETER PageIndex
        The index of the page of result to return.

    .PARAMETER PageSize
        The size of the page results to return.

    .PARAMETER ProcessId
        The Process ID of the current PowerShell session that will be included in each log entry.  This
        can be useful if you have concurrent PowerShell sessions all logging to the same file, as it would then be
        possible to filter results based on ProcessId. This value can be manually overwritten using
        Set-LockpathConfiguration to add a reusable tag to each PowerShell session.

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

        Changes the API instance name to <yourhost>.keylightgrc.com. These settings will be persisted across future PowerShell sessions.

    .EXAMPLE
        Set-LockpathConfiguration -PageSize 1000 -SessionOnly

        Sets the pageSize value to 1000 for this session only.

    .INPUTS
        Array, Microsoft.PowerShell.Commands.WebRequestSession, String, UInt32

    .OUTPUTS
        None.

    .NOTES
        Public helper method.

    .LINK
        https://git.io/powershellforlockpathhelp
    #>

    [CmdletBinding(
        ConfirmImpact = 'Low',
        PositionalBinding = $false,
        SupportsShouldProcess = $true)]
    [OutputType('System.String')]

    [Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSShouldProcess', '', Justification = 'Methods called within here make use of PSShouldProcess, and the switch is passed on to them inherently.')]

    param(
        [ValidateSet('application/json', 'application/xml')]
        [String] $AcceptHeader,

        [Hashtable] $AuthenticationCookie,

        [System.IO.Path] $ConfigurationFilePath,

        [ValidateSet('application/json', 'application/xml')]
        [String] $ContentTypetHeader,

        [SecureString] $Credential,

        [System.IO.Path] $CredentialFilePath,

        [IO.FileInfo] $FilePath,

        [ValidatePattern('^(?!https?:).*')]
        [String] $InstanceName,

        [ValidateRange(0, 65535)]
        [Int64] $InstancePort,

        [ValidatePattern('^https?$')]
        [String] $InstanceProtocol,

        [ValidateRange('Positive')]
        [Int32] $jsonConversionDepth,

        [ValidateRange('Positive')]
        [Int32] $KeepAliveInterval,

        [ValidateSet('Error', 'Warning', 'Information', 'Verbose', 'Debug')]
        [String] $LoggingLevel,

        [String] $LogPath,

        [Switch] $LogRequestBody,

        [Switch] $LogTimeAsUtc,

        [System.Collections.ArrayList] $MethodContainsBody,

        [ValidateRange('NonNegative')]
        [Int32] $PageIndex,

        [ValidateRange('Positive')]
        [Int32] $PageSize,

        [String] $ProcessId,

        [Boolean] $RunAsSystem,

        [Switch] $SessionOnly,

        [Hashtable] $SystemFields,

        [ValidateLength(1, 256)]
        [String] $UserAgent,

        [ValidateLength(1, 1024)]
        [String] $VendorName,

        [ValidateRange('NonNegative')]
        [Int64] $WebRequestTimeoutSec,

        [Microsoft.PowerShell.Commands.WebRequestSession] $WebSession
    )

    $level = 'Verbose'
    $functionName = ($PSCmdlet.CommandRuntime.ToString())
    $service = 'PublicHelper'

    Write-LockpathInvocationLog -Confirm:$false -WhatIf:$false -FunctionName $functionName -Level $level -Service $service

    $properties = Get-Member -InputObject $Script:LockpathConfig -MemberType NoteProperty | Select-Object -ExpandProperty Name
    foreach ($name in $properties) {
        if ($PSBoundParameters.ContainsKey($name)) {
            $value = $PSBoundParameters.$name
            if ($value -is [Switch]) {
                $value = $value.ToBool()
            }
            # If just the hostname is passed in $InstanceName then add '.keylightgrc.com' to the end of $InstanceName
            if ($name -eq 'instanceName' -and $InstanceName.IndexOf('.') -eq -1) {
                $value = $value + '.keylightgrc.com'
            }
            $Script:LockpathConfig.$name = $value
        }
    }

    if (-not $SessionOnly) {
        try {
            # make a copy of the configuration exceluding non-persistent properties
            $output = Select-Object -InputObject $Script:LockpathConfig -ExcludeProperty authenticationCookie, credential, productName, productVersion, vendorName
            Export-Clixml -InputObject $output -Path $Script:LockpathConfig.configurationFilePath -Depth 10 -Force
            Write-LockpathLog -Confirm:$false -WhatIf:$false -Message 'Successfully saved configuration to disk.' -Level $level
        } catch {
            Write-LockpathLog -Confirm:$false -WhatIf:$false -Message 'Failed to save configuration to disk. It will remain for this PowerShell session only.' -Level $level
        }
    }
    Show-LockpathConfiguration
}
