function Write-LockpathLog {
    <#
    .SYNOPSIS
        Writes logging information to screen and log file simultaneously.

    .DESCRIPTION
        Writes logging information to screen and log file simultaneously.

        The Git repo for this module can be found here: https://git.io/powershellforlockpath

    .PARAMETER Message
        The message(s) to be logged. Each element of the array will be written to a separate line.

    .PARAMETER Level
        The type of message to be logged.

    .PARAMETER FilePath
        The log file path.

        Defaults to log path set in the configuration.

    .PARAMETER Exception
        If present, the exception information will be logged after the messages provided.

        The actual string that is logged is obtained by passing this object to Out-String.

    .EXAMPLE
        Write-LockpathLog -Confirm:$false -WhatIf:$false -Message "Everything worked." -Path "c:\Temp\PowerShellForLockpath.log"

        Writes the message "Everything worked." to the screen as well as to a log file at "c:\Temp\PowerShellForLockpath.log", with the caller's username and a date/time stamp prepended to the message.

    .EXAMPLE
        Write-LockpathLog -Confirm:$false -WhatIf:$false -Message ("Everything worked.", "No cause for alarm.") -Path "c:\Temp\PowerShellForLockpath.log"

        Writes the following message to the screen as well as to a log file at "c:\Temp\PowerShellForLockpath.log",
        with the caller's username and a date/time stamp prepended to the message:

        Everything worked.
        No cause for alarm.

    .EXAMPLE
        Write-LockpathLog -Confirm:$false -WhatIf:$false -Message "There may be a problem..." -Level $level

        Writes the message "There may be a problem..." to the warning pipeline,
        as well as to the default log file with the caller's username and a date/time stamp
        prepended to the message.

    .INPUTS
        String

    .OUTPUTS
        None.

    .NOTES
        Private helper method.

        The "LogPath" configuration value indicates where the log file will be created.

        This function is derived from the Write-Log function in the PowerShellForGitHub module at
        https://aka.ms/PowerShellForGitHub

    .LINK
        https://git.io/powershellforlockpathhelp
    #>

    [CmdletBinding(
        ConfirmImpact = 'Low',
        PositionalBinding = $false,
        SupportsShouldProcess = $true)]

    [Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSShouldProcess', '', Justification = 'Methods called within here make use of PSShouldProcess, and the switch is passed on to them inherently.')]

    param(
        [Parameter(ValueFromPipeline = $true,
            ValueFromPipelineByPropertyName = $true)]
        [AllowEmptyCollection()]
        [AllowEmptyString()]
        [AllowNull()]
        # FIXME does this need to be an array or will it always be just a string?
        # [String[]] $Message = @(),
        # Switching to string to test
        [String] $Message,

        [Parameter(ValueFromPipeline = $true,
            ValueFromPipelineByPropertyName = $true)]
        [ValidateSet('AssessmentService', 'ComponentService', 'ReportService', 'SecurityService', 'PrivateHelper', 'PublicHelper')]
        [String] $Service,

        [System.Management.Automation.ErrorRecord] $ErrorRecord,

        [System.IO.FileInfo] $FilePath = $Script:LockpathConfig.logPath,

        [String] $FunctionName,

        [ValidateSet('Error', 'Warning', 'Information', 'Verbose', 'Debug')]
        [String] $Level = $Script:LockpathConfig.loggingLevel,

        [String] $Result

        # #Possible CEF Extension Message Values
        # [Int32] $dpdt,
        # [String] $duser,
        # [DateTime] $end,
        # #[String] $filePath,
        # [String] $fname,
        # [Int32] $fsize,
        # [Int32] $in,
        # [Int32] $out,
        # [String] $outcome,
        # [String] $reason,
        # [String] $request,
        # [String] $requestClientApplication,
        # [String] $requestContext,
        # [String] $requestMethod,
        # [DateTime] $start
    )

    begin {
        # Accumulate the list of Messages, whether by pipeline or parameter.
        $messages = @()
        $cefHeaderDeviceVendor = $Script:LockpathConfig.vendorName
        $cefHeaderDeviceVersion = $Script:LockpathConfig.productVersion
        $cefHeaderVersion = 'CEF:0'
        switch ($Script:LockpathConfig.loggingLevel) {
            'Error' {
                $loggingLevel = 0
            }
            'Warning' {
                $loggingLevel = 1
            }
            'Information' {
                $loggingLevel = 2
            }
            'Verbose' {
                $loggingLevel = 3
            }
            'Debug' {
                $loggingLevel = 4
            }
            Default {
                $loggingLevel = 0
            }
        }
    }

    process {
        foreach ($m in $Message) {
            $messages += $m
        }
    }

    end {

        if ($null -ne $ErrorRecord) {
            # If we have an exception, add it after the accumulated messages.
            $messages += $ErrorRecord.Exception.Message
        } elseif ($messages.Count -eq 0) {
            # If no exception and no messages return early.
            return
        }

        $consoleMessage = $messages -join ' '

        # Build the CEF extension message

        # msg: An arbitrary message giving more details about the event.
        # FIXME update all functions to pass the result to write-lockpathlog (3)
        If ($Result -eq '') {
            $msg = 'msg=' + $Message
        } else {
            $msg = 'msg=' + $Result
        }

        # rt: The time at which the event related to the activity was received.
        if ($Script:LockpathConfig.logTimeAsUtc) {
            $rt = 'rt=' + (Get-Date -AsUTC -Format 'MMM dd yyyy HH:mm:ss.fff zzz')
        } else {
            $rt = 'rt=' + (Get-Date -Format 'MMM dd yyyy HH:mm:ss.fff zzz')
        }

        # shost: The format should be a fully qualified domain name (FQDN) associated with the source node.
        $shost = 'shost=' + ("$env:computername.$env:userdnsdomain").ToLower()

        # sourceServiceName: The service that is responsible for generating this event.
        $sourceServiceName = 'sourceServiceName=PowerShell'

        # spid: The ID of the source process associated with the event.
        $spid = 'spid=' + ($Script:LockpathConfig.ProcessId)

        # suser: Identifies the source user by name.
        $suser = 'suser=' + ($env:username)

        $cefExtension = $rt, $sourceServiceName, $shost, $spid, $suser, $msg -join ' '

        # Write the message to screen and set severity for logging.
        switch ($Level) {
            # Need to explicitly say SilentlyContinue here so that we continue on, given that we've assigned a
            # script-level ErrorActionPreference of "Stop" for the module.
            'Error' {
                $logMessageLevel = 0
                $cefHeaderSeverity = 'High'
                # FIXME validate the ErrorAction setting and the above script-level setting
                # Write-Error $consoleMessage -ErrorAction SilentlyContinue
                Write-Error $consoleMessage
            }
            'Warning' {
                $logMessageLevel = 1
                $cefHeaderSeverity = 'Medium'
                Write-Warning $consoleMessage
            }
            'Information' {
                $logMessageLevel = 2
                $cefHeaderSeverity = 'Low'
                Write-Information $consoleMessage
            }
            'Verbose' {
                $logMessageLevel = 3
                $cefHeaderSeverity = 'Low'
                Write-Verbose $consoleMessage
            }
            'Debug' {
                $logMessageLevel = 4
                $cefHeaderSeverity = 'Low'
                Write-Debug $consoleMessage
            }
        }
        if ($logMessageLevel -gt $loggingLevel) {
            return
        }

        # Set build CEF log entry
        $cefHeaderDeviceEventClassID = $FunctionName
        $cefHeaderDeviceProduct = $Service
        $cefHeaderName = $Message

        $cefLogEntry = $cefHeaderVersion, $cefHeaderDeviceVendor, $cefHeaderDeviceProduct, $cefHeaderDeviceVersion, $cefHeaderDeviceEventClassID, $cefHeaderName, $cefHeaderSeverity, $cefExtension -join '|'

        # Write CEF log entry to file.
        try {
            if ([String]::IsNullOrWhiteSpace($FilePath)) {
                Write-Warning 'No path has been specified for the log file.  Use "Set-Configuration -LogPath" to set the log path.'
            } else {
                if (-not (Test-Path $FilePath)) {
                    $null = New-Item -Path $FilePath -ItemType File -Force
                }
                $cefLogEntry | Out-File -FilePath $FilePath -Append
            }
        } catch {
            $output = @()
            $output += "Failed to add log entry to [$FilePath]. The error was:"
            $output += Out-String -InputObject $_

            if (Test-Path -Path $FilePath -PathType Leaf) {
                # The file exists, but likely is being held open by another process.
                # Let's do best effort here and if we can't log something, just report it and move on.
                $output += 'This is non-fatal, and your command will continue.  Your log file will be missing this entry:'
                $output += $consoleMessage
                Write-Warning ($output -join [Environment]::NewLine)
            } else {
                # If the file doesn't exist and couldn't be created, it likely will never  be valid. In that
                # instance, let's stop everything so that the user can fix the problem, since they have indicated
                # that they want this logging to occur.
                throw ($output -join [Environment]::NewLine)
            }
        }
    }
}
