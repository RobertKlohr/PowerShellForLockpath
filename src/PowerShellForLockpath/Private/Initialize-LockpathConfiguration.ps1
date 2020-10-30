function Initialize-LockpathConfiguration {
    #FIXME Update to new coding standards
    [CmdletBinding(
        ConfirmImpact = 'Low',
        PositionalBinding = $false,
        SupportsShouldProcess = $true)]

    [Diagnostics.CodeAnalysis.SuppressMessageAttribute("PSShouldProcess", "", Justification = "Methods called within here make use of PSShouldProcess, and the switch is passed on to them inherently.")]

    param()

    $MyPD = Get-PD
    if ($MyPD.Count -eq 0) {
        Export-ModuleMember
    }

    @{
        ConfigurationFilePath = [System.IO.Path]::Combine([Environment]::GetFolderPath('ApplicationData'), 'PowerShellForLockpath', 'PowerShellForLockpathConfiguration.json')
        CredentialFilePath    = [System.IO.Path]::Combine([Environment]::GetFolderPath('LocalApplicationData'), 'PowerShellForLockpath', 'PowerShellForLockpathCredential.xml')
    }.GetEnumerator() | ForEach-Object {
        Set-Variable -Scope Script -Option ReadOnly -Name $_.Key -Value $_.Value
    }

    $script:configuration = Import-LockpathConfiguration -Path $script:configurationFilePath

    # Normally Write-LockpathInvocationLog is the first call in a function except here since the location of the
    # log file is only set in the previous line.
    Write-LockpathInvocationLog -Confirm:$false -WhatIf:$false
}
