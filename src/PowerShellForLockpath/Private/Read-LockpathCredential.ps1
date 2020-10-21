function Read-LockpathCredential {
    #TODO Create Help Section
    #TODO Update to new coding standards
    [CmdletBinding(
        ConfirmImpact = 'Low',
        PositionalBinding = $false,
        SupportsShouldProcess = $true)]

    [Diagnostics.CodeAnalysis.SuppressMessageAttribute("PSShouldProcess", "", Justification = "Methods called within here make use of PSShouldProcess, and the switch is passed on to them inherently.")]

    param(
        [string] $Path
    )

    Write-LockpathInvocationLog

    $content = $null
    $content = Import-Clixml -Path $Path -ErrorAction Ignore

    if (-not [String]::IsNullOrEmpty($content)) {
        try {
            $accessCredentials = New-Object System.Management.Automation.PSCredential $content.Username, $content.Password
            Write-LockpathLog -Message 'Restoring login credentials from file.  These values can be cleared in the future by calling Clear-LockpathAuthentication.' -Level Verbose
            return $accessCredentials
        } catch {
            Write-LockpathLog -Message 'The configuration file for this module is in an invalid state.  Use Reset-LockpathConfiguration to recover.' -Level Warning
        }
    }
}
