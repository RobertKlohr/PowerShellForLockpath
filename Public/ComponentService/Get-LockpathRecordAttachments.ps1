﻿# Copyright (c) Robert Klohr. All rights reserved.
# Licensed under the MIT License.

function Get-LockpathRecordAttachments {
    <#
    .SYNOPSIS
        Returns the file name, field Id and document Id for all attachments associated with a given record.

    .DESCRIPTION
        Returns the file name, field Id and document Id for all attachments associated with a given record. The
        contents of the attachment are not returned.

        The Git repo for this module can be found here: https://git.io/powershellforlockpath

    .PARAMETER ComponentId
        Specifies the Id number of the component.

    .PARAMETER RecordId
        Specifies the Id number of the record.

    .PARAMETER FieldId
        Specifies the Id number of the field.

    .EXAMPLE
        Get-LockpathRecordAttachments -ComponentId 2 -RecordId 1 -FieldId 1

    .INPUTS
        System.UInt32

    .OUTPUTS
        String

    .NOTES
        Native API Request: https://[InstanceName]:[InstancePort]/ComponentService/GetRecordAttachments?componentId=$ComponentId&recordId=$RecordId&fieldId=$FieldId

        The authentication account must have Read General Access permissions for the specific component, record and
        field.

    .LINK
        https://git.io/powershellforlockpathhelp
    #>

    [CmdletBinding(
        ConfirmImpact = 'Low',
        PositionalBinding = $false,
        SupportsShouldProcess = $true)]
    [OutputType('System.String')]

    [Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSUseSingularNouns', '', Justification = 'This cmdlets is a wrapper for an API call that uses a plural noun.')]

    param(
        [Parameter(Mandatory = $true,
            ValueFromPipeline = $true,
            ValueFromPipelineByPropertyName = $true)]
        [ValidateRange('Positive')]
        [Int64] $ComponentId,

        [Parameter(Mandatory = $true,
            ValueFromPipeline = $true,
            ValueFromPipelineByPropertyName = $true)]
        [ValidateRange('Positive')]
        [Int64] $RecordId,

        [Parameter(Mandatory = $true,
            ValueFromPipeline = $true,
            ValueFromPipelineByPropertyName = $true)]
        [ValidateRange('Positive')]
        [Int64] $FieldId
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
        if ($Script:LockpathConfig.loggingLevel -eq 'Debug') {
            Write-LockpathInvocationLog -Confirm:$false -WhatIf:$false -FunctionName $functionName -Level $level -Service $service
        }

        $restParameters = [ordered]@{
            'Description' = 'Getting Attachments By Component, Record & Field Id'
            'Method'      = 'GET'
            'Query'       = "?ComponentId=$ComponentId&RecordId=$RecordId&FieldId=$FieldId"
            'Service'     = $service
            'UriFragment' = 'GetRecordAttachments'
        }

        $shouldProcessTarget = "ComponentId=$ComponentId, RecordId=$RecordId & FieldId=$FieldId"

        # TODO possibly update to save file similar to Get-LockpathReport

        if ($PSCmdlet.ShouldProcess($shouldProcessTarget)) {
            try {
                [string] $result = Invoke-LockpathRestMethod @restParameters
                $logParameters.message = 'success'
            } catch {

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
