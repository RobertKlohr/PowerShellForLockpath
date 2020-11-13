function Initialize-LockpathConfiguration {
    <#
    .SYNOPSIS
        Populates the configuration of the module for this session, loading in any values
        that may have been saved to disk.

    .DESCRIPTION
        Populates the configuration of the module for this session, loading in any values that may have been saved to disk.

        The Git repo for this module can be found here: https://github.com/RobertKlohr/PowerShellForLockpath

    .EXAMPLE
        Initialize-LockpathConfiguration

    .INPUTS
        None

    .OUTPUTS
        None

    .NOTES
        Private helper method. This function is automatically called when the module is loaded.

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
    if ($null -eq $Script:configuration) {
        $Script:configuration = [PSCustomObject]@{
            'acceptHeader'          = [String] 'application/json'
            'authenticationCookie'  = [Hashtable] @{
                'Domain' = '<empty>.keylightgrc.com'
                'Name'   = 'INVALID'
                'Value'  = 'THIS_IS_NOT_A_VALID_AUTHENTICATION_COOKIE'
            }
            'configurationFilePath' = [System.IO.Path]::Combine([Environment]::GetFolderPath('ApplicationData'), 'PowerShellForLockpath', 'PowerShellForLockpathConfiguration.xml')
            'contentTypeHeader'     = [String] 'application/json'
            'credential'            = [PSCredential]::Empty
            'credentialFilePath'    = [System.IO.Path]::Combine([Environment]::GetFolderPath('LocalApplicationData'), 'PowerShellForLockpath', 'PowerShellForLockpathCredential.xml')
            'instanceName'          = [String] '<empty>.keylightgrc.com'
            'instancePort'          = [Int16] 4443
            'instanceProtocol'      = [String] 'https'
            'jsonConversionDepth'   = [Int32] 100
            'keepAliveInterval'     = [Int32] 5
            'logPath'               = [System.IO.Path]::Combine([Environment]::GetFolderPath('MyDocuments'), 'PowerShellForLockpath', 'PowerShellForLockpath.log')
            'logProcessId'          = [Boolean] $false
            'logRequestBody'        = [Boolean] $false
            'logTimeAsUtc'          = [Boolean] $false
            'methodContainsBody'    = [System.Collections.ArrayList] ('Delete', 'Post')
            'pageIndex'             = [Int32] 0
            'pageSize'              = [Int32] 100
            'runAsSystem'           = [Boolean] $true
            'systemFields'          = [Hashtable] @{
                'Begin Date'         = 'BeginDate'
                'Created At'         = 'CreatedAt'
                'Created By'         = 'CreatedBy'
                'Current Revision'   = 'Version'
                'Deleted'            = 'Deleted'
                'End Date'           = 'EndDate'
                'Id'                 = 'Id'
                'Published Revision' = 'PublishedVersion'
                'Updated At'         = 'UpdatedAt'
                'Updated By'         = 'UpdatedBy'
                'Workflow Stage'     = 'WorkflowStage'
            }
            'UserAgent'             = "PowerShell/$($PSVersionTable.PSVersion.ToString()) PowerShellForLockpath"
            'webRequestTimeoutSec'  = [Int32] 0
        }
    }

    # Normally Write-LockpathInvocationLog is the first call in a function except here since the location of the
    # log file is only set in the previous line.
    Write-LockpathInvocationLog -Confirm:$false -WhatIf:$false

    # Load the persistant configuration file if it exists and overwrite any default values set in this function.
    Import-LockpathConfiguration
}
