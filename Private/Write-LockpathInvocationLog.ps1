# Copyright (c) Robert Klohr. All rights reserved.
# Licensed under the MIT License.

function Write-LockpathInvocationLog {
    <#
    .SYNOPSIS
        Writes a log entry for the invoke command.

    .DESCRIPTION
        Writes a log entry for the invoke command.

        The Git repo for this module can be found here: https://git.io/powershellforlockpath

    .PARAMETER ExcludeParameter
        An optional array of parameter names that should simply not be logged.

    .PARAMETER FunctionName
        The name of the calling function creating the log entry.

    .PARAMETER InvocationInfo
        The '$MyInvocation' object from the calling function.

        No need to explicitly provide this if you're trying to log the immediate function this is being   called from.

    .PARAMETER Level
        The type of message to be logged.

    .PARAMETER Message
        The message(s) to be logged. Each element of the array will be written to a separate line.

    .PARAMETER RedactParameter
        An optional array of parameter names that should be logged, but their values redacted.

    .PARAMETER Result
        The response message from the API call.

    .PARAMETER Service
        Either the API service being called a helper service.

    .EXAMPLE
        Write-LockpathInvocationLog -Confirm:$false -WhatIf:$false -FunctionName $functionName  -Level $level -Message $message -Results $result -Service $service

    .EXAMPLE
        Write-LockpathInvocationLog -Confirm:$false -WhatIf:$false -FunctionName $functionName  -Level $level -Service $service -ExcludeParameter ('Body')

    .INPUTS
        Management.Automation.InvocationInfo, String

    .OUTPUTS
        None.

    .NOTES
        Private helper method.

        ExcludeParameter will always take precedence over RedactParameter.

        This function is derived from the Write-InvocationLog function in the PowerShellForGitHub module at
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
        [String[]] $ExcludeParameter,

        [String] $FunctionName = ($PSCmdlet.CommandRuntime.ToString()),

        [Management.Automation.InvocationInfo] $Invocation = (Get-Variable -Name MyInvocation -Scope 1 -ValueOnly),

        [String] $level = 'Debug',

        [String] $Message,

        [String[]] $RedactParameter,

        [String] $Result,

        [ValidateSet('AssessmentService', 'ComponentService', 'ReportService', 'SecurityService', 'PrivateHelper', 'PublicHelper')]
        [String] $Service
    )

    if ($Script:LockpathConfig.loggingLevel -ne 'Debug') {
        return
    }

    # Build up the invoked line, being sure to exclude and/or redact any values necessary
    $functionParameters = @()
    foreach ($parameter in $Invocation.BoundParameters.GetEnumerator()) {
        if ($parameter.Key -in ($ExcludeParameter)) {
            continue
        }
        if ($parameter.Key -in ($RedactParameter)) {
            $functionParameters += "-$($parameter.Key) <redacted>"
        } else {
            if ($parameter.Value -is [Switch]) {
                $functionParameters += "-$($parameter.Key):`$$($parameter.Value.ToBool().ToString().ToLower())"
            } else {
                $functionParameters += "-$($parameter.Key) $(ConvertTo-Json -Compress -Depth $Script:LockpathConfig.conversionDepth -InputObject $parameter.Value)"
            }
        }
    }

    $logParameters = [ordered]@{
        'FunctionName' = $functionName
        'Level'        = $level
        'Message'      = $message
        'Service'      = $service
        'Result'       = "$Result $($functionParameters -join ' ')".Trim()
    }

    Write-LockpathLog @logParameters
}
