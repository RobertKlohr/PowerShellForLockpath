function Set-LockpathAuthentication {
    <#
        .SYNOPSIS
            Allows the user to configure the API Username and Password that are required for authentication to the Lockpath API.

        .DESCRIPTION
            Allows the user to configure the API Username and Password that are required for authentication to the Lockpath API.

            The Username and Password will be stored on the machine as a SecureString and will automatically be read on future PowerShell sessions with this module. If the user ever wishes to remove their authentication from the system, they simply need to call Clear-LockpathAuthentication.

            https://github.com/RjKGitHub/PowerShellForLockpath/

        .PARAMETER Credential
            If provided, instead of prompting the user for the API Username and Password, it will be extracted from the credential object.

        .PARAMETER SessionOnly
            By default, this method will store the provided API Password as a SecureString in a local file so that it can be restored automatically in future PowerShell sessions.  If this switch is provided, the file will not be created/updated and the authentication information will only remain in memory for the duration of this PowerShell session.

        .EXAMPLE
            Set-LockpathAuthentication

            Prompts the user for their Lockpath API Username and Password and stores it in a file on the machine as SecureString for use in future PowerShell sessions.

        .EXAMPLE
            $Username = "<API Account Username>"
            $PasswordSecureString = ("<API Account Password>" | ConvertTo-SecureString) $ApiCredential = New-Object
            System.Management.Automation.PSCredential $Username, $PasswordSecureString
            Set-LockpathAuthentication -Credential $ApiCredential

            Uses the API Username and Password stored in the credential object for authentication, and stores it in a file on the machine as a SecureString for use in future PowerShell sessions.

        .EXAMPLE
            Set-LockpathAuthentication -SessionOnly

            Prompts the user for their GitHub API Password, but keeps it in memory only for the duration of this PowerShell session.

        .EXAMPLE
            Set-LockpathAuthentication -Credential $ApiCredential -SessionOnly

            Uses the API Username and Password stored in the credential object for authentication, but keeps it in memory only for the duration of this PowerShell session.
    #>

    [CmdletBinding(SupportsShouldProcess)]
    # [Diagnostics.CodeAnalysis.SuppressMessageAttribute("PSShouldProcess", "", Justification = "Methods called within here make use of PSShouldProcess, and the switch is passed on to them inherently.")]

    param(
        [PSCredential] $Credential,

        [switch] $SessionOnly
    )

    Write-InvocationLog

    if (-not $PSBoundParameters.ContainsKey('Credential')) {
        $message = 'Please provide your API Username and Password.'
        if (-not $SessionOnly) {
            $message = $message + '  ***The Username and Password are being cached across PowerShell sessions.  To clear caching, call Clear-LockpathAuthentication.***'
        }

        # Write-Log -Message $message
        $Credential = Get-Credential -Message $message
    }

    if ([String]::IsNullOrWhiteSpace($Credential.GetNetworkCredential().Password)) {
        $message = "The API Password was not provided in the password field."
        # Write-Log -Message $message -Level Error
        throw $message
    }

    $script:LockpathCredential = $Credential
    if (-not $SessionOnly) {
        if ($PSCmdlet.ShouldProcess("Store API Username and Password as a SecureString in a local file")) {
            $null = New-Item -Path $script:CredentialFilePath -Force
            $script:LockpathCredential |
                Export-Clixml -Path $script:CredentialFilePath -Force
        }
    }
}
