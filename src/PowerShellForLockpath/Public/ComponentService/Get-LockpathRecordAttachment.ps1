function Get-LockpathRecordAttachment {
    <#
.SYNOPSIS
    Returns a single file specified by the component Id, record Id, field Id and Document Id.
.DESCRIPTION
    Returns a single file specified by the component Id, record Id, field Id and Document Id. The document Id may
    be found by using Get-LockpathRecordAttachment. The file contents are returned as a Base64 string.
.PARAMETER ComponentId
    Specifies the Id number of the component as a positive integer.
.PARAMETER RecordId
    Specifies the Id number of the record as a positive integer.
.PARAMETER FieldId
    Specifies the Id number of the field as a positive integer.
.PARAMETER DocumentId
    Specifies the Id number of the document as a positive integer.
.EXAMPLE
    Get-LockpathRecordAttachment -ComponentId 2 -RecordId 1 -FieldId 1 -DocumentId 1
.INPUTS
    System.Uint32.
.OUTPUTS
    System.String.
.NOTES
    The authentication account must have Read General Access permissions for the specific component, record and
    field.
.LINK
    https://github.com/RobertKlohr/PowerShellForLockpath
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
        [Alias("Component")]
        [ValidateRange("Positive")]
        [int] $ComponentId,

        [Parameter(
            Mandatory = $true,
            ValueFromPipeline = $true,
            ValueFromPipelineByPropertyName = $true)]
        [Alias("Record")]
        [ValidateRange("Positive")]
        [int] $RecordId,

        [Parameter(
            Mandatory = $true,
            ValueFromPipeline = $true,
            ValueFromPipelineByPropertyName = $true)]
        [Alias("Field")]
        [ValidateRange("Positive")]
        [int] $FieldId,

        [Parameter(
            Mandatory = $true,
            ValueFromPipeline = $true,
            ValueFromPipelineByPropertyName = $true)]
        [Alias("Document")]
        [ValidateRange("Positive")]
        [int] $DocumentId
    )

    begin {
        Write-LockpathInvocationLog -Confirm:$false -WhatIf:$false
    }

    process {
        $params = @{
            'UriFragment' = "ComponentService/GetRecordAttachment?componentId=$ComponentId&recordId=$RecordId&fieldId=$FieldId&documentId=$DocumentId"
            'Method'      = 'GET'
            'Description' = "Getting attachments from component Id: $ComponentId, record Id: $RecordId, field Id: $FieldId & document Id: $DocumentId"
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
