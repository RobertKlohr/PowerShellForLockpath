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

    .PARAMETER ComponentId
        Specifies the Id number of the component as a positive integer. The component Id may be found by using
        Get-LockpathComponents.

    .PARAMETER RecordId
        Specifies the Id number of the record as a positive integer. The record Id may be found by using
        Get-LockpathRecords.

    .PARAMETER FieldId
        Specifies the Id number of the field as a positive integer. The field Id may be found by using
        Get-LockpathFieldsList.

    .PARAMETER DocumentId
        Specifies the Id number of the document as a positive integer. The document Id may be found by using
        Get-LockpathRecordAttachment.

    .EXAMPLE
        Remove-LockpathRecordAttachments -ComponentId 10066 -RecordId 301 -FieldId 1434 -DocumentId 2014

    .INPUTS
        System.Uint32

    .OUTPUTS
        System.String

    .NOTES
        The authentication account must have Read and Delete General Access permissions for the specific component,
        record and field.

        There is an inconsistency in the API that requires the recordId and fieldId values to be formattted as an
        array and uses a different name for the recordId (dynamicRecord).  It also nests the fieldId in the
        recordId. As only a single recordId or fieldId is valid and the field that can take multiple values is the
        document Id field I have chosen to make have this function be consistant in how handles parameters.

    .LINK
        https://github.com/RobertKlohr/PowerShellForLockpath
    #>

    [CmdletBinding(
        ConfirmImpact = 'High',
        PositionalBinding = $false,
        SupportsShouldProcess = $true)]
    [OutputType('System.String')]

    param(
        [Parameter(
            Mandatory = $true,
            ValueFromPipeline = $true,
            ValueFromPipelineByPropertyName = $true)]
        [Alias("Component")]
        [ValidateRange("Positive")]
        [uint] $ComponentId,

        [Parameter(
            Mandatory = $true,
            ValueFromPipeline = $true,
            ValueFromPipelineByPropertyName = $true)]
        [Alias("Record")]
        [ValidateRange("Positive")]
        [uint] $RecordId,

        [Parameter(
            Mandatory = $true,
            ValueFromPipeline = $true,
            ValueFromPipelineByPropertyName = $true)]
        [Alias("Field")]
        [ValidateRange("Positive")]
        [uint] $FieldId,

        [Parameter(
            Mandatory = $true,
            ValueFromPipeline = $true,
            ValueFromPipelineByPropertyName = $true)]
        [Alias("Document")]
        [ValidateRange("Positive")]
        [uint] $DocumentId
    )

    begin {
        Write-LockpathInvocationLog -Confirm:$false -WhatIf:$false
    }

    process {
        # There is an inconsistency in the API that requires the recordId and fieldId values to be formattted as an
        # array and uses a different name for the recordId (dynamicRecord).  It also nests the fieldId in the
        # recordId. As only a single recordId or fieldId is valid and the field that can take multiple values is
        # the document Id field I have chosen to make have this function be consistant in how handles parameters.

        #TODO Update the parameters and logic to support passing multipule document Id values at the same time.
        $Body = [ordered]@{
            'componentId'   = $ComponentId
            'dynamicRecord' = [ordered]@{'Id' = $RecordId
                'FieldValues'                 = @([ordered]@{ 'key' = $FieldId
                        'value'                     = @([ordered]@{'Id' = $DocumentId })
                    })
            }
        }

        $params = @{
            'UriFragment' = 'ComponentService/DeleteRecordAttachments'
            'Method'      = 'POST'
            'Description' = "Deleting attachment from component Id: $ComponentId, record Id: $RecordId, field Id: $FieldId & document Id: $DocumentId"
            'Body'        = $Body | ConvertTo-Json -Depth 10
        }
        if ($PSCmdlet.ShouldProcess("Getting attachments from field with: $([environment]::NewLine) component Id $ComponentId, record Id: $RecordId, $FieldId & document Id: $DocumentId", "component Id $ComponentId, record Id: $RecordId, $FieldId & document Id: $DocumentId", 'Getting attachments from field with:')) {
            $result = Invoke-LockpathRestMethod @params -Confirm:$false
            return $result
        } else {
            Write-LockpathLog -Message "$($PSCmdlet.CommandRuntime.ToString()) ShouldProcess confirmation was denied." -Level Verbose -Confirm:$false -WhatIf:$false
        }
    }

    end {
    }
}
