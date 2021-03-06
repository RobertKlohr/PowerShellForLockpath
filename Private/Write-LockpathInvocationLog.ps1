﻿function Write-LockpathInvocationLog {
    <#
    .SYNOPSIS
        Writes a log entry for the invoke command.

    .DESCRIPTION
        Writes a log entry for the invoke command.

        The Git repo for this module can be found here: https://git.io/powershellforlockpath

    .PARAMETER InvocationInfo
        The '$MyInvocation' object from the calling function.

        No need to explicitly provide this if you're trying to log the immediate function this is being called from.

    .PARAMETER RedactParameter
        An optional array of parameter names that should be logged, but their values redacted.

    .PARAMETER ExcludeParameter
        An optional array of parameter names that should simply not be logged.

    .EXAMPLE
        Write-LockpathInvocationLog -Confirm:$false -WhatIf:$false -FunctionName $functionName  -Level $level -Service $service

    .EXAMPLE
        Write-LockpathInvocationLog -Confirm:$false -WhatIf:$false -FunctionName $functionName  -Level $level -Service $service

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

    # FIXME migrate this function to just use write-lockpathlog

    [CmdletBinding(
        ConfirmImpact = 'Low',
        PositionalBinding = $false,
        SupportsShouldProcess = $true)]

    [Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSShouldProcess', '', Justification = 'Methods called within here make use of PSShouldProcess, and the switch is passed on to them inherently.')]

    param(
        [ValidateSet('AssessmentService', 'ComponentService', 'ReportService', 'SecurityService', 'PrivateHelper', 'PublicHelper')]
        [String] $Service,

        [String[]] $ExcludeParameter,

        [String] $FunctionName = ($PSCmdlet.CommandRuntime.ToString()),

        [Management.Automation.InvocationInfo] $Invocation = (Get-Variable -Name MyInvocation -Scope 1 -ValueOnly),

        [String] $level = 'Debug',

        [String[]] $RedactParameter

    )

    # FIXME This section is not working

    # Build up the invoked line, being sure to exclude and/or redact any values necessary
    $restParameters = @()
    foreach ($parameter in $Invocation.BoundParameters.GetEnumerator()) {
        if ($parameter.Key -in ($ExcludeParameter)) {
            continue
        }
        if ($parameter.Key -in ($RedactParameter)) {
            $restParameters += "-$($parameter.Key) <redacted>"
        } else {
            if ($parameter.Value -is [Switch]) {
                $restParameters += "-$($parameter.Key):`$$($parameter.Value.ToBool().ToString().ToLower())"
            } else {
                $restParameters += "-$($parameter.Key) $(ConvertTo-Json -Depth $Script:LockpathConfig.jsonConversionDepth -Compress -InputObject $parameter.Value)"
            }
        }
    }
    Write-LockpathLog -Confirm:$false -WhatIf:$false -FunctionName $functionName -Level $Level -Service $service -Message "Executing: $functionName $($restParameters -join ' ')".Trim()
}
