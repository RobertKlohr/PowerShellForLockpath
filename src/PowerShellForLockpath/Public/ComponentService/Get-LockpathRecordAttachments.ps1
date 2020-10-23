function Get-LockpathRecordAttachments {
    <#
.SYNOPSIS
    Returns the file name, field Id and document Id for all attachments associated with a given record.
.DESCRIPTION
    Returns the file name, field Id and document Id for all attachments associated with a given record. The
    contents of the attachment are not returned.
.PARAMETER ComponentId
    Specifies the Id number of the component as a positive integer.
.PARAMETER RecordId
    Specifies the Id number of the record as a positive integer.
.PARAMETER FieldId
    Specifies the Id number of the field as a positive integer.
.EXAMPLE
    Get-LockpathRecordAttachments -ComponentId 2 -RecordId 1 -FieldId 1
.INPUTS
    System.Uint32.
.OUTPUTS
    System.String.
.NOTES
    The authentication account must have Read General Access permissions for the specific component, record and field.
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
        [int] $FieldId
    )

    begin {
        Write-LockpathInvocationLog -Confirm:$false -WhatIf:$false
    }

    process {
        $params = @{
            'UriFragment' = "ComponentService/GetRecordAttachments?componentId=$ComponentId&recordId=$RecordId&fieldId=$FieldId"
            'Method'      = 'GET'
            'Description' = "Getting attachments from component Id: $ComponentId, record Id: $RecordId & field Id: $FieldId"
        }
        if ($PSCmdlet.ShouldProcess("Getting attachments from field with: $([environment]::NewLine) component Id $ComponentId, record Id: $RecordId & F$ieldId", "component Id $ComponentId, record Id: $RecordId & $FieldId", 'Getting attachments from field with:')) {
            $result = Invoke-LockpathRestMethod @params -Confirm:$false
            return $result
        } else {
            Write-LockpathLog -Message "$($PSCmdlet.CommandRuntime.ToString()) ShouldProcess confirmation was denied." -Level Verbose -Confirm:$false -WhatIf:$false
        }
    }

    end {
    }
}
