# Copyright (c) Robert Klohr. All rights reserved.
# Licensed under the MIT License.

function Write-LockpathLog {
    <#
    .SYNOPSIS
        Writes logging information to screen and log file simultaneously.

    .DESCRIPTION
        Writes logging information to screen and log file simultaneously.

        The Git repo for this module can be found here: https://git.io/powershellforlockpath

    .PARAMETER ErrorRecord
        If present, the exception information will be logged after the messages provided.

        The actual string that is logged is obtained by passing this object to Out-String.

    .PARAMETER FilePath
        The log file path.

        Defaults to log path set in the configuration.

    .PARAMETER FunctionName
        The name of the calling function creating the log entry.

    .PARAMETER Level
        The type of message to be logged.

    .PARAMETER Message
        The message(s) to be logged. Each element of the array will be written to a separate line.

    .PARAMETER Result
        The response message from the API call.

    .PARAMETER Service
        Either the API service being called a helper service.

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
        PositionalBinding = $false
    )]

    [OutputType([System.Void])]

    param(
        [Parameter(
            ValueFromPipeline = $true,
            ValueFromPipelineByPropertyName = $true
        )]
        [System.Management.Automation.ErrorRecord] $ErrorRecord,

        [Parameter(
            ValueFromPipeline = $true,
            ValueFromPipelineByPropertyName = $true
        )]
        [System.IO.FileInfo] $FilePath = $Script:LockpathConfig.logPath,

        [Parameter(
            Mandatory = $true,
            ValueFromPipeline = $true,
            ValueFromPipelineByPropertyName = $true
        )]
        [String] $FunctionName,

        [Parameter(
            ValueFromPipeline = $true,
            ValueFromPipelineByPropertyName = $true
        )]
        [ValidateSet('Error', 'Warning', 'Information', 'Verbose', 'Debug')]
        [String] $Level = $Script:LockpathConfig.loggingLevel,

        [Parameter(
            Mandatory = $true,
            Position = 0,
            ValueFromPipeline = $true,
            ValueFromPipelineByPropertyName = $true
        )]
        [AllowEmptyCollection()]
        [AllowEmptyString()]
        [AllowNull()]
        [String] $Message,

        [Parameter(
            ValueFromPipeline = $true,
            ValueFromPipelineByPropertyName = $true
        )]
        [String] $Result,

        [Parameter(
            Mandatory = $true,
            ValueFromPipeline = $true,
            ValueFromPipelineByPropertyName = $true
        )]
        [ValidateSet('AssessmentService', 'ComponentService', 'ReportService', 'SecurityService', 'PrivateHelper', 'PublicHelper')]
        [String] $Service

        # 'CefHeaderDeviceVendor' = $moduleName
        # 'CefHeaderDeviceProduct' = $moduleName
        # 'CefHeaderDeviceVersion' = $moduleVersion
        # 'CefHeaderDeviceEventClassId' = $functionName
        # 'CefHeaderName' = $a
        # 'CefHeaderSeverity' = 'Unknown'
        # 'CefExtensionEnd' = $a
        # 'CefExtensionFilePath' = $a
        # 'CefExtensionFileSize' = $a
        # 'CefExtensionMsg' = $msg
        # 'CefExtensionOutcome' = $a
        # 'CefExtensionReason' = $a
        # 'CefExtensionRequest' = $a
        # 'CefExtensionRequestMethod' = $a
        # 'CefExtensionSourceServiceName' = $a
        # 'CefExtensionSourceProcessId' = $a
        # 'CefExtensionSourceUserName' = $a
        # 'CefExtensionSourceHostName' = $a
        # 'CefExtensionStart' = $a

        # #Possible CEF Extension Message Values
        # [UInt32] $dpdt,
        # [String] $duser,
        # [DateTime] $end,
        # [String] $filePath,
        # [String] $fname,
        # [UInt32] $fsize,
        # [UInt32] $in,
        # [UInt32] $out,
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
                $WarningPreference = 'continue'
                $InformationPreference = 'SilentlyContinue'
                $VerbosePreference = 'SilentlyContinue'
                $DebugPreference = 'SilentlyContinue'
            }
            'Information' {
                $loggingLevel = 2
                $WarningPreference = 'continue'
                $InformationPreference = 'continue'
                $VerbosePreference = 'SilentlyContinue'
                $DebugPreference = 'SilentlyContinue'
            }
            'Verbose' {
                $loggingLevel = 3
                $WarningPreference = 'continue'
                $InformationPreference = 'continue'
                $VerbosePreference = 'continue'
                $DebugPreference = 'SilentlyContinue'
            }
            'Debug' {
                $loggingLevel = 4
                $WarningPreference = 'continue'
                $InformationPreference = 'continue'
                $VerbosePreference = 'continue'
                $DebugPreference = 'continue'
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
        # CEF msg: An arbitrary message giving more details about the event.
        If ($Result -eq '') {
            $msg = 'msg=' + $Message
        } else {
            $msg = 'msg=' + $Result
        }

        # CEF rt: The time at which the event related to the activity was received.
        if ($Script:LockpathConfig.logTimeAsUtc) {
            $rt = 'rt=' + (Get-Date -AsUTC -Format 'MMM dd yyyy HH:mm:ss.fff zzz')
        } else {
            $rt = 'rt=' + (Get-Date -Format 'MMM dd yyyy HH:mm:ss.fff zzz')
        }

        # CEF shost: The format should be a fully qualified domain name (FQDN) associated with the source node.
        $shost = 'shost=' + ("$env:computername.$env:userdnsdomain").ToLower()

        # CEF sourceServiceName: The service that is responsible for generating this event.
        $sourceServiceName = 'sourceServiceName=PowerShell'

        # CEF spid: The ID of the source process associated with the event.
        $spid = 'spid=' + ($Script:LockpathConfig.ProcessId)

        # CEF suser: Identifies the source user by name.
        $suser = 'suser=' + ($env:username)

        $cefExtension = $rt, $sourceServiceName, $shost, $spid, $suser, $msg -join ' '

        # Write the message to screen and set CEF severity for logging.
        switch ($Level) {
            'Error' {
                $logMessageLevel = 0
                $cefHeaderSeverity = 'High'
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
                Write-Warning 'No path has been specified for the log file.  Use "Set-LockpathConfiguration -LogPath" to set the log path.'
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
                # The file exists, but mostly likely locked by another process.
                # If we are not able to write the log entry, report it and continue.
                $output += 'This is non-fatal, and your command will continue.  Your log file will be missing this entry:'
                $output += $consoleMessage
                Write-Warning ($output -join [Environment]::NewLine)
            } else {
                # If the file doesn't exist and couldn't be created, it likely will never work.
                # If that happens throw an stop the module so that the user can fix the problem.
                throw ($output -join [Environment]::NewLine)
            }
        }
    }
}
