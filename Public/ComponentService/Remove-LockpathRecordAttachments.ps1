# Copyright (c) Robert Klohr. All rights reserved.
# Licensed under the MIT License.

function Remove-LockpathRecordAttachments {
    <#
    .SYNOPSIS
        Deletes the specified attachment from the provided the component Id, record Id, field Id and Document Id.

    .DESCRIPTION
        Deletes the specified attachment from the provided the component Id, record Id, field Id and Document Id.

        The component Id may be found by using Get-LockpathComponents
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
        Remove-LockpathRecordAttachments -ComponentId 10066 -RecordId 301 -FieldId 1434 -DocumentId @{Id = 1833}, @{Id = 1832}

    .INPUTS
        String, System.UInt32

    .OUTPUTS
        String

    .NOTES
        Native API Request: https://[InstanceName]:[InstancePort]/ComponentService/DeleteRecordAttachments

        The authentication account must have Read and Delete General Access permissions for the specific component,
        record and field.

    .LINK
        https://git.io/powershellforlockpathhelp
    #>

    [CmdletBinding(
        ConfirmImpact = 'High',
        PositionalBinding = $false,
        SupportsShouldProcess = $true)]
    [OutputType('System.String')]

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
        [Int64] $FieldId,

        [Parameter(Mandatory = $true,
            ValueFromPipeline = $true,
            ValueFromPipelineByPropertyName = $true)]
        [Array] $DocumentId
    )

    begin {
        $level = 'Information'
        $functionName = ($PSCmdlet.CommandRuntime.ToString())
        $service = 'ComponentService'
    }

    process {
        if ($Script:LockpathConfig.loggingLevel -eq 'Debug') {
            Write-LockpathInvocationLog -Confirm:$false -WhatIf:$false -FunctionName $functionName -Level $level -Service $service
        }

        $Body = [ordered]@{
            'componentId'   = $ComponentId
            'dynamicRecord' = [ordered]@{'Id' = $RecordId
                'FieldValues'                 = @(@{'key' = $FieldId
                        'value'           = $DocumentId
                    }
                )
            }
        }

        $restParameters = [ordered]@{
            'Body'        = $Body | ConvertTo-Json -Depth $Script:LockpathConfig.jsonConversionDepth
            'Description' = 'Deleting Record Attachment'
            'Method'      = 'POST'
            'Service'     = $service
            'UriFragment' = 'DeleteRecordAttachments'
        }

        $logParameters = [ordered]@{
            'Confirm'      = $false
            'WhatIf'       = $false
            'Message'      = $message
            'FunctionName' = $functionName
            'Level'        = $level
            'Service'      = $service
        }

        $shouldProcessTarget = "Filter=$($restParameters.Body)"

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
