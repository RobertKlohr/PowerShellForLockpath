# Copyright (c) Robert Klohr. All rights reserved.
# Licensed under the MIT License.

function Initialize-LockpathLogExport {
    <#
    .SYNOPSIS
        Creates the folder structure used for extracting log files via the Ambassador service.

    .DESCRIPTION
        Creates the folder structure used for extracting log files via the Ambassador service.

        The Git repo for this module can be found here: https://git.io/powershellforlockpath

    .PARAMETER FilePath
        File path to the directory where the log files will be created.

    .PARAMETER Directory
        Array of directories to create.

    .EXAMPLE
        Initialize-LockpathLogExport -FilePath 'c:\temp\'

    .EXAMPLE
        Initialize-LockpathLogExport -FilePath 'c:\temp\' -Directory @('API', 'Audit', 'Email', 'Event', 'Job', 'Session')

    .INPUTS
        Array, System.IO.FileInfo

    .OUTPUTS
        Byte Stream

    .NOTES
        <FilePath>
            API
            Audit
            Email
            Event
            Job
            Session

    .LINK
        https://git.io/powershellforlockpathhelp
    #>

    [CmdletBinding(
        ConfirmImpact = 'Low',
        PositionalBinding = $false,
        SupportsShouldProcess = $true
    )]

    [OutputType([System.Void])]

    param(
        [System.IO.FileInfo] $FilePath = $Script:LockpathConfig.logPath,

        [Array] $Directories = @('API', 'Audit', 'Email', 'Event', 'Job', 'Session')
    )

    $level = 'Verbose'
    $functionName = ($PSCmdlet.CommandRuntime.ToString())
    $service = 'PublicHelper'

    $logParameters = [ordered]@{
        'FunctionName' = $functionName
        'Level'        = $level
        'Message'      = "Executing cmdlet: $functionName"
        'Service'      = $service
        'Result'       = "Executing cmdlet: $functionName"
    }

    Write-LockpathInvocationLog @logParameters

    $shouldProcessTarget = 'Initializing Log Export Directories.'

    if ($PSCmdlet.ShouldProcess($shouldProcessTarget)) {
        try {
            ForEach ($Directory in $Directories) {
                New-Item -ItemType Directory -Path [$FilePath]\$Directory -Force
            }
            $logParameters.Message = 'Success: ' + $shouldProcessTarget
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
