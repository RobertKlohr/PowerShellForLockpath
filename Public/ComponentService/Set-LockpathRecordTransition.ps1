# Copyright (c) Robert Klohr. All rights reserved.
# Licensed under the MIT License.

function Set-LockpathRecordTransition {
    <#
    .SYNOPSIS
        Transitions a record in a workflow.

    .DESCRIPTION
        Transitions a record in a workflow.

        The Git repo for this module can be found here: https://git.io/powershellforlockpath

    .PARAMETER ComponentAlias
        Specifies the system alias of the component.

    .PARAMETER RecordId
        Specifies the Id number of the record.

        The record Id may be found by using Get-LockpathRecords.

    .PARAMETER TransitionId
        Specifies the Id number of the workflow stage transition.

        The field Id may be found by using Get-LockpathWorkflow.

    .EXAMPLE
        Set-LockpathRecordTransition -ComponentAlias 'Vendors' -RecordId 301 -TransitionId 61

    .INPUTS
        String, System.UInt32

    .OUTPUTS
        String

    .NOTES
        Native API Request: https://[InstanceName]:[InstancePort]/ComponentService/TransitionRecord

        The authentication account must have Read and Update General Access permissions for the specific component,
        and record as well as View and Transition workflow stage permissions.

        There is an inconsistency in the API that requires the the tableAlias (componentAlias) instead of the componentId.

    .LINK
        https://git.io/powershellforlockpathhelp
    #>

    [CmdletBinding(
        ConfirmImpact = 'Medium',
        PositionalBinding = $false,
        SupportsShouldProcess = $true
    )]
    [OutputType('System.String')]

    param(
        [Parameter(
            Mandatory = $true,
            Position = 0,
            ValueFromPipeline = $true,
            ValueFromPipelineByPropertyName = $true
        )]
        [ValidateLength(1, 128)]
        [String] $ComponentAlias,

        [Parameter(
            Mandatory = $true,
            ValueFromPipeline = $true,
            ValueFromPipelineByPropertyName = $true
        )]
        [ValidateRange('Positive')]
        [Int32] $RecordId,

        [Parameter(
            Mandatory = $true,
            ValueFromPipeline = $true,
            ValueFromPipelineByPropertyName = $true
        )]
        [ValidateRange('Positive')]
        [Int32] $TransitionId
    )

    begin {
        $level = 'Information'
        $functionName = ($PSCmdlet.CommandRuntime.ToString())
        $service = 'ComponentService'

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

        # TODO update so this can take the component ID as well as the alias see also Set-LockpathRecordVote

        $Body = [ordered]@{
            'tableAlias'   = $ComponentAlias
            'recordId'     = $RecordId
            'transitionId' = $TransitionId
        }

        $restParameters = [ordered]@{
            'Body'        = $Body | ConvertTo-Json -Compress -Depth $Script:LockpathConfig.jsonConversionDepth
            'Description' = "Transitioning Record with Table Alias $ComponentAlias, Record Id $RecordId, and Transition Id $TransitionId"
            'Method'      = 'POST'
            'Service'     = $service
            'UriFragment' = 'TransitionRecord'
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
