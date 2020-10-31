function Write-LockpathLog {
    #FIXME Update to new coding standards

    #FIXME Clean up help
    <#
    .SYNOPSIS
        Writes logging information to screen and log file simultaneously.

    .DESCRIPTION
        Writes logging information to screen and log file simultaneously.

        The Git repo for this module can be found here: https://github.com/RobertKlohr/PowerShellForLockpath

    .PARAMETER Message
        The message(s) to be logged. Each element of the array will be written to a separate line.

        This parameter supports pipelining but there are no performance benefits to doing so. For more information, see the .NOTES for this function.

    .PARAMETER Level
        The type of message to be logged.

    .PARAMETER Indent
        The number of spaces to indent the line in the log file.

    .PARAMETER FilePath
        The log file path.

        Defaults to log path set in the configuration.

    .PARAMETER Exception
        If present, the exception information will be logged after the messages provided.

        The actual string that is logged is obtained by passing this object to Out-String.

    .EXAMPLE
        Write-LockpathLog -Message "Everything worked." -Path C:\Debug.log

        Writes the message "Everything worked." to the screen as well as to a log file at "c:\Debug.log",
        with the caller's username and a date/time stamp prepended to the message.

    .EXAMPLE
        Write-LockpathLog -Message ("Everything worked.", "No cause for alarm.") -Path C:\Debug.log

        Writes the following message to the screen as well as to a log file at "c:\Debug.log",
        with the caller's username and a date/time stamp prepended to the message:

        Everything worked.
        No cause for alarm.

    .EXAMPLE
        Write-LockpathLog -Message "There may be a problem..." -Level Warning -Indent 2

        Writes the message "There may be a problem..." to the warning pipeline indented two spaces,
        as well as to the default log file with the caller's username and a date/time stamp
        prepended to the message.

    .EXAMPLE
        try { $null.Do() }
        catch { Write-LockpathLog -Message ("There was a problem.", "Here is the exception information:") -Exception $_ -Level Error }

        Logs the message:

        Write-LockpathLog : 2018-01-23 12:57:37 : username : There was a problem.
        Here is the exception information:
        You cannot call a method on a null-valued expression.
        At line:1 char:7
        + try { $null.Do() } catch { Write-LockpathLog -Message ("There was a problem." ...
        +       ~~~~~~~~~~
            + CategoryInfo          : InvalidOperation: (:) [], RuntimeException
            + FullyQualifiedErrorId : InvokeMethodOnNull

    .INPUTS
        String

    .NOTES
        The "LogPath" configuration value indicates where the log file will be created.

        Note that, although this function supports pipeline input to the -Message parameter, there is no
        performance benefit to using the pipeline. This is because the input is simply accumulated and not acted
        upon until all input has been received.

        This behavior is intentional, in order for a statement like:
            "Multiple", "messages" | WWrite-LockpathLog -Exception $ex -Level Error
        to make sense.  In this case, the function should accumulate the messages and, at the end, include the
        exception information.
#>

    [CmdletBinding(
        ConfirmImpact = 'Low',
        PositionalBinding = $false,
        SupportsShouldProcess = $true)]

    [Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSShouldProcess', '', Justification = 'Methods called within here make use of PSShouldProcess, and the switch is passed on to them inherently.')]

    [Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSAvoidGlobalVars', '', Justification = 'We need to be
    # able to access the PID for logging purposes, and it is accessed via a global variable.')]

    param(
        [Parameter(ValueFromPipeline)]
        [AllowEmptyCollection()]
        [AllowEmptyString()]
        [AllowNull()]
        [string[]] $Message = @(),

        [ValidateSet('Error', 'Warning', 'Informational', 'Verbose', 'Debug')]
        [String] $Level = 'Informational',

        [ValidateRange(1, 30)]
        [UInt16] $Indent = 0,

        [IO.FileInfo] $FilePath = (Get-LockpathConfiguration -Name 'logPath'),

        [System.Management.Automation.ErrorRecord] $Exception
    )

    Begin {
        # Accumulate the list of Messages, whether by pipeline or parameter.
        $messages = @()
    }

    Process {
        foreach ($m in $Message) {
            $messages += $m
        }
    }

    End {
        if ($null -ne $Exception) {
            # If we have an exception, add it after the accumulated messages.
            $messages += Out-String -InputObject $Exception
        } elseif ($messages.Count -eq 0) {
            # If no exception and no messages, we should early return.
            return
        }

        # Finalize the string to be logged.
        $finalMessage = $messages -join [Environment]::NewLine

        # Build the console and log-specific messages.
        $date = Get-Date
        $dateString = $date.ToString('yyyy-MM-dd HH:mm:ss')
        if (Get-LockpathConfiguration -Name LogTimeAsUtc) {
            $dateString = $date.ToUniversalTime().ToString('yyyy-MM-dd HH:mm:ssZ')
        }

        $consoleMessage = '{0}{1}' -f
        (' ' * $Indent),
        $finalMessage

        if (Get-LockpathConfiguration -Name 'logProcessId') {
            $maxPidDigits = 10 # This is an estimate (see https://stackoverflow.com/questions/17868218/what-is-the-maximum-process-id-on-windows)
            $pidColumnLength = $maxPidDigits + '[]'.Length
            $logFileMessage = "{0}{1} : {2, -$pidColumnLength} : {3} : {4} : {5}" -f
            (' ' * $Indent),
            $dateString,
            "[$global:PID]",
            $env:username,
            $Level.ToUpper(),
            $finalMessage
        } else {
            $logFileMessage = '{0}{1} : {2} : {3} : {4}' -f
            (' ' * $Indent),
            $dateString,
            $env:username,
            $Level.ToUpper(),
            $finalMessage
        }

        # Write the message to screen/log.
        # Note that the below logic could easily be moved to a separate helper function, but a conscious
        # decision was made to leave it here. When this function is called with -Level Error, Write-Error
        # will generate a WriteErrorException with the origin being Write-LockpathLog. If this call is moved to
        # a helper function, the origin of the WriteErrorException will be the helper function, which
        # could confuse an end user.
        switch ($Level) {
            # Need to explicitly say SilentlyContinue here so that we continue on, given that
            # we've assigned a script-level ErrorActionPreference of "Stop" for the module.
            'Error' {
                Write-Error $consoleMessage -ErrorAction SilentlyContinue
            }
            'Warning' {
                Write-Warning $consoleMessage
            }
            'Verbose' {
                Write-Verbose $consoleMessage
            }
            'Debug' {
                Write-Debug $consoleMessage
            }
            'Informational' {
                Write-Information $consoleMessage -InformationAction Continue
            }
        }

        try {
            if ([String]::IsNullOrWhiteSpace($FilePath)) {
                Write-Warning 'No path has been specified for the log file.  Use "Set-Configuration -LogPath" to set the log path.'
            } else {
                if (-not (Test-Path $FilePath)) {
                    New-Item -Path $FilePath -ItemType File -Force
                }
                $logFileMessage | Out-File -FilePath $FilePath -Append
            }
        } catch {
            $output = @()
            $output += "Failed to add log entry to [$FilePath]. The error was:"
            $output += Out-String -InputObject $_

            if (Test-Path -Path $FilePath -PathType Leaf) {
                # The file exists, but likely is being held open by another process.
                # Let's do best effort here and if we can't log something, just report
                # it and move on.
                $output += 'This is non-fatal, and your command will continue.  Your log file will be missing this entry:'
                $output += $consoleMessage
                Write-Warning ($output -join [Environment]::NewLine)
            } else {
                # If the file doesn't exist and couldn't be created, it likely will never
                # be valid.  In that instance, let's stop everything so that the user can
                # fix the problem, since they have indicated that they want this logging to
                # occur.
                throw ($output -join [Environment]::NewLine)
            }
        }
    }
}
