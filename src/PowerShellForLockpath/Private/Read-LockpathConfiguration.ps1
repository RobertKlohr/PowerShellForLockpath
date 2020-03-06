function Read-LockpathConfiguration {
    <#
    .SYNOPSIS
        Loads in the default configuration values and returns the deserialized object.

    .DESCRIPTION
        Loads in the default configuration values and returns the deserialized object.

        The Git repo for this module can be found here: http://aka.ms/PowerShellForGitHub

    .PARAMETER Path
        The file that may or may not exist with a serialized version of the configuration
        values for this module.

    .OUTPUTS
        PSCustomObject

    .NOTES
        Internal helper method.
        No side-effects.

    .EXAMPLE
        Read-LockpathConfiguration -Path 'c:\foo\config.json'

        Returns back an object with the deserialized object contained in the specified file,
        if it exists and is valid.
#>
    [CmdletBinding(SupportsShouldProcess)]
    [Diagnostics.CodeAnalysis.SuppressMessageAttribute("PSShouldProcess", "", Justification = "Methods called within here make use of PSShouldProcess, and the switch is passed on to them inherently.")]
    param(
        [string] $Path
    )

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
