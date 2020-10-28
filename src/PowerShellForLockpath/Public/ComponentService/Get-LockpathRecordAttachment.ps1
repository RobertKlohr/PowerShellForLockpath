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
        Specifies the Id number of the component as a positive integer. The component Id may be found by using Get-LockpathComponents.

    .PARAMETER RecordId
        Specifies the Id number of the record as a positive integer. The record Id may be found by using Get-LockpathRecords.

    .PARAMETER FieldId
        Specifies the Id number of the field as a positive integer. The field Id may be found by using Get-LockpathFieldsList.

    .PARAMETER DocumentId
        Specifies the Id number of the document as a positive integer. The document Id may be found by using Get-LockpathRecordAttachment.

    .EXAMPLE
        Get-LockpathRecordAttachment -ComponentId 2 -RecordId 1 -FieldId 1 -DocumentId 1

    .INPUTS
        System.Uint32

    .OUTPUTS
        System.String

    .NOTES
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
        [Parameter(
            Mandatory = $true,
            ValueFromPipeline = $true,
            ValueFromPipelineByPropertyName = $true)]
        [Alias('Component')]
        [ValidateRange('Positive')]
        [uint] $ComponentId,

        [Parameter(
            Mandatory = $true,
            ValueFromPipeline = $true,
            ValueFromPipelineByPropertyName = $true)]
        [Alias('Record')]
        [ValidateRange('Positive')]
        [uint] $RecordId,

        [Parameter(
            Mandatory = $true,
            ValueFromPipeline = $true,
            ValueFromPipelineByPropertyName = $true)]
        [Alias('Field')]
        [ValidateRange('Positive')]
        [uint] $FieldId,

        [Parameter(
            Mandatory = $true,
            ValueFromPipeline = $true,
            ValueFromPipelineByPropertyName = $true)]
        [Alias('Document')]
        [ValidateRange('Positive')]
        [uint] $DocumentId
    )

    begin {
        Write-LockpathInvocationLog -Confirm:$false -WhatIf:$false
    }

    process {
        $params = @{
            'UriFragment' = "ComponentService/GetRecordAttachment?componentId=$ComponentId&recordId=$RecordId&fieldId=$FieldId&documentId=$DocumentId"
            'Method'      = 'GET'
            'Description' = "Getting attachment from component Id: $ComponentId, record Id: $RecordId, field Id: $FieldId & document Id: $DocumentId"
        }

        if ($PSCmdlet.ShouldProcess("Getting attachment from field with: $([environment]::NewLine) component Id $ComponentId, record Id: $RecordId, $FieldId & document Id: $DocumentId", "component Id $ComponentId, record Id: $RecordId, $FieldId & document Id: $DocumentId", 'Getting attachment from field with:')) {
            [string] $result = Invoke-LockpathRestMethod @params -Confirm:$false
            return $result
        } else {
            Write-LockpathLog -Message "$($PSCmdlet.CommandRuntime.ToString()) ShouldProcess confirmation was denied." -Level Verbose -Confirm:$false -WhatIf:$false
        }
    }

    end {
    }
}
