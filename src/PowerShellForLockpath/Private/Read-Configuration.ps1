﻿function Read-Configuration {
    [CmdletBinding(SupportsShouldProcess)]
    [Diagnostics.CodeAnalysis.SuppressMessageAttribute("PSShouldProcess", "", Justification = "Methods called within here make use of PSShouldProcess, and the switch is passed on to them inherently.")]
    param(
        [string] $Path
    )

    Write-InvocationLog

    $content = Get-Content -Path $Path -Encoding UTF8 -ErrorAction Ignore
    if (-not [String]::IsNullOrEmpty($content)) {
        try {
            return ($content | ConvertFrom-Json)
        } catch {
            Write-Log -Message 'The configuration file for this module is in an invalid state.  Use Reset-LockpathConfiguration to recover.' -Level Warning
        }
    }
    return [PSCustomObject]@{ }
}
