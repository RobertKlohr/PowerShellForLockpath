function Read-LockpathConfiguration {
    #FIXME Update to new coding standards


    #FIXME Clean up help
    <#
    .SYNOPSIS
        Loads in the default configuration values and returns the deserialized object.

    .DESCRIPTION
        Loads in the default configuration values and returns the deserialized object.

        The Git repo for this module can be found here: https://github.com/RobertKlohr/PowerShellForLockpath

    .PARAMETER Path
        The file that may or may not exist with a serialized version of the configuration
        values for this module.

    .OUTPUTS
        PSCustomObject

    .NOTES
        Internal helper method.

    .EXAMPLE
        Read-GitHubConfiguration -Path 'c:\foo\config.json'

        Returns back an object with the deserialized object contained in the specified file,
        if it exists and is valid.
#>

    [CmdletBinding(
        ConfirmImpact = 'Low',
        PositionalBinding = $false,
        SupportsShouldProcess = $true)]

    [Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSShouldProcess', '', Justification = 'Methods called within here make use of PSShouldProcess, and the switch is passed on to them inherently.')]

    param(
        [Parameter(
            Mandatory = $true)]
        [Alias('Path')]
        [System.IO.FileInfo] $FilePath
    )
    #FIXME the folllowing line can be made active once defaults are set in initialize-lockpathconfiguration
    # Write-LockpathInvocationLog -Confirm:$false -WhatIf:$false

    $content = Get-Content -Path $FilePath -Encoding UTF8 -ErrorAction Ignore
    if (-not [String]::IsNullOrEmpty($content)) {
        try {
            return ($content | ConvertFrom-Json)
        } catch {
            Write-LockpathLog -Message 'The configuration file for this module is in an invalid state.  Use Reset-LockpathConfiguration to recover.' -Level Warning
        }
    }
    return [PSCustomObject]@{ }
}
