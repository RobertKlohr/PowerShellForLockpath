function Initialize-LockpathConfiguration {
    <#
    .SYNOPSIS
        Populates the configuration of the module for this session, loading in any values
        that may have been saved to disk.

    .DESCRIPTION
        Populates the configuration of the module for this session, loading in any values
        that may have been saved to disk.

        The Git repo for this module can be found here: https://github.com/RobertKlohr/PowerShellForLockpath

    .EXAMPLE
        Initialize-LockpathConfiguration

    .INPUTS
        None

    .OUTPUTS
        None

    .NOTES
        Internal-only helper method. This function is automatically called when the module is loaded.

    .LINK
        https://github.com/RobertKlohr/PowerShellForLockpath/wiki
    #>

    [CmdletBinding(
        ConfirmImpact = 'Low',
        PositionalBinding = $false,
        SupportsShouldProcess = $true)]

    [Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSShouldProcess', '', Justification = 'Methods called within here make use of PSShouldProcess, and the switch is passed on to them inherently.')]

    param()

    # Create a configuration object with all the default values.
    $script:configuration = [PSCustomObject]@{
        'acceptHeader'          = [String] 'application/json'
        'configurationFilePath' = [System.IO.Path]::Combine([Environment]::GetFolderPath('ApplicationData'), 'PowerShellForLockpath', 'PowerShellForLockpathConfiguration.json')
        'credential'            = [PSCredential]::Empty
        'credentialFilePath'    = [System.IO.Path]::Combine([Environment]::GetFolderPath('LocalApplicationData'), 'PowerShellForLockpath', 'PowerShellForLockpathCredential.xml')
        'instanceName'          = [String] '<empty>.keylightgrc.com'
        'instancePort'          = [UInt16] 4443
        'instanceProtocol'      = [String] 'https'
        'logPath'               = [System.IO.Path]::Combine([Environment]::GetFolderPath('MyDocuments'), 'PowerShellForLockpath', 'PowerShellForLockpath.log')
        'logProcessId'          = [Boolean] $false
        'logRequestBody'        = [Boolean] $false
        'logTimeAsUtc'          = [Boolean] $false
        'MethodContainsBody'    = [String[]] ('Delete', 'Post')
        'pageIndex'             = [UInt32] 0
        'pageSize'              = [UInt32] 100
        'runAsSystem'           = [Boolean] $true
        'UserAgent'             = "PowerShell/$($PSVersionTable.PSVersion.ToString()) PowerShellForLockpath"
        'webRequestTimeoutSec'  = [UInt32] 0
        'webSession'            = [Boolean] $false
    }

    # Normally Write-LockpathInvocationLog is the first call in a function except here since the location of the
    # log file is only set in the previous line.
    Write-LockpathInvocationLog -Confirm:$false -WhatIf:$false

    # Load the persistant configuration file if it exists and overwrite any default values set in this function.
    Import-LockpathConfiguration
}
