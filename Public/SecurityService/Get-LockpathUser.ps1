function Get-LockpathUser {
    <#
    .SYNOPSIS
        Returns available fields for a given user.

    .DESCRIPTION
        Returns available fields for a given user. The user Id may be found by using Get-LockpathUsers.

        The Git repo for this module can be found here: https://git.io/powershellforlockpath

    .PARAMETER UserId
        Specifies the Id number of the user.

    .EXAMPLE
        Get-LockpathUser -UserId 6

    .EXAMPLE
        Get-LockpathUser 6

    .EXAMPLE
        6 | Get-LockpathUser

    .EXAMPLE
        6,12,15 | Get-LockpathUser

    .EXAMPLE
        $userObject | Get-LockpathUser

        If $userObject has an property called UserId that value is automatically passed as a parameter.

    .INPUTS
        System.UInt32

    .OUTPUTS
        String

    .NOTES
        Native API Request: https://[InstanceName]:[InstancePort]/SecurityService/GetUser?Id=$UserId

        The authentication account must have Read Administrative Access permissions to administer users.

    .LINK
        https://git.io/powershellforlockpathhelp
    #>

    [CmdletBinding(
        ConfirmImpact = 'Low',
        PositionalBinding = $false,
        SupportsShouldProcess = $true)]
    [OutputType('System.String')]

    param(
        [Parameter(
            Mandatory = $true,
            Position = 0,
            ValueFromPipeline = $true,
            ValueFromPipelineByPropertyName = $true)]
        [ValidateRange('NonNegative')]
        [Int64] $UserId
    )

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
            'Description' = 'Getting User By Id'
            'Method'      = 'GET'
            'Query'       = "?Id=$UserId"
            'Service'     = $service
            'UriFragment' = 'GetUser'
        }

        $logParameters = [ordered]@{
            'Confirm'      = $false
            'WhatIf'       = $false
            'Message'      = $message
            'FunctionName' = $functionName
            'Level'        = $level
            'Service'      = $service
        }

        $shouldProcessTarget = "Id=$UserId"

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
