
#TODO Remove the comments below after testing configration, authentication and at least one API call use case

# The location of the file that we'll store the Password SecureString
# which cannot/should not roam with the user.
# [string] $global:CredentialFilePath = [System.IO.Path]::Combine(
#     [Environment]::GetFolderPath('LocalApplicationData'),
#     'PowerShellForLockpath',
#     'Credential.xml')

# [string] $global:ConfigurationFilePath = [System.IO.Path]::Combine(
#     [Environment]::GetFolderPath('ApplicationData'),
#     'PowerShellForLockpath',
#     'LockpathConfig.json')

function Initialize-Configuration {
    [CmdletBinding(SupportsShouldProcess)]
    [Diagnostics.CodeAnalysis.SuppressMessageAttribute("PSShouldProcess", "", Justification = "Methods called within here make use of PSShouldProcess, and the switch is passed on to them inherently.")]
    param()

    @{
        ConfigurationFilePath             = [System.IO.Path]::Combine([Environment]::GetFolderPath('ApplicationData'), 'PowerShellForLockpath', 'LockpathConfig.json')
        CredentialFilePath                = [System.IO.Path]::Combine([Environment]::GetFolderPath('LocalApplicationData'), 'PowerShellForLockpath', 'Credential.xml')
        DefaultAcceptHeader               = 'application/json'
        ValidBodyContainingRequestMethods = ("Delete", "Post")
        UserAgent                         = "PowerShell/$($PSVersionTable.PSVersion.ToString(2)) PowerShellForLockpath"
    }.GetEnumerator() | ForEach-Object {
        Set-Variable -Scope Script -Option ReadOnly -Name $_.Key -Value $_.Value
    }

    $script:configuration = Import-Configuration -Path $script:configurationFilePath
}
