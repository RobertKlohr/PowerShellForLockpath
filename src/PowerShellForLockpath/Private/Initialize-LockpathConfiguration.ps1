
# The location of the file that we'll store the Password SecureString
# which cannot/should not roam with the user.
[string] $global:CredentialFilePath = [System.IO.Path]::Combine(
    [Environment]::GetFolderPath('LocalApplicationData'),
    'PowerShellForLockpath',
    'Credential.xml')

[string] $global:ConfigurationFilePath = [System.IO.Path]::Combine(
    [Environment]::GetFolderPath('ApplicationData'),
    'PowerShellForLockpath',
    'LockpathConfig.json')

function Initialize-LockpathConfiguration {
    <#
    .SYNOPSIS
        Populates the configuration of the module for this session.

    .DESCRIPTION
        Populates the configuration of the module for this session loading in any values that may have been saved to disk.

        The Git repo for this module can be found here: https://github.com/RjKGitHub/PowerShellForLockpath/

    .NOTES
        Internal helper method.
#>
    [CmdletBinding(SupportsShouldProcess)]
    [Diagnostics.CodeAnalysis.SuppressMessageAttribute("PSShouldProcess", "", Justification = "Methods called within here make use of PSShouldProcess, and the switch is passed on to them inherently.")]
    param()

    $script:configuration = Import-LockpathConfiguration -Path $script:configurationFilePath
}

Initialize-LockpathConfiguration
