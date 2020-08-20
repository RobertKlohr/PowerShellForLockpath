function Write-LockpathLog {
    [CmdletBinding(SupportsShouldProcess)]

    [Diagnostics.CodeAnalysis.SuppressMessageAttribute("PSShouldProcess", "", Justification = "Methods called within here make use of PSShouldProcess, and the switch is passed on to them inherently.")]

    [Diagnostics.CodeAnalysis.SuppressMessageAttribute("PSAvoidGlobalVars", "", Justification = "We need to be able to access the PID for logging purposes, and it is accessed via a global variable.")]

    param(
        [Parameter(ValueFromPipeline)]
        [AllowEmptyCollection()]
        [AllowEmptyString()]
        [AllowNull()]
        [string[]] $Message = @(),

        [ValidateSet('Error', 'Warning', 'Informational', 'Verbose', 'Debug')]
        [string] $Level = 'Informational',

        [ValidateRange(1, 30)]
        [Int16] $Indent = 0,

        [IO.FileInfo] $Path = (Get-LockpathConfiguration -Name LogPath),

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
        $dateString = $date.ToString("yyyy-MM-dd HH:mm:ss")
        if (Get-LockpathConfiguration -Name LogTimeAsUtc) {
            $dateString = $date.ToUniversalTime().ToString("yyyy-MM-dd HH:mm:ssZ")
        }

        $consoleMessage = '{0}{1}' -f
        (" " * $Indent),
        $finalMessage

        $logFileMessage = '{0}{1} : {2} : {3} : {4}' -f
        (" " * $Indent),
        $dateString,
        $env:username,
        $Level.ToUpper(),
        $finalMessage

        # Write the message to screen/log.
        # Note that the below logic could easily be moved to a separate helper function, but a conscious
        # decision was made to leave it here. When this cmdlet is called with -Level Error, Write-Error
        # will generate a WriteErrorException with the origin being Write-Log. If this call is moved to
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
            if ([String]::IsNullOrWhiteSpace($Path)) {
                Write-Warning 'No path has been specified for the log file.  Use "Set-Configuration -LogPath" to set the log path.'
            } else {
                if (-not (Test-Path $Path)) {
                    New-Item -Path $Path -ItemType File -Force
                }
                $logFileMessage | Out-File -FilePath $Path -Append
            }
        } catch {
            $output = @()
            $output += "Failed to add log entry to [$Path]. The error was:"
            $output += Out-String -InputObject $_

            if (Test-Path -Path $Path -PathType Leaf) {
                # The file exists, but likely is being held open by another process.
                # Let's do best effort here and if we can't log something, just report
                # it and move on.
                $output += "This is non-fatal, and your command will continue.  Your log file will be missing this entry:"
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
