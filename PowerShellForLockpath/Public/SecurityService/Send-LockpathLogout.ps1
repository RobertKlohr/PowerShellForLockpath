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
        Write-LockpathInvocationLog -Confirm:$false -WhatIf:$false -FunctionName $functionName -Level $level -Service $service

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
        }

        $shouldProcessTarget = $restParameters.Description

        if ($PSCmdlet.ShouldProcess($shouldProcessTarget)) {
            try {
                $result = Invoke-LockpathRestMethod @restParameters
                $message = 'success'
            } catch {
                $result = $_.ErrorDetails.Message.Split('"')[3]
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
