# Copyright (c) Robert Klohr. All rights reserved.
# Licensed under the MIT License.

function Get-LockpathRecordAttachment {
    <#
    .SYNOPSIS
        Returns a single file specified by the component Id, record Id, field Id and Document Id.

    .DESCRIPTION
        Returns a single file specified by the component Id, record Id, field Id and document Id. The file contents are returned as a Base64 string.

        The component Id may be found by using Get-LockpathComponents.
        The record Id may be found by using Get-LockpathRecords.
        The field Id may be found by using Get-LockpathFieldsList.
        The document Id may be found by using Get-LockpathRecordAttachment.

        The Git repo for this module can be found here: https://git.io/powershellforlockpath

    .PARAMETER ComponentId
        Specifies the Id number of the component.

        The component Id may be found by using Get-LockpathComponents.

    .PARAMETER RecordId
        Specifies the Id number of the record.

        The record Id may be found by using Get-LockpathRecords.

    .PARAMETER FieldId
        Specifies the Id number of the field.

        The field Id may be found by using Get-LockpathFieldsList.

    .PARAMETER DocumentId
        Specifies the Id number of the document.

        The document Id may be found by using Get-LockpathRecordAttachment.

    .EXAMPLE
        Get-LockpathRecordAttachment -ComponentId 2 -RecordId 1 -FieldId 1 -DocumentId 1

    .INPUTS
        System.UInt32

    .OUTPUTS
        String

    .NOTES
        Native API Request: https://[InstanceName]:[InstancePort]/ComponentService/GetRecordAttachment?componentId=$ComponentId&recordId=$RecordId&fieldId=$FieldId&documentId=$DocumentId

        The authentication account must have Read General Access permissions for the specific component, record and
        field.

    .LINK
        https://git.io/powershellforlockpathhelp
    #>

    [CmdletBinding(
        ConfirmImpact = 'Low',
        PositionalBinding = $false,
        SupportsShouldProcess = $true
    )]
    [OutputType('System.String')]

    param(
        [Parameter(Mandatory = $true,
            ValueFromPipeline = $true,
            ValueFromPipelineByPropertyName = $true
        )]
        [ValidateRange('Positive')]
        [Int32] $ComponentId,

        [Parameter(Mandatory = $true,
            ValueFromPipeline = $true,
            ValueFromPipelineByPropertyName = $true
        )]
        [ValidateRange('Positive')]
        [Int32] $RecordId,

        [Parameter(Mandatory = $true,
            ValueFromPipeline = $true,
            ValueFromPipelineByPropertyName = $true
        )]
        [ValidateRange('Positive')]
        [Int32] $FieldId,

        [Parameter(Mandatory = $true,
            ValueFromPipeline = $true,
            ValueFromPipelineByPropertyName = $true
        )]
        [ValidateRange('Positive')]
        [Int32] $DocumentId
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

        $restParameters = [ordered]@{
            'Description' = "Getting Attachment with Component Id $ComponentId, Record Id $RecordId, Field Id $FieldId, and Document Id $DocumentId"
            'Method'      = 'GET'
            'Query'       = "?ComponentId=$ComponentId&RecordId=$RecordId&FieldId=$FieldId&DocumentId=$DocumentId"
            'Service'     = $service
            'UriFragment' = 'GetRecordAttachment'
        }

        $shouldProcessTarget = $restParameters.Description

        # TODO possibly update to save file similar to Get-LockpathReport

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
