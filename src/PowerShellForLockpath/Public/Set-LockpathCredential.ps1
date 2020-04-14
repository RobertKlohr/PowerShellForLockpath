function Set-LockpathCredential {
    [CmdletBinding(SupportsShouldProcess)]
    [Diagnostics.CodeAnalysis.SuppressMessageAttribute("PSShouldProcess", "", Justification = "Methods called within here make use of PSShouldProcess, and the switch is passed on to them inherently.")]

    param(
        [PSCredential] $Credential,

        [switch] $SessionOnly
    )

    Write-InvocationLog

    if (-not $PSBoundParameters.ContainsKey('Credential')) {
        $Credential = Get-Credential -Message 'Please provide your API Username and Password.'
    }

    if ([String]::IsNullOrWhiteSpace($Credential.GetNetworkCredential().Password)) {
        $message = "The API Password was not provided in the password field."
        Write-Log -Message $message -Level Error
        $Credential = Get-Credential -Message 'Please provide your API Username and Password.'
    }

    if (-not $SessionOnly) {
        Save-LockpathCredential -Credential $Credential -Path $script:CredentialFilePath
    }
}
