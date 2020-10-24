function Remove-LockpathRecordAttachment {
    #FIXME Update to new coding standards
    [CmdletBinding(
        ConfirmImpact = 'High',
        PositionalBinding = $false,
        SupportsShouldProcess = $true)]
    [OutputType('System.String')]
    [Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSShouldProcess', '', Justification = 'Methods called within here make use of PSShouldProcess, and the switch is passed on to them inherently.')]


    param(
        [Parameter(
            Mandatory = $true,
            ValueFromPipeline = $true,
            ValueFromPipelineByPropertyName = $true)]
        [Alias("Component")]
        [ValidateRange("Positive")]
        [uint]      $ComponentId,

        [Parameter(
            Mandatory = $true,
            ValueFromPipeline = $true,
            ValueFromPipelineByPropertyName = $true)]
        [Alias("Record")]
        [ValidateRange("Positive")]
        [uint]      $RecordId,

        [Parameter(
            Mandatory = $true,
            ValueFromPipeline = $true,
            ValueFromPipelineByPropertyName = $true)]
        [Alias("Field")]
        [ValidateRange("Positive")]
        [uint]      $FieldId,

        [Parameter(
            Mandatory = $true,
            ValueFromPipeline = $true,
            ValueFromPipelineByPropertyName = $true)]
        [Alias("Attachment")]
        [ValidateRange("Positive")]
        [uint]      $AttachmentId
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
