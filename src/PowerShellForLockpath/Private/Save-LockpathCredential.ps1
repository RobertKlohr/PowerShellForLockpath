function Save-LockpathCredential {
    [CmdletBinding(SupportsShouldProcess)]

    [Diagnostics.CodeAnalysis.SuppressMessageAttribute("PSShouldProcess", "", Justification = "Methods called within here make use of PSShouldProcess, and the switch is passed on to them inherently.")]

    param(
        [Parameter(Mandatory)]
        [PSCustomObject] $Credential,

        [Parameter(Mandatory)]
        [string] $Path
    )

    Write-LockpathInvocationLog

    $null = New-Item -Path $Path -Force
    $Credential |
    Export-Clixml -Path $Path -Force -ErrorAction SilentlyContinue -ErrorVariable ev

    if (($null -ne $ev) -and ($ev.Count -gt 0)) {
        Write-LockpathLog -Message "Failed to persist credentials disk.  They will remain for this PowerShell session only." -Level Warning -Exception $ev[0]
    }
}
