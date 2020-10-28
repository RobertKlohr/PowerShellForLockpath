function Get-LockpathCredential {
    <#
    .SYNOPSIS
        Gets the API credentials for use in the rest of the module.

    .DESCRIPTION
        Gets the API credentials for use in the rest of the module.

        First the will try to use the credential already cached in memory.
        If not found, will look to see if there is a file with the API credential stored
        as a SecureString.

        The Git repo for this module can be found here: https://github.com/RobertKlohr/PowerShellForLockpath

    .PARAMETER Path
        Path to the file storing the API credentials. If not provided defaults to the path in the configuration file.

    .INPUTS
        System.IO.FileInfo

    .OUTPUTS
        System.String

    .NOTES
        Internal-only helper method.

    .LINK
        https://github.com/RobertKlohr/PowerShellForLockpath/wiki
    #>

    [CmdletBinding(
        ConfirmImpact = 'Low',
        PositionalBinding = $false,
        SupportsShouldProcess = $true)]

    [Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSShouldProcess', '', Justification = 'Methods called within here make use of PSShouldProcess, and the switch is passed on to them inherently.')]

    param(
        [Parameter(
            ValueFromPipeline = $true,
            ValueFromPipelineByPropertyName = $true)]
        [Alias('Path')]
        [System.IO.FileInfo] $FilePath = $(Get-LockpathConfiguration -Name 'credentialFilePath')
    )

    Write-LockpathInvocationLog -Confirm:$false -WhatIf:$false

    #read from config object

    if ($null -ne $(Get-LockpathConfiguration -Name 'credential')) {
        $accessCredentials = $(Get-LockpathConfiguration -Name 'credential')
    }

    # read from file

    $content = Import-Clixml -Path $FilePath -ErrorAction Ignore

    if (-not [String]::IsNullOrEmpty($content)) {
        try {
            $accessCredentials = New-Object System.Management.Automation.PSCredential $content.Username, $content.Password
            Write-LockpathLog -Message 'Restoring login credentials from file. These values can be cleared by calling Remove-LockpathCredential.' -Level Verbose
            Set-LockpathConfiguration -Credential $accessCredentials
            return $accessCredentials
        } catch {
            Write-LockpathLog -Message 'The credential configuration file for this module is in an invalid state.  Use Set-LockpathCredential to reset.' -Level Warning
        }
    }


    # $Credential = Read-LockpathCredential -Path $Path

    # if ([String]::IsNullOrWhiteSpace($Credential.GetNetworkCredential().Password)) {
    #     $message = 'The password was not provided in the password field.'
    #     Write-LockpathLog -Message $message -Level Error -Confirm:$false -WhatIf:$false
    #     throw $message
    # }

    return $accessCredentials
}
