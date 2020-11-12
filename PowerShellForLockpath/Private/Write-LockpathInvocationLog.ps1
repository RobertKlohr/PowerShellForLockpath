function Write-LockpathInvocationLog {
    <#
    .SYNOPSIS
        Writes a log entry for the invoke command.

    .DESCRIPTION
        Writes a log entry for the invoke command.

        The Git repo for this module can be found here: https://github.com/RobertKlohr/PowerShellForLockpath

    .PARAMETER InvocationInfo
        The '$MyInvocation' object from the calling function.

        No need to explicitly provide this if you're trying to log the immediate function this is being called from.

    .PARAMETER RedactParameter
        An optional array of parameter names that should be logged, but their values redacted.

    .PARAMETER ExcludeParameter
        An optional array of parameter names that should simply not be logged.

    .EXAMPLE
        Write-LockpathInvocationLog -Invocation $MyInvocation

    .EXAMPLE
        Write-LockpathInvocationLog -Invocation $MyInvocation -ExcludeParameter @('Properties', 'Metrics')

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
    https://github.com/RobertKlohr/PowerShellForLockpath/wiki
    #>

    [CmdletBinding(
        ConfirmImpact = 'Low',
        PositionalBinding = $false,
        SupportsShouldProcess = $true)]

    [Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSShouldProcess', '', Justification = 'Methods called within here make use of PSShouldProcess, and the switch is passed on to them inherently.')]

    param(
        [Management.Automation.InvocationInfo] $Invocation = (Get-Variable -Name MyInvocation -Scope 1 -ValueOnly),

        [string[]] $RedactParameter,

        [string[]] $ExcludeParameter
    )

    # Build up the invoked line, being sure to exclude and/or redact any values necessary
    $params = @()
    foreach ($param in $Invocation.BoundParameters.GetEnumerator()) {
        if ($param.Key -in ($ExcludeParameter)) {
            continue
        }
        if ($param.Key -in ($RedactParameter)) {
            $params += "-$($param.Key) <redacted>"
        } else {
            if ($param.Value -is [switch]) {
                $params += "-$($param.Key):`$$($param.Value.ToBool().ToString().ToLower())"
            } else {
                $params += "-$($param.Key) $(ConvertTo-Json -Depth $script:configuration.jsonConversionDepth -Compress -InputObject $param.Value)"
            }
        }
    }
    Write-LockpathLog -Message "[$($Invocation.MyCommand.Module.Version)] Executing: $($Invocation.MyCommand) $($params -join ' ')".Trim() -Level Verbose
}
