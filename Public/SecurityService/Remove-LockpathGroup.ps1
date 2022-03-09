# Copyright (c) Robert Klohr. All rights reserved.
# Licensed under the MIT License.

function Remove-LockpathGroup {
    <#
    .SYNOPSIS
        Deletes a group.

    .DESCRIPTION
        Deletes a group. This is a soft delete that hides the group from the user interface and API by changing the
        permissions on the group. It also does not remove members from the group. To undelete a group requires a support request.

        The Git repo for this module can be found here: https://git.io/powershellforlockpath

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
        https://git.io/powershellforlockpathhelp
    #>

    [CmdletBinding(
        ConfirmImpact = 'High',
        PositionalBinding = $false,
        SupportsShouldProcess = $true
    )]

    [OutputType([System.String])]

    param(
        [Parameter(
            Mandatory = $true,
            Position = 0,
            ValueFromPipeline = $true,
            ValueFromPipelineByPropertyName = $true
        )]
        [ValidateRange('Positive')]
        [Int32] $GroupId
    )

    begin {
        $level = 'Information'
        $functionName = ($PSCmdlet.CommandRuntime.ToString())
        $service = 'SecurityService'

        $logParameters = [ordered]@{
            'Confirm'      = $false
            'FunctionName' = $functionName
            'Level'        = $level
            'Message'      = "Executing cmdlet: $functionName"
            'Service'      = $service
            'Result'       = "Executing cmdlet: $functionName"
            'WhatIf'       = $false
        }
    }

    process {
        Write-LockpathInvocationLog @logParameters

        $restParameters = [ordered]@{
            'Body'        = $GroupId | ConvertTo-Json -Compress -Depth $Script:LockpathConfig.conversionDepth
            'Description' = "Deleting Group with Id $GroupId"
            'Method'      = 'DELETE'
            'Service'     = $service
            'UriFragment' = 'DeleteGroup'
        }

        $shouldProcessTarget = $restParameters.Description

        if ($PSCmdlet.ShouldProcess($shouldProcessTarget)) {
            try {
                [string] $result = Invoke-LockpathRestMethod @restParameters
                $logParameters.message = 'success: ' + $shouldProcessTarget
                try {
                    $logParameters.result = (ConvertFrom-Json -InputObject $result) | ConvertTo-Json -Compress
                } catch {
                    $logParameters.result = 'Unable to convert API response.'
                }
            } catch {
                $logParameters.Level = 'Error'
                $logParameters.Message = 'failed: ' + $shouldProcessTarget
                $logParameters.result = $_.Exception.Message
            } finally {
                Write-LockpathLog @logParameters
            }
            return $result
        }
    }

    end {
    }
}
