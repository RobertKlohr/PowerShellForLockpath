﻿# Copyright (c) Robert Klohr. All rights reserved.
# Licensed under the MIT License.

function Remove-LockpathRecord {
    <#
    .SYNOPSIS
        Deletes a record.

    .DESCRIPTION
        Deletes a record. This is a soft delete that hides the record from the user interface and API by changing the
        permissions on the record. To undelete a record requires a support request.

        The Git repo for this module can be found here: https://git.io/powershellforlockpath

    .PARAMETER ComponentId
        Specifies the Id number of the component.

    .PARAMETER RecordId
        Specifies the Id number of the record.

    .EXAMPLE
        Remove-LockpathRecord -ComponentId 6 -RecordId 1

    .EXAMPLE
        $recordObject | Remove-LockpathRecord
        If $recordObject has an property called ComponentId and RecordId those values are automatically passed as parameters.

    .INPUTS
        System.UInt32

    .OUTPUTS
        String

    .NOTES
        Native API Request: https://[InstanceName]:[InstancePort]/ComponentService/DeleteRecord

        The authentication account must have Read and Delete General Access permissions to component and Read
        permissions to the record.

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
        [Parameter(Mandatory = $true,
            ValueFromPipeline = $true,
            ValueFromPipelineByPropertyName = $true
        )]
        [ValidateRange('Positive')]
        [UInt32] $ComponentId,

        [Parameter(Mandatory = $true,
            ValueFromPipeline = $true,
            ValueFromPipelineByPropertyName = $true
        )]
        [ValidateRange('Positive')]
        [UInt32] $RecordId
    )

    begin {
        $level = 'Information'
        $functionName = ($PSCmdlet.CommandRuntime.ToString())
        $service = 'ComponentService'

        $logParameters = [ordered]@{
            'FunctionName' = $functionName
            'Level'        = $level
            'Message'      = "Executing cmdlet: $functionName"
            'Service'      = $service
            'Result'       = "Executing cmdlet: $functionName"
        }
    }

    process {
        Write-LockpathInvocationLog @logParameters

        $Body = [ordered]@{
            'componentId' = $ComponentId
            'recordId'    = $RecordId
        }

        $restParameters = [ordered]@{
            'Body'        = $Body | ConvertTo-Json -Compress -Depth $Script:LockpathConfig.conversionDepth
            'Description' = "Deleting Record with Component Id $ComponentId and Record Id $RecordId"
            'Method'      = 'DELETE'
            'Service'     = $service
            'UriFragment' = 'DeleteRecord'
        }

        $shouldProcessTarget = $restParameters.Description

        if ($PSCmdlet.ShouldProcess($shouldProcessTarget)) {
            try {
                [string] $result = Invoke-LockpathRestMethod @restParameters
                $logParameters.Message = 'Success: ' + $shouldProcessTarget
                try {
                    $logParameters.Result = (ConvertFrom-Json -InputObject $result) | ConvertTo-Json -Compress
                } catch {
                    $logParameters.Result = 'Unable to convert API response.'
                }
            } catch {
                $logParameters.Level = 'Error'
                $logParameters.Message = 'Failed: ' + $shouldProcessTarget
                $logParameters.Result = $_.Exception.Message
            } finally {
                Write-LockpathLog @logParameters
            }
            return $result
        }
    }

    end {
    }
}
