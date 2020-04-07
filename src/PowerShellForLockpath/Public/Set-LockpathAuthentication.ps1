function Set-LockpathAuthentication {
    [CmdletBinding(SupportsShouldProcess)]
    # [Diagnostics.CodeAnalysis.SuppressMessageAttribute("PSShouldProcess", "", Justification = "Methods called within here make use of PSShouldProcess, and the switch is passed on to them inherently.")]

    param(
        [PSCredential] $Credential,

        [switch] $SessionOnly
    )

    Write-InvocationLog

    if (-not $PSBoundParameters.ContainsKey('Credential')) {
        $message = 'Please provide your API Username and Password.'
        if (-not $SessionOnly) {
            $message = $message + '  ***The Username and Password are being cached across PowerShell sessions.  To clear caching, call Clear-LockpathAuthentication.***'
        }

        # Write-Log -Message $message
        $Credential = Get-Credential -Message $message
    }

    if ([String]::IsNullOrWhiteSpace($Credential.GetNetworkCredential().Password)) {
        $message = "The API Password was not provided in the password field."
        # Write-Log -Message $message -Level Error
        throw $message
    }

    $script:LockpathCredential = $Credential

    if (-not $SessionOnly) {
        if ($PSCmdlet.ShouldProcess("Store API Username and Password as a SecureString in a local file")) {
            $null = New-Item -Path $script:CredentialFilePath -Force
            $script:LockpathCredential |
            Export-Clixml -Path $script:CredentialFilePath -Force
        }
    }
}
