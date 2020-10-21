function Get-LockpathRecordAttachment {
    #TODO Create Help Section
    #TODO Update to new coding standards
    [CmdletBinding(
        ConfirmImpact = 'Low',
        PositionalBinding = $false,
        SupportsShouldProcess = $true)]
    [OutputType('System.String')]
    [Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSShouldProcess', '', Justification = 'Methods called within here make use of PSShouldProcess, and the switch is passed on to them inherently.')]

    param(
        [Parameter(Mandatory = $true, ValueFromPipeline = $true)]
        [ValidateRange(1, [int]::MaxValue)]
        [int] $ComponentId,

        [Parameter(Mandatory = $true, ValueFromPipeline = $true)]
        [ValidateRange(1, [int]::MaxValue)]
        [int] $RecordId,

        [Parameter(Mandatory = $true, ValueFromPipeline = $true)]
        [ValidateRange(1, [int]::MaxValue)]
        [int] $FieldId,

        [Parameter(Mandatory = $true, ValueFromPipeline = $true)]
        [ValidateRange(1, [int]::MaxValue)]
        [int] $DocumentId
    )

    begin {
        Write-LockpathInvocationLog
        $params = @{ }
        $params = @{
            'UriFragment' = "ComponentService/GetRecordAttachment?componentId=$ComponentId&recordId=$RecordId&fieldId=$FieldId&documentId=$DocumentId"
            'Method'      = 'GET'
            'Description' = "Get Record Attachment with Component Id: $ComponentId, Record Id: $RecordId, Field Id: $FieldId and Document Id: $DocumentId"
        }
    }

    process {
        $result = Invoke-LockpathRestMethod @params
    }

    end {
        return $result
    }
}
