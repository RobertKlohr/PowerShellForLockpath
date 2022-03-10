# Copyright (c) Robert Klohr. All rights reserved.
# Licensed under the MIT License.

function Initialize-LockpathConfiguration {
    <#
    .SYNOPSIS
        Populates the configuration of the module for this session, loading in any values that may have been saved to disk.

    .DESCRIPTION
        Populates the configuration of the module for this session, loading in any values that may have been saved to disk.

        The Git repo for this module can be found here: https://git.io/powershellforlockpath

    .EXAMPLE
        Initialize-LockpathConfiguration

    .INPUTS
        None

    .OUTPUTS
        None

    .NOTES
        Private helper method. This function is automatically called when the module is loaded.

    .LINK
        https://git.io/powershellforlockpathhelp
    #>

    [Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSAvoidGlobalVars', '', Justification = 'The PID is needed for logging and it is only accessible via a global variable.')]

    [CmdletBinding(
        ConfirmImpact = 'Low',
        PositionalBinding = $false
    )]

    [OutputType([System.Void])]

    param()

    $level = 'Debug'
    $functionName = ($PSCmdlet.CommandRuntime.ToString())
    $service = 'PrivateHelper'

    $logParameters = [ordered]@{
        'Confirm'      = $false
        'FunctionName' = $functionName
        'Level'        = $level
        'Message'      = $null
        'Service'      = $service
        'Result'       = $null
        'WhatIf'       = $false
    }

    try {
        # Create a configuration object with all the default configuration and session values.
        if ($null -eq $Script:LockpathConfig) {
            $Script:LockpathConfig = [PSCustomObject]@{
                'acceptHeader'                 = [String] 'application/json'
                'authenticationCookie'         = [Hashtable] @{
                    'Domain' = '<invalid>.keylightgrc.com'
                    'Name'   = 'INVALID'
                    'Value'  = 'THIS_IS_NOT_A_VALID_AUTHENTICATION_COOKIE'
                }
                'authenticationCookieFilePath' = [System.IO.Path]::Combine([Environment]::GetFolderPath('LocalApplicationData'), 'PowerShellForLockpath', 'PowerShellForLockpathauthenticationCookies.xml')
                'configurationFilePath'        = [System.IO.Path]::Combine([Environment]::GetFolderPath('ApplicationData'), 'PowerShellForLockpath', 'PowerShellForLockpathConfiguration.xml')
                'contentTypeHeader'            = [String] 'application/json'
                'credential'                   = [PSCredential]::Empty
                'credentialFilePath'           = [System.IO.Path]::Combine([Environment]::GetFolderPath('LocalApplicationData'), 'PowerShellForLockpath', 'PowerShellForLockpathCredential.xml')
                'instanceName'                 = [String] '<invalid>.keylightgrc.com'
                'instancePort'                 = [UInt16] 4443
                'instanceProtocol'             = [String] 'https'
                'conversionDepth'              = [UInt32] 100
                'keepAliveInterval'            = [UInt32] 5
                'loggingLevel'                 = [String] 'Information'
                'logPath'                      = [System.IO.Path]::Combine([Environment]::GetFolderPath('LocalApplicationData'), 'PowerShellForLockpath', 'PowerShellForLockpath.log')
                'logRequestBody'               = [Boolean] $false
                'logTimeAsUtc'                 = [Boolean] $false
                'methodContainsBody'           = [System.Collections.ArrayList] ('Delete', 'Post')
                'pageIndex'                    = [UInt32] 0
                'pageSize'                     = [UInt32] 100
                'ProcessId'                    = [String] $global:PID.ToString()
                # The module version is not present until after the module is loaded therefore we
                # need to manually parse the manifest and extract the module version number to use
                # it in logging before the module is fully loaded.
                'productVersion'               = [String] (Select-String -Path "$PSScriptRoot\..\PowerShellForLockpath.psd1" -Pattern moduleversion -List -Raw -SimpleMatch).Split("'")[1]
                'runAsSystem'                  = [Boolean] $true
                'systemFields'                 = [Hashtable] @{
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
                'UserAgent'                    = "PowerShell/$($PSVersionTable.PSVersion.ToString()) PowerShellForLockpath"
                'vendorName'                   = [String] 'PowerShellForLockpath'
                'webRequestTimeoutSec'         = [UInt32] 0
            }
        }

        # Load the persistant configuration file if it exists and overwrite any default values set
        # in this function.
        Import-LockpathConfiguration
        $logParameters.Message = 'Success: Initializing Configuration'
        $logParameters.Result = 'Success: Initializing Configuration'
    } catch {
        $logParameters.Level = 'Error'
        $logParameters.Message = 'Failed: Initializing Configuration'
        $logParameters.Result = $_.Exception.Message
    } finally {
        # Normally Write-LockpathInvocationLog is run first in a function but we need to import the
        # configuration before using.
        Write-LockpathInvocationLog @logParameters
    }
}
