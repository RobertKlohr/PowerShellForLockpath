# Copyright (c) Robert Klohr. All rights reserved.
# Licensed under the MIT License.

function Send-LockpathLogout {
    <#
    .SYNOPSIS
        Terminates the active session.

    .DESCRIPTION
        Terminates the active session.

        The Git repo for this module can be found here: https://git.io/powershellforlockpath

    .EXAMPLE
        Send-LockpathLogout

    .INPUTS
        None.

    .OUTPUTS
        String

    .NOTES
        Native API Request: https://[InstanceName]:[InstancePort]/SecurityService/Logout

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
        $level = 'Information'
        $functionName = ($PSCmdlet.CommandRuntime.ToString())
        $service = 'SecurityService'
    }

    process {
        if ($Script:LockpathConfig.loggingLevel -eq 'Debug') {
            Write-LockpathInvocationLog -Confirm:$false -WhatIf:$false -FunctionName $functionName -Level $level -Service $service
        }

        $restParameters = [ordered]@{
            'Description' = 'Sending Logout'
            'Method'      = 'GET'
            'Service'     = $service
            'UriFragment' = 'Logout'
        }

        $logParameters = [ordered]@{
            'Confirm'      = $false
            'WhatIf'       = $false
            'Message'      = $message
            'FunctionName' = $functionName
            'Level'        = $level
            'Service'      = $service
            # FIXME update all functions to pass the result to write-lockpathlog (1)
            'Result'       = $result
        }

        $shouldProcessTarget = $restParameters.Description

        if ($PSCmdlet.ShouldProcess($shouldProcessTarget)) {
            try {
                $result = Invoke-LockpathRestMethod @restParameters
                $logParameters.message = 'success'
            } catch {
                $result = $_.ErrorDetails.Message.Split('"')[3]
                $logParameters.message = 'failed'
                $logParameters.level = 'Warning'
                # FIXME update all functions to pass the result to write-lockpathlog (2)
                $logParameters.result = $result
            } finally {
                Write-LockpathLog @logParameters
            }
            return $result
        }
    }

    end {
    }
}
