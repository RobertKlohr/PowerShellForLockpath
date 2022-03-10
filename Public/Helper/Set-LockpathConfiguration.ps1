# Copyright (c) Robert Klohr. All rights reserved.
# Licensed under the MIT License.

function Set-LockpathConfiguration {
    <#
    .SYNOPSIS
        Change the value of a configuration property for the module, for the session only, or saved to disk.

    .DESCRIPTION
        Change the value of a configuration property for the module, for the session only, or saved to disk.

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
        Set-LockpathConfiguration -InstanceName [instance].keylightgrc.com

        Changes the API instance name to [instance].keylightgrc.com. These settings will be persisted across future PowerShell sessions.

    .EXAMPLE
        Set-LockpathConfiguration -PageSize 1000 -SessionOnly

        Sets the pageSize value to 1000 for this session only.

    .INPUTS
        Array, Microsoft.PowerShell.Commands.WebRequestSession, String, UInt16, UInt32

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
        SupportsShouldProcess = $true
    )]

    [OutputType([System.String])]

    param(
        [ValidateSet('application/json', 'application/xml')]
        [String] $AcceptHeader,

        [Hashtable] $AuthenticationCookie,

        [System.IO.Path] $ConfigurationFilePath,

        [ValidateSet('application/json', 'application/xml')]
        [String] $ContentTypetHeader,

        [ValidateRange('Positive')]
        [UInt32] $conversionDepth,

        [PSCredential] $Credential,

        [System.IO.Path] $CredentialFilePath,

        [IO.FileInfo] $FilePath,

        [ValidatePattern('^(?!https?:).*')]
        [String] $InstanceName,

        [ValidateRange(0, 65535)]
        [UInt16] $InstancePort,

        [ValidatePattern('^https?$')]
        [String] $InstanceProtocol,

        [ValidateRange('Positive')]
        [UInt32] $KeepAliveInterval,

        [ValidateSet('Error', 'Warning', 'Information', 'Verbose', 'Debug')]
        [String] $LoggingLevel,

        [String] $LogPath,

        [Boolean] $LogRequestBody,

        [Boolean] $LogTimeAsUtc,

        [System.Collections.ArrayList] $MethodContainsBody,

        [ValidateRange('NonNegative')]
        [UInt32] $PageIndex,

        [ValidateRange('Positive')]
        [UInt32] $PageSize,

        [String] $ProcessId,

        [Boolean] $RunAsSystem,

        [Switch] $SessionOnly,

        [Hashtable] $SystemFields,

        [ValidateLength(1, 256)]
        [String] $UserAgent,

        [ValidateLength(1, 1024)]
        [String] $VendorName,

        [ValidateRange('NonNegative')]
        [UInt32] $WebRequestTimeoutSec,

        [Microsoft.PowerShell.Commands.WebRequestSession] $WebSession
    )

    $level = 'Verbose'
    $functionName = ($PSCmdlet.CommandRuntime.ToString())
    $service = 'PublicHelper'

    $logParameters = [ordered]@{
        'FunctionName' = $functionName
        'Level'        = $level
        'Message'      = $null
        'Service'      = $service
        'Result'       = $null
    }

    Write-LockpathInvocationLog @logParameters

    $shouldProcessTarget = 'Updating configuration.'

    if ($PSCmdlet.ShouldProcess($shouldProcessTarget)) {
        try {
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
            $logParameters.Message = 'Success: ' + $shouldProcessTarget
            if (-not $SessionOnly) {
                $shouldProcessTarget = "Updating configuration and saving persistent properties to file system at $($Script:LockpathConfig.configurationFilePath)."
                # make a copy of the configuration exceluding non-persistent properties
                $output = Select-Object -InputObject $Script:LockpathConfig -ExcludeProperty authenticationCookie, credential, productVersion, vendorName
                Export-Clixml -InputObject $output -Path $Script:LockpathConfig.configurationFilePath -Depth $Script:LockpathConfig.conversionDepth -Force
                $logParameters.Message = 'Success: ' + $shouldProcessTarget
            }
        } catch {
            $logParameters.Level = 'Error'
            $logParameters.Message = 'Failed: ' + $shouldProcessTarget
            $logParameters.Result = $_.Exception.Message
        } finally {
            Write-LockpathLog @logParameters
        }
        return $result
    }
}
