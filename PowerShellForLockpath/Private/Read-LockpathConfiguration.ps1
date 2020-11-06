function Read-LockpathConfiguration {
    <#
    .SYNOPSIS
        Loads in the default configuration values and returns the deserialized object.

    .DESCRIPTION
        Loads in the default configuration values and returns the deserialized object.

        The Git repo for this module can be found here: https://github.com/RobertKlohr/PowerShellForLockpath

    .PARAMETER FilePath
        The file that may or may not exist with a serialized version of the configuration
        values for this module.

    .OUTPUTS
        PSCustomObject

    .EXAMPLE
        Read-LockpathConfiguration -FilePath 'c:\Temp\PowerShellForLockpath.json'

    .INPUTS
        System.IO.FileInfo

    .OUTPUTS
        PSCustomObject

    .NOTES
        Private helper method.

    .LINK
        https://github.com/RobertKlohr/PowerShellForLockpath/wiki
    #>

    [CmdletBinding(
        ConfirmImpact = 'Low',
        PositionalBinding = $false,
        SupportsShouldProcess = $true)]

    [Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSShouldProcess', '', Justification = 'Methods called within here make use of PSShouldProcess, and the switch is passed on to them inherently.')]

    param(
        [Parameter(Mandatory = $true)]
        [IO.FileInfo] $FilePath
    )

    Write-LockpathInvocationLog -ExcludeParameter FilePath -Confirm:$false -WhatIf:$false

    try {
        $content = Get-Content -Path $FilePath -Encoding UTF8 -ErrorAction Stop
        return ($content | ConvertFrom-Json)
    } catch {
        Write-LockpathLog -Message 'The configuration file for this module is in an invalid state.  Use Reset-LockpathConfiguration to reset the file followed by Set-LockpathConfiguration -InstanceName <instancename>.' -Level Warning
    }
}
