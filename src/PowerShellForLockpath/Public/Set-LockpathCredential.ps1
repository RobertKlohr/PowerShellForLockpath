﻿function Set-LockpathCredential {
    #FIXME Update to new coding standards
    [CmdletBinding(
        ConfirmImpact = 'Low',
        PositionalBinding = $false,
        SupportsShouldProcess = $true)]
    [OutputType('System.String')]
    [Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSShouldProcess', '', Justification = 'Methods called within here make use of PSShouldProcess, and the switch is passed on to them inherently.')]

    param(
        [PSCredential] $Credential,

        [switch] $SessionOnly
    )

    Write-LockpathInvocationLog

    if (-not $PSBoundParameters.ContainsKey('Credential')) {
        $Credential = Get-Credential -Message 'Please provide your API Username and Password.'
    }

    if ([String]::IsNullOrWhiteSpace($Credential.GetNetworkCredential().Password)) {
        $message = 'The API Password was not provided in the password field.'
        Write-LockpathLog -Message $message -Level Error
        $Credential = Get-Credential -Message 'Please provide your API Username and Password.'
    }

    $script:configuration | Add-Member NoteProperty -Name 'credential' -Value $Credential -Force

    if (-not $SessionOnly) {
        Save-LockpathCredential -Credential $Credential -Path $script:CredentialFilePath
    }
}
