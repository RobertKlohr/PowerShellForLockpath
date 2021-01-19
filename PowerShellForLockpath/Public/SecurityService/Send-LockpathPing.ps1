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
            'Confirm'               = $false
            'WhatIf'                = $false
            'CefName'               = $message
            'CefDeviceEventClassId' = $functionName
            'CefDeviceProduct'      = $service
            'Level'                 = $level


            # #Possible CEF Extension Message Values
            # [Int32] $dpdt,
            # [String] $duser,
            # [DateTime] $end,
            # #[String] $filePath,
            # [String] $fname,
            # [Int32] $fsize,
            # [Int32] $in,
            # [Int32] $out,
            # [String] $outcome,
            # [String] $reason,
            # [String] $request,
            # [String] $requestClientApplication,
            # [String] $requestContext,
            # [String] $requestMethod,
            # [DateTime] $start


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
            } finally {
                Write-LockpathLog @logParameters
            }
            return $result
        }
    }

    end {
    }
}
