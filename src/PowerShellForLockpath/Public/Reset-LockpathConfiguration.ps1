#TODO need to update from github
function Reset-LockpathConfiguration {
    [CmdletBinding(SupportsShouldProcess)]
    param(
        [switch] $SessionOnly
    )

    Write-InvocationLog

    if (-not $SessionOnly) {
        if ($PSCmdlet.ShouldProcess($script:configurationFilePath, "Delete configuration file")) {
            $null = Remove-Item -Path $script:configurationFilePath -Force -ErrorAction SilentlyContinue -ErrorVariable ev
        }

        if (($null -ne $ev) -and ($ev.Count -gt 0) -and ($ev[0].FullyQualifiedErrorId -notlike 'PathNotFound*')) {
            Write-Log -Message "Reset was unsuccessful.  Experienced a problem trying to remove the file [$script:configurationFilePath]." -Level Warning -Exception $ev[0]
        }
    }

    Initialize-LockpathConfiguration

    Write-Log -Message "This has not cleared your authentication token.  Call Clear-LockpathAuthentication to accomplish that." -Level Verbose
}
