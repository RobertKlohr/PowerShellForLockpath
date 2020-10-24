function Get-LockpathCredential {
    <#
    .SYNOPSIS
        Retrieves the API credentials for use in the rest of the module.

    .DESCRIPTION
        Retrieves the API credentials for use in the rest of the module.

    .PARAMETER Path
        Path to the file storing the API credentials. If not provided defaults to the path in the configuration file.

    .INPUTS
        System.String

    .OUTPUTS
        System.String

    .NOTES
        Private function.

    .LINK
        https://github.com/RobertKlohr/PowerShellForLockpath
    #>

    [CmdletBinding(
        ConfirmImpact = 'Low',
        PositionalBinding = $false,
        SupportsShouldProcess = $true)]

    [Diagnostics.CodeAnalysis.SuppressMessageAttribute("PSShouldProcess", "", Justification = "Methods called within here make use of PSShouldProcess, and the switch is passed on to them inherently.")]

    param(
        [string] $Path = $(Get-LockpathConfiguration -Name "credentialFilePath")
    )

    Write-LockpathInvocationLog -Confirm:$false -WhatIf:$false

    $Credential = Read-LockpathCredential -Path $Path

    if ([String]::IsNullOrWhiteSpace($Credential.GetNetworkCredential().Password)) {
        $message = "The password was not provided in the password field."
        Write-LockpathLog -Message $message -Level Error -Confirm:$false -WhatIf:$false
        throw $message
    }

    return $Credential
}
