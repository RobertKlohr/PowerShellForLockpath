﻿# Copyright (c) Robert Klohr. All rights reserved.
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
        [Parameter(
            Mandatory = $true,
            Position = 0
        )]
        [System.IO.FileInfo] $FilePath,

        [Array] $Directories = @('API', 'Audit', 'Email', 'Event', 'Job', 'Session')
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

    #TODO add try catch around creating the folder and what happens if they already exist
    ForEach ($Directory in $Directories) {
        New-Item -ItemType Directory -Path [$FilePath]\$Directory -Force
    }
}
