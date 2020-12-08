function Initialize-LockpathLogExports {
    <#
    .SYNOPSIS
        Creates the folder structure used for extracting log files via the Ambassador service.

    .DESCRIPTION
        Creates the folder structure used for extracting log files via the Ambassador service.

        The Git repo for this module can be found here: https://github.com/RobertKlohr/PowerShellForLockpath

    .PARAMETER FilePath
        File path to the directory where the log files will be created.

    .PARAMETER Directory
        Array of directories to create.

    .EXAMPLE
        Initialize-LockpathLogExports -FilePath 'c:\temp\'

    .EXAMPLE
        Initialize-LockpathLogExports -FilePath 'c:\temp\' -Directory @('API', 'Audit', 'Email', 'Event', 'Job', 'Session')

    .INPUTS
        Array, System.IO.FileInfo

    .OUTPUTS
        None

    .NOTES
        <FilePath>
            API
            Audit
            Email
            Event
            Job
            Session

    .LINK
        https://github.com/RobertKlohr/PowerShellForLockpath/wiki
    #>

    [CmdletBinding(
        ConfirmImpact = 'Low',
        PositionalBinding = $false,
        SupportsShouldProcess = $true)]

    [Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSShouldProcess', '', Justification = 'Methods called within here make use of PSShouldProcess, and the switch is passed on to them inherently.')]

    param(
        [Parameter(
            Mandatory = $true,
            Position = 0)]
        [System.IO.FileInfo] $FilePath,

        [Array] $Directories = @('API', 'Audit', 'Email', 'Event', 'Job', 'Session')
    )

    Write-LockpathInvocationLog -Service PublicHelper

    ForEach ($Directory in $Directories) {
        New-Item -ItemType Directory -Path [FilePath]\$Directory
    }
}
