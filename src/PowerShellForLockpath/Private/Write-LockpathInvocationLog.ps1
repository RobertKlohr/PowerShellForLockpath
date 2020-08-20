#FIX add redact and exclude parameters to configuration
function Write-LockpathInvocationLog {
    [CmdletBinding(SupportsShouldProcess)]

    [Diagnostics.CodeAnalysis.SuppressMessageAttribute("PSShouldProcess", "", Justification = "Methods called within here make use of PSShouldProcess, and the switch is passed on to them inherently.")]

    param(
        [Management.Automation.InvocationInfo] $Invocation = (Get-Variable -Name MyInvocation -Scope 1 -ValueOnly),

        [string[]] $RedactParameter,

        [string[]] $ExcludeParameter
    )

    $jsonConversionDepth = 20 # Seems like it should be more than sufficient

    # Build up the invoked line, being sure to exclude and/or redact any values necessary
    $params = @()
    foreach ($param in $Invocation.BoundParameters.GetEnumerator()) {
        if ($param.Key -in ($script:alwaysExcludeParametersForLogging + $ExcludeParameter)) {
            continue
        }

        if ($param.Key -in ($script:alwaysRedactParametersForLogging + $RedactParameter)) {
            $params += "-$($param.Key) <redacted>"
        } else {
            if ($param.Value -is [switch]) {
                $params += "-$($param.Key):`$$($param.Value.ToBool().ToString().ToLower())"
            } else {
                $params += "-$($param.Key) $(ConvertTo-Json -InputObject $param.Value -Depth $jsonConversionDepth -Compress)"
            }
        }
    }
    # Write-Host "[$($Invocation.MyCommand.Module.Version)] Executing: $($Invocation.MyCommand) $($params -join ' ')"

    Write-LockpathLog -Message "[$($Invocation.MyCommand.Module.Version)] Executing: $($Invocation.MyCommand) $($params -join ' ')" -Level Verbose
}
