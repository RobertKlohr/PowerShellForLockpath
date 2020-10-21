function Save-LockpathConfiguration {
    #TODO Create Help Section
    #TODO Update to new coding standards
    [CmdletBinding(
        ConfirmImpact = 'Low',
        PositionalBinding = $false,
        SupportsShouldProcess = $true)]

    [Diagnostics.CodeAnalysis.SuppressMessageAttribute("PSShouldProcess", "", Justification = "Methods called within here make use of PSShouldProcess, and the switch is passed on to them inherently.")]

    param(
        [Parameter(Mandatory)]
        [PSCustomObject] $Configuration,

        [Parameter(Mandatory)]
        [string] $Path
    )

    Write-LockpathInvocationLog

    $null = New-Item -Path $Path -Force
    ConvertTo-Json -InputObject $Configuration |
    Set-Content -Path $Path -Force -ErrorAction SilentlyContinue -ErrorVariable ev

    if (($null -ne $ev) -and ($ev.Count -gt 0)) {
        Write-LockpathLog -Message "Failed to persist these updated settings to disk.  They will remain for this PowerShell session only." -Level Warning -Exception $ev[0]
    }
}
