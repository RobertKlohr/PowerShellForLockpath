#TODO check me
function Clear-LockpathAuthentication {
    [CmdletBinding(SupportsShouldProcess)]
    param(
        [switch] $SessionOnly
    )

    Write-InvocationLog

    if ($PSCmdlet.ShouldProcess("Clear memory cache")) {
        $script:CredentialFilePath = $null
    }

    if (-not $SessionOnly) {
        if ($PSCmdlet.ShouldProcess("Clear file-based cache")) {
            Remove-Item -Path $script:CredentialFilePath -Force -ErrorAction SilentlyContinue -ErrorVariable ev

            if (($null -ne $ev) -and ($ev.Count -gt 0) -and ($ev[0].FullyQualifiedErrorId -notlike 'PathNotFound*')) {
                Write-Log -Message "Experienced a problem trying to remove the file that persists the Access Token [$script:CredentialFilePath]." -Level Warning -Exception $ev[0]
            }
        }
    }

    Write-Log -Message "This has not cleared your configuration settings.  Call Reset-LockpathConfiguration to accomplish that." -Level Verbose
}
