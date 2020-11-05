function Initialize-LockpathLogExports {

    #FIXME Clean up help
    <#
    .SYNOPSIS
        Creates the folder structure used for extracting log files via the Ambassador service.

    .DESCRIPTION
        Creates the folder structure used for extracting log files via the Ambassador service.

        The Git repo for this module can be found here: https://github.com/RobertKlohr/PowerShellForLockpath

    .PARAMETER FilePath


    .PARAMETER Directory


        #TODO need to complete the examples
    .EXAMPLE
        Initialize-LockpathLogExports

        Local

    .EXAMPLE
        Initialize-LockpathLogExports

        Mapped drive

    .EXAMPLE
        Initialize-LockpathLogExports

        UNC path

    .INPUTS
        None

    .OUTPUTS
        None

    .NOTES
        <logPath>
            API
            Audit
            Email
            Event
            Job
            Session

    .LINK
        https://github.com/RobertKlohr/PowerShellForLockpath/wiki
    #>

    # TODO add log filepath to configuration variable

    [CmdletBinding(
        ConfirmImpact = 'Low',
        PositionalBinding = $false,
        SupportsShouldProcess = $true)]

    [Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSShouldProcess', '', Justification = 'Methods called within here make use of PSShouldProcess, and the switch is passed on to them inherently.')]

    param(
        [IO.FileInfo] $FilePath = (Get-LockpathConfiguration -Name 'logPath'),

        [Array] $Directories = @('API', 'Audit', 'Email', 'Event', 'Job', 'Session')
    )

    Write-LockpathInvocationLog -ExcludeParameter FilePath -Confirm:$false -WhatIf:$false

    ForEach ($Directory in $Directories) {
        New-Item -ItemType Directory -Path [FilePath]\$Directory
    }
}
