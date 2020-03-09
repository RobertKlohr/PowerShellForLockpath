
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
    [CmdletBinding(SupportsShouldProcess)]
    [Diagnostics.CodeAnalysis.SuppressMessageAttribute("PSShouldProcess", "", Justification = "Methods called within here make use of PSShouldProcess, and the switch is passed on to them inherently.")]
    param()

    #TODO remove or move the next two lines
    [string] $script:CredentialFilePath = [System.IO.Path]::Combine([Environment]::GetFolderPath('LocalApplicationData'), 'PowerShellForLockpath', 'Credential.xml')

    [string] $script:ConfigurationFilePath = [System.IO.Path]::Combine([Environment]::GetFolderPath('ApplicationData'), 'PowerShellForLockpath', 'LockpathConfig.json')

    $script:configuration = Import-LockpathConfiguration -Path $script:configurationFilePath
}

# Initialize-LockpathConfiguration
