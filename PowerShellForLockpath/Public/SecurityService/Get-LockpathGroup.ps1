function Get-LockpathGroup {
    <#
    .SYNOPSIS
        Returns available fields for a given group.

    .DESCRIPTION
        Returns available fields for a given group. The group Id may be found by using Get-LockpathGroups.

        The Git repo for this module can be found here: https://github.com/RobertKlohr/PowerShellForLockpath

    .PARAMETER GroupId
        Specifies the Id number of the group.

    .EXAMPLE
        Get-LockpathGroup -GroupId 2

    .EXAMPLE
        Get-LockpathGroup 2

    .EXAMPLE
        2,8,9 | Get-LockpathGroup

    .EXAMPLE
        $userObject | Get-LockpathGroup

        If $userObject has an property called GroupId that value is automatically passed as a parameter.

    .INPUTS
        System.UInt32

    .OUTPUTS
        String

    .NOTES
        Native API Request: https://[InstanceName]:[InstancePort]/SecurityService/GetGroup?Id=$GroupId

        The authentication account must have Read Administrative Access permissions to administer users.

    .LINK
        https://github.com/RobertKlohr/PowerShellForLockpath/wiki
    #>

    [CmdletBinding(
        ConfirmImpact = 'Low',
        PositionalBinding = $false,
        SupportsShouldProcess = $true)]
    [OutputType('System.String')]

    [Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSShouldProcess', '', Justification = 'Methods called within here make use of PSShouldProcess, and the switch is passed on to them inherently.')]

    param(
        [Parameter(
            Mandatory = $true,
            Position = 0,
            ValueFromPipeline = $true,
            ValueFromPipelineByPropertyName = $true)]
        [ValidateRange('NonNegative')]
        [Int64] $GroupId
    )

    begin {
        $level = 'Information'
        $functionName = ($PSCmdlet.CommandRuntime.ToString())
        $service = 'SecurityService'
    }

    process {
        Write-LockpathInvocationLog -Confirm:$false -WhatIf:$false -FunctionName $functionName -Level $level -Service $service

        $params = @{
            'Description' = 'Getting Group By Id'
            'Method'      = 'GET'
            'Query'       = "?Id=$GroupId"
            'Service'     = $service
            'UriFragment' = 'GetGroup'
        }

        $target = "Id=$GroupId"

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
