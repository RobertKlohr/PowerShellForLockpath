# Copyright (c) Robert Klohr. All rights reserved.
# Licensed under the MIT License.

function Send-LockpathPing {
    <#
    .SYNOPSIS
        Refreshes a valid session.

    .DESCRIPTION
        Refreshes a valid session.

        The Git repo for this module can be found here: https://git.io/powershellforlockpath

    .EXAMPLE
        Send-LockpathPing

    .INPUTS
        None.

    .OUTPUTS
        String

    .NOTES
        Native API Request: https://[InstanceName]:[InstancePort]/SecurityService/Ping

        The authentication account must have access to the API.

    .LINK
        https://git.io/powershellforlockpathhelp
    #>

    [CmdletBinding(
        ConfirmImpact = 'Low',
        PositionalBinding = $false,
        SupportsShouldProcess = $true)]
    [OutputType('System.String')]

    param()

    begin {
        $level = 'Verbose'
        $functionName = ($PSCmdlet.CommandRuntime.ToString())
        $service = 'SecurityService'
    }

    process {
        # FIXME public function only log invocation when set to verbose and maybe then only to the
        # verbose output stream
        if ($Script:LockpathConfig.loggingLevel -eq 'Debug') {
            Write-LockpathInvocationLog -Confirm:$false -WhatIf:$false -FunctionName $functionName -Level $level -Service $service
        }

        $restParameters = [ordered]@{
            'Description' = 'Sending Ping'
            'Method'      = 'GET'
            'Service'     = $service
            'UriFragment' = 'Ping'
        }

        $logParameters = [ordered]@{
            #     'CefHeaderDeviceVendor'         = $moduleName
            #     'CefHeaderDeviceProduct'        = $moduleName
            #     'CefHeaderDeviceVersion'        = $moduleVersion
            #     'CefHeaderDeviceEventClassId'   = $functionName
            #     'CefHeaderName'                 = $a
            #     'CefHeaderSeverity'             = 'Unknown'
            #     'CefExtensionEnd'               = $a
            #     'CefExtensionFilePath'          = $a
            #     'CefExtensionFileSize'          = $a
            #     'CefExtensionMsg'               = $msg
            #     'CefExtensionOutcome'           = $a
            #     'CefExtensionReason'            = $a
            #     'CefExtensionRequest'           = $a
            #     'CefExtensionRequestMethod'     = $a
            #     'CefExtensionSourceServiceName' = $a
            #     'CefExtensionSourceProcessId'   = $a
            #     'CefExtensionSourceUserName'    = $a
            #     'CefExtensionSourceHostName'    = $a
            #     'CefExtensionStart'             = $a
        }

        $shouldProcessTarget = $restParameters.Description

        if ($PSCmdlet.ShouldProcess($shouldProcessTarget)) {
            try {
                $result = Invoke-LockpathRestMethod @restParameters
                $logParameters.message = 'success'
            } catch {
                $result = ($_.ErrorDetails.Message | ConvertFrom-Json).Message
                $logParameters.message = 'failed'
                $logParameters.level = 'Warning'
            } finally {
                Write-LockpathLog @logParameters
            }
            return $result
        }
    }

    end {
    }
}
