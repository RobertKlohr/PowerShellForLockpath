﻿function Save-LockpathAuthenticationCookie {

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

    Write-LockpathInvocationLog -Service PrivateHelper

    $null = New-Item -Path $FilePath -Force
    $Credential | Export-Clixml -Path $FilePath -Force -ErrorAction SilentlyContinue -ErrorVariable ev

    if (($null -ne $ev) -and ($ev.Count -gt 0)) {
        Write-LockpathLog -Message 'Failed to persist credentials disk.  They will remain for this PowerShell session only.' -Level Warning -ErrorRecord $ev[0] -Service PrivateHelper
    }
}