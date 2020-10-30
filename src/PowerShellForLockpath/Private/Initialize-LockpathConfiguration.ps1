function Initialize-LockpathConfiguration {
    #FIXME Update to new coding standards

    #FIXME Clean up help
    <#
    .SYNOPSIS
        Populates the configuration of the module for this session, loading in any values
        that may have been saved to disk.

    .DESCRIPTION
        Populates the configuration of the module for this session, loading in any values
        that may have been saved to disk.

        The Git repo for this module can be found here: https://github.com/RobertKlohr/PowerShellForLockpath

    .NOTES
        Internal helper method.  This is actually invoked at the END of this file.
#>

    [CmdletBinding(
        ConfirmImpact = 'Low',
        PositionalBinding = $false,
        SupportsShouldProcess = $true)]

    [Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSShouldProcess', '', Justification = 'Methods called within here make use of PSShouldProcess, and the switch is passed on to them inherently.')]

    param()

    $MyPD = Get-PD
    if ($MyPD.Count -eq 0) {
        Export-ModuleMember
    }

    #FIXME this may not be needed to put these two variables into the script scope
    @{
        ConfigurationFilePath = [System.IO.Path]::Combine([Environment]::GetFolderPath('ApplicationData'), 'PowerShellForLockpath', 'PowerShellForLockpathConfiguration.json')
        CredentialFilePath    = [System.IO.Path]::Combine([Environment]::GetFolderPath('LocalApplicationData'), 'PowerShellForLockpath', 'PowerShellForLockpathCredential.xml')
    }.GetEnumerator() | ForEach-Object {
        Set-Variable -Scope Script -Option ReadOnly -Name $_.Key -Value $_.Value
    }

    $script:configuration = Import-LockpathConfiguration -FilePath $script:configurationFilePath

    # Normally Write-LockpathInvocationLog is the first call in a function except here since the location of the
    # log file is only set in the previous line.
    Write-LockpathInvocationLog -Confirm:$false -WhatIf:$false
}
