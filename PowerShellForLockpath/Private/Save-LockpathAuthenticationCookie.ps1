function Save-LockpathAuthenticationCookie {

    #FIXME rename function to Export-LockpathAuthenticationCookie

    [CmdletBinding(
        ConfirmImpact = 'Low',
        PositionalBinding = $false,
        SupportsShouldProcess = $true)]

    [Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSShouldProcess', '', Justification = 'Methods called within here make use of PSShouldProcess, and the switch is passed on to them inherently.')]

    param(
        [Parameter(
            Mandatory = $true)]
        [PSCustomObject] $Credential,
        # [PSCredential]

        [Parameter(
            Mandatory = $true)]
        [Alias('Path')]
        [System.IO.FileInfo] $FilePath
    )

    $level = 'Verbose'
    $functionName = ($PSCmdlet.CommandRuntime.ToString())
    $service = 'PrivateHelper'

    Write-LockpathInvocationLog -Confirm:$false -WhatIf:$false -FunctionName $functionName -Level $level -Service $service

    $null = New-Item -Path $FilePath -Force
    $Credential | Export-Clixml -Path $FilePath -Force -ErrorAction SilentlyContinue -ErrorVariable ev

    if (($null -ne $ev) -and ($ev.Count -gt 0)) {
        Write-LockpathLog -Confirm:$false -WhatIf:$false -FunctionName $functionName -Level 'Warning' -Service $service -Message 'Failed to persist credentials disk.  They will remain for this PowerShell session only.' -ErrorRecord $ev[0]
    }
}
