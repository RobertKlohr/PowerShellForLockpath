function Initialize-LockpathConfiguration {
    [CmdletBinding(SupportsShouldProcess)]
    [Diagnostics.CodeAnalysis.SuppressMessageAttribute("PSShouldProcess", "", Justification = "Methods called within here make use of PSShouldProcess, and the switch is passed on to them inherently.")]

    param()

    @{
        ConfigurationFilePath = [System.IO.Path]::Combine([Environment]::GetFolderPath('ApplicationData'), 'PowerShellForLockpath', 'PowerShellForLockpathConfiguration.json')
        CredentialFilePath    = [System.IO.Path]::Combine([Environment]::GetFolderPath('LocalApplicationData'), 'PowerShellForLockpath', 'PowerShellForLockpathCredential.xml')
    }.GetEnumerator() | ForEach-Object {
        Set-Variable -Scope Script -Option ReadOnly -Name $_.Key -Value $_.Value
    }

    $script:configuration = Import-LockpathConfiguration -Path $script:configurationFilePath
    Write-LockpathInvocationLog
}
