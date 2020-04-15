#TODO convert this to a switch on the set-configuration function

function Remove-LockpathCredential {
    [CmdletBinding(SupportsShouldProcess)]
    param(
        [switch] $SessionOnly
    )

    Write-LockpathInvocationLog

    if ($PSCmdlet.ShouldProcess("Clear memory cache")) {
        $script:configuration.webSession = $null
        Write-LockpathLog -Message 'Cleared websession credentials from memory.' -Level Verbose
    }

    if (-not $SessionOnly) {
        if ($PSCmdlet.ShouldProcess("Clear file-based cache")) {
            Remove-Item -Path  $(Get-LockpathConfiguration -Name 'credentialFilePath'), -Force -ErrorAction SilentlyContinue -ErrorVariable ev
            Write-LockpathLog -Message "Removed the Lockpath credential file $($script:configuration.credentialFilePath) from file system." -Level Warning -Exception $ev[0]

            if (($null -ne $ev) -and ($ev.Count -gt 0) -and ($ev[0].FullyQualifiedErrorId -notlike 'PathNotFound*')) {
                Write-LockpathLog -Message "Experienced a problem trying to remove the Lockpath credential file $($script:configuration.credentialFilePath)." -Level Warning -Exception $ev[0]
            }
        }
    }
}
