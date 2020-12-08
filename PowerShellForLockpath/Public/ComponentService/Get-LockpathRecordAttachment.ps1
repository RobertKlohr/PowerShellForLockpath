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

        The Git repo for this module can be found here: https://github.com/RobertKlohr/PowerShellForLockpath

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
        https://github.com/RobertKlohr/PowerShellForLockpath/wiki
    #>

    [CmdletBinding(
        ConfirmImpact = 'Low',
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
        [ValidateRange('Positive')]
        [Int64] $DocumentId
    )

    begin {
        Write-LockpathInvocationLog -Confirm:$false -WhatIf:$false -Service ComponentService
    }

    process {
        $params = @{
            'UriFragment' = "ComponentService/GetRecordAttachment?componentId=$ComponentId&recordId=$RecordId&fieldId=$FieldId&documentId=$DocumentId"
            'Method'      = 'GET'
            'Description' = "Getting attachment from component Id: $ComponentId, record Id: $RecordId, field Id: $FieldId & document Id: $DocumentId"
        }

        if ($PSCmdlet.ShouldProcess("Getting attachment from field with: $([environment]::NewLine) component Id $ComponentId, record Id: $RecordId, $FieldId & document Id: $DocumentId", "component Id $ComponentId, record Id: $RecordId, $FieldId & document Id: $DocumentId", 'Getting attachment from field with:')) {
            [String] $result = Invoke-LockpathRestMethod @params -Confirm:$false
            return $result
        } else {
            Write-LockpathLog -Confirm:$false -WhatIf:$false -Message 'ShouldProcess confirmation was denied.' -Level Verbose -FunctionName ($PSCmdlet.CommandRuntime.ToString()) -Service ComponentService
        }
    }

    end {
    }
}
