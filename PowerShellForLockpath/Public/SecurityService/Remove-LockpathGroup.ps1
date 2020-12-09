function Remove-LockpathGroup {
    <#
    .SYNOPSIS
        Deletes a group.

    .DESCRIPTION
        Deletes a group. This is a soft delete that hides the group from the user interface and API by changing the
        permissions on the group. It also does not remove members from the group. To undelete a group requires a support request.

        The Git repo for this module can be found here: https://github.com/RobertKlohr/PowerShellForLockpath

    .PARAMETER GroupId
        Specifies the Id number of the group.

    .EXAMPLE
        Remove-LockpathGroup -GroupId 6

    .EXAMPLE
        Remove-LockpathGroup 6

    .EXAMPLE
        6 | Remove-LockpathGroup

    .EXAMPLE
        6,7,8 | Remove-LockpathGroup

    .EXAMPLE
        $groupObject | Remove-LockpathGroup
        If $groupObject has an property called GroupId that value is automatically passed as a parameter.

    .INPUTS
        System.UInt32

    .OUTPUTS
        String

    .NOTES
        Native API Request: https://[InstanceName]:[InstancePort]/SecurityService/DeleteGroup

        The authentication account must have Read and Delete Administrative Access permissions to administer groups.

    .LINK
        https://github.com/RobertKlohr/PowerShellForLockpath/wiki
    #>

    [CmdletBinding(
        ConfirmImpact = 'High',
        PositionalBinding = $false,
        SupportsShouldProcess = $true)]
    [OutputType('System.String')]

    param(
        [Parameter(
            Mandatory = $true,
            Position = 0,
            ValueFromPipeline = $true,
            ValueFromPipelineByPropertyName = $true)]
        [ValidateRange('Positive')]
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
            'Body'        = $GroupId | ConvertTo-Json -Depth $Script:LockpathConfig.jsonConversionDepth -Compress
            'Description' = 'Deleting Group By Id'
            'Method'      = 'DELETE'
            'Service'     = $service
            'UriFragment' = 'DeleteGroup'
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
