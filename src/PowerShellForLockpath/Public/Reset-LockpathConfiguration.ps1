
function Reset-LockpathConfiguration {
    #TODO Create Help Section
    #TODO Update to new coding standards
    [CmdletBinding(
        ConfirmImpact = 'Low',
        PositionalBinding = $false,
        SupportsShouldProcess = $true)]
    [OutputType('System.String')]
    [Diagnostics.CodeAnalysis.SuppressMessageAttribute("PSShouldProcess", "", Justification = "Methods called within here make use of PSShouldProcess, and the switch is passed on to them inherently.")]

    param(
        [switch] $SessionOnly
    )

    Write-LockpathInvocationLog

    if (-not $SessionOnly) {
        if ($PSCmdlet.ShouldProcess($script:configurationFilePath, "Delete configuration file")) {
            $null = Remove-Item -Path $script:configurationFilePath -Force -ErrorAction SilentlyContinue -ErrorVariable ev
        }

        if (($null -ne $ev) -and ($ev.Count -gt 0) -and ($ev[0].FullyQualifiedErrorId -notlike 'PathNotFound*')) {
            Write-LockpathLog -Message "Reset was unsuccessful.  Experienced a problem trying to remove the file [$script:configurationFilePath]." -Level Warning -Exception $ev[0]
        }
    }

    Initialize-LockpathConfiguration

    Write-LockpathLog -Message 'This has not cleared your authentication token.  Call Remove-LockpathCredential to accomplish that. You must at least call Set-LockpathConfiguration -InstaneName "instancename" to use the module.' -Level Verbose
}
