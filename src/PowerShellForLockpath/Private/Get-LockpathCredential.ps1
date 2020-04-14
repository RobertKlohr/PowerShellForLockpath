function Get-LockpathCredential {
    [CmdletBinding(SupportsShouldProcess)]
    [Diagnostics.CodeAnalysis.SuppressMessageAttribute("PSShouldProcess", "", Justification = "Methods called within here make use of PSShouldProcess, and the switch is passed on to them inherently.")]
    param(
        [string] $Path = $(Get-LockpathConfiguration -Name "credentialFilePath")
    )

    Write-InvocationLog

    $Credential = Read-LockpathCredential -Path $Path

    if ([String]::IsNullOrWhiteSpace($Credential.GetNetworkCredential().Password)) {
        $message = "The password was not provided in the password field."
        Write-Log -Message $message -Level Error
        throw $message
    }

    return $Credential
}
