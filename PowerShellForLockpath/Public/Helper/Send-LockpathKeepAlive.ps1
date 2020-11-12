function Send-LockpathKeepAlive {
    <#
    .SYNOPSIS
        Refreshes a valid session.

    .DESCRIPTION
        Refreshes a valid session.

        The Git repo for this module can be found here: https://github.com/RobertKlohr/PowerShellForLockpath

    .PARAMETER KeepAliveInterval
        The interval of the background job in minutes.

    .EXAMPLE
        Send-LockpathKeepAlive

    .INPUTS
        [Int32]

    .OUTPUTS
        System.Management.Automation.PSRemotingJob

    .NOTES
        Public helper method.

    .LINK
        https://github.com/RobertKlohr/PowerShellForLockpath/wiki
    #>

    [CmdletBinding(
        ConfirmImpact = 'Low',
        PositionalBinding = $false,
        SupportsShouldProcess = $true)]
    [OutputType('System.String')]

    param(
        [Parameter(
            Position = 0
        )]
        [ValidateRange('Positive')]
        [Int32] $KeepAliveInterval = $script:configuration.keepAliveInterval
    )

    Write-LockpathInvocationLog -Confirm:$false -WhatIf:$false

    # clean up any existing jobs
    $jobs = Get-Job
    if ($null -ne $jobs) {
        Stop-Job $jobs
        Remove-Job $jobs
    }

    # the value in the configuration file is minutes so we need to multiple by 60 to get seconds
    $KeepAliveInterval *= 60

    Start-Job -Name 'Lockpath-KeepAlive' -ScriptBlock {
        while ($true) {
            Set-PSBreakpoint -Command 'Write-LockpathLog'
            Send-LockpathPing
            Start-Sleep -Seconds $using:KeepAliveInterval
        }
    }
}
