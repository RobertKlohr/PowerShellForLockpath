function Remove-LockpathRecordAttachment {
    #TODO Create Help Section
    #TODO Update to new coding standards
    [CmdletBinding(
        ConfirmImpact = 'High',
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
        [int] $AttachmentId
    )

    begin {
        Write-LockpathInvocationLog
        #TODO call get record attachment to add the attachment name into the log.
        $params = @{ }
        $params = @{
            'UriFragment' = 'ComponentService/DeleteRecordAttachments'
            'Method'      = 'POST'
            'Description' = "Deleting Record Attachment with Component Id: $ComponentId, Record Id: $RecordId, Field Id: $FieldId and Attachment Id: $AttachmentId"
            'Body'        = @{
                'ComponentId'   = $ComponentId
                'dynamicRecord' = @{
                    'Id'          = $RecordId
                    'FieldValues' = @(
                        @{
                            'key'   = $FieldId
                            'value' = @(
                                @{
                                    'Id' = $AttachmentId
                                }
                            )
                        }
                    )
                }
            } | ConvertTo-Json
        }
    }

    process {
        $result = Invoke-LockpathRestMethod @params
    }

    end {
        return $result
    }
}
