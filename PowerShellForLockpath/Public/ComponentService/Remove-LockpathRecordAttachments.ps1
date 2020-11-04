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

        The Git repo for this module can be found here: https://github.com/RobertKlohr/PowerShellForLockpath

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
        Remove-LockpathRecordAttachments -ComponentId 10066 -RecordId 301 -FieldId 1434 -DocumentId @{Id = 1833}, @{Id = 1832}
    .INPUTS
        String, System.Uint32

    .OUTPUTS
        String

    .NOTES
        The authentication account must have Read and Delete General Access permissions for the specific component,
        record and field.

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
            ValueFromPipeline = $true,
            ValueFromPipelineByPropertyName = $true)]
        [Alias('Component')]
        [ValidateRange('Positive')]
        [Int64] $ComponentId,

        [Parameter(
            Mandatory = $true,
            ValueFromPipeline = $true,
            ValueFromPipelineByPropertyName = $true)]
        [Alias('Record')]
        [ValidateRange('Positive')]
        [Int64] $RecordId,

        [Parameter(
            Mandatory = $true,
            ValueFromPipeline = $true,
            ValueFromPipelineByPropertyName = $true)]
        [Alias('Field')]
        [ValidateRange('Positive')]
        [Int64] $FieldId,

        [Parameter(
            Mandatory = $true,
            ValueFromPipeline = $true,
            ValueFromPipelineByPropertyName = $true)]
        [Alias('Document')]
        [Array] $DocumentId
    )

    begin {
        Write-LockpathInvocationLog -Confirm:$false -WhatIf:$false
    }

    process {
        $Body = [ordered]@{
            'componentId'   = $ComponentId
            'dynamicRecord' = [ordered]@{'Id' = $RecordId
                'FieldValues'                 = @(@{'key' = $FieldId
                        'value'           = $DocumentId
                    }
                )
            }
        }

        $params = @{
            'UriFragment' = 'ComponentService/DeleteRecordAttachments'
            'Method'      = 'POST'
            'Description' = "Deleting attachment from component Id: $ComponentId, record Id: $RecordId, field Id: $FieldId & document Id: $DocumentId"
            'Body'        = $Body | ConvertTo-Json -Depth 10
        }

        if ($PSCmdlet.ShouldProcess("Getting attachments from field with: $([environment]::NewLine) component Id $ComponentId, record Id: $RecordId, $FieldId & document Id: $($params.Body)", "component Id $ComponentId, record Id: $RecordId, $FieldId & document Id: $($params.Body)", 'Getting attachments from field with:')) {
            [String] $result = Invoke-LockpathRestMethod @params -Confirm:$false
            return $result
        } else {
            Write-LockpathLog -Message "$($PSCmdlet.CommandRuntime.ToString()) ShouldProcess confirmation was denied." -Level Verbose -Confirm:$false -WhatIf:$false
        }
    }

    end {
    }
}
