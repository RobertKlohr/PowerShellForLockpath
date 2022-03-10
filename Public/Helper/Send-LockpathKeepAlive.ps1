# Copyright (c) Robert Klohr. All rights reserved.
# Licensed under the MIT License.

function Send-LockpathKeepAlive {
    <#
    .SYNOPSIS
        Refreshes a valid session.

    .DESCRIPTION
        Refreshes a valid session.

        The Git repo for this module can be found here: https://git.io/powershellforlockpath

    .PARAMETER KeepAliveInterval
        The interval of the background job in minutes.

    .EXAMPLE
        Send-LockpathKeepAlive

    .INPUTS
        [UInt32]

    .OUTPUTS
        System.Management.Automation.PSRemotingJob

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
        [Parameter(
            Position = 0
        )]
        [ValidateRange('Positive')]
        [UInt32] $KeepAliveInterval = $Script:LockpathConfig.keepAliveInterval
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

#TODO need to update

    # clean up any existing jobs
    $jobs = Get-Job
    if ($null -ne $jobs) {
        Stop-Job $jobs
        Remove-Job $jobs
    }

    try {
        Send-LockpathPing
        Set-LockpathConfiguration
    } catch {
        Write-LockpathLog -Confirm:$false -WhatIf:$false -Message 'The authentication cookie is not valid. You must first use Send-LockpathLogin to capture a valid authentication coookie and Set-LockpathConfiguration to save it to disk to run Send-LockpathKeepAlive.' -Level $level
    }

    # the value in the configuration file is minutes so we need to multiple by 60 to get seconds
    $KeepAliveInterval *= 60

    Start-Job -Name 'Lockpath-KeepAlive' -ScriptBlock {
        while ($true) {
            Send-LockpathPing
            Start-Sleep -Seconds $using:KeepAliveInterval
        }
    }
}
