# Copyright (c) Robert Klohr. All rights reserved.
# Licensed under the MIT License.

function Get-LockpathRecordDetail {
    <#
    .SYNOPSIS
        Retrieves record information based on the provided component ID and record ID, with lookup field report
        details.

    .DESCRIPTION
        Retrieves record information based on the provided component ID and record ID, with lookup field report
        details. Lookup field records will detail information for fields on their report definition, if one is
        defined. Using the optional parameter -ExtractRichTextImages you can extract images contained in rich text
        fields. The component Id may be found by using Get-LockpathComponentList. The record Id may be found by
        using Get-LockpathRecords.

        The Git repo for this module can be found here: https://git.io/powershellforlockpath

    .PARAMETER ComponentId
        Specifies the Id number of the component.

    .PARAMETER RecordId
        Specifies the Id number of the record.

    .EXAMPLE
        Get-LockpathRecordDetail -ComponentId 2 -RecordId 1

    .EXAMPLE
        Get-LockpathRecordDetail -ComponentId 2 -RecordId 1 -ExtractRichTextImages True

    .INPUTS
        System.UInt32

    .OUTPUTS
        String

    .NOTES
        Native API Request: https://[InstanceName]:[InstancePort]/ComponentService/GetDetailRecord?componentId=$ComponentId&recordId=$RecordId&embedRichTextImages=$ExtractRichTextImages

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

    [OutputType([System.String])]

    param(
        [Parameter(
            Mandatory = $true,
            ValueFromPipeline = $true,
            ValueFromPipelineByPropertyName = $true
        )]
        [ValidateRange('Positive')]
        [Int32] $ComponentId,

        [Parameter(
            Mandatory = $true,
            ValueFromPipeline = $true,
            ValueFromPipelineByPropertyName = $true
        )]
        [ValidateRange('Positive')]
        [Int32] $RecordId,

        [Parameter(
            ValueFromPipeline = $true,
            ValueFromPipelineByPropertyName = $true
        )]
        [Switch] $ExtractRichTextImages
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
            'Description' = "Getting Record Detail with Component Id $ComponentId, Record Id $RecordId, and EmbedRichTextImages $ExtractRichTextImages"
            'Method'      = 'GET'
            'Query'       = "?ComponentId=$ComponentId&RecordId=$RecordId&EmbedRichTextImages=$ExtractRichTextImages"
            'Service'     = $service
            'UriFragment' = 'GetDetailRecord'
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
