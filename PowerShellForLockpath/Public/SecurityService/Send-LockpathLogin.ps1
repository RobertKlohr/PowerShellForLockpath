function Send-LockpathLogin {
    <#
    .SYNOPSIS
        Creates an active session.

    .DESCRIPTION
        Creates an active session.

        The Git repo for this module can be found here: https://github.com/RobertKlohr/PowerShellForLockpath

    .EXAMPLE
        Send-LockpathLogin

    .INPUTS
        None.

    .OUTPUTS
        String

    .NOTES
        Native API Request: https://[InstanceName]:[InstancePort]/SecurityService/Login

        The authentication account must have access to the API.

    .LINK
        https://github.com/RobertKlohr/PowerShellForLockpath/wiki
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

        $credential = $Script:LockpathConfig.credential
        $hashBody = [ordered]@{
            'username' = $credential.username
            'password' = $credential.GetNetworkCredential().Password
        }

        $params = @{
            'Body'        = (ConvertTo-Json -Depth $Script:LockpathConfig.jsonConversionDepth -Compress -InputObject $hashBody)
            'Description' = 'Sending Login'
            'Method'      = 'POST'
            'Service'     = $service
            'UriFragment' = 'Login'
        }

        $target = $params.Description

        if ($PSCmdlet.ShouldProcess($target)) {
            try {
                $result = Invoke-LockpathRestMethod @params
                $message = 'success'
            } catch {
                $message = 'failed'
                $level = 'Warning'
            }
            Write-LockpathLog -Confirm:$false -WhatIf:$false -Message $message -FunctionName $functionName -Level $level -Service $service
            If ($message -eq 'failed') {
                return $message
            } else {
                return $result
            }
        }
    }

    end {
    }
}
