function Read-Credential {
    [CmdletBinding(SupportsShouldProcess)]
    [Diagnostics.CodeAnalysis.SuppressMessageAttribute("PSShouldProcess", "", Justification = "Methods called within here make use of PSShouldProcess, and the switch is passed on to them inherently.")]
    param(
        [string] $Path
    )

    Write-InvocationLog

    $content = $null
    $content = Import-Clixml -Path $script:CredentialFilePath -ErrorAction Ignore

    if (-not [String]::IsNullOrEmpty($content)) {
        try {
            $accessCredentials = New-Object System.Management.Automation.PSCredential $content.Username, $content.Password
            Write-Log -Message "Restoring login credentials from file.  These values can be cleared in the future by calling Clear-LockpathAuthentication." -Level Verbose
            return $accessCredentials
        } catch {
            Write-Log -Message 'The configuration file for this module is in an invalid state.  Use Reset-LockpathConfiguration to recover.' -Level Warning
        }
    }
}
