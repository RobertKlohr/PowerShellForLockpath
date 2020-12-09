function Get-LockpathUser {
    <#
    .SYNOPSIS
        Returns available fields for a given user.

    .DESCRIPTION
        Returns available fields for a given user. The user Id may be found by using Get-LockpathUsers.

        The Git repo for this module can be found here: https://github.com/RobertKlohr/PowerShellForLockpath

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
        https://github.com/RobertKlohr/PowerShellForLockpath/wiki
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
        Write-LockpathInvocationLog -Confirm:$false -WhatIf:$false -FunctionName $functionName -Level $level -Service $service

        $params = @{
            'Description' = 'Getting User By Id'
            'Method'      = 'GET'
            'Query'       = "?Id=$UserId"
            'Service'     = $service
            'UriFragment' = 'GetUser'
        }

        $target = "Id=$UserId"

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
