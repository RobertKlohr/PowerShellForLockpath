function Get-LpRecordAttachment {
    [CmdletBinding()]
    [OutputType([int])]

    #FIXME: Remove defaults after testing is complete

    param(
        # Full URi to the Lockpath instance.
        [Parameter(Mandatory = $false, ValueFromPipeline = $true)]
        $Session,
        # Id of the component
        [Parameter(Mandatory = $false, ValueFromPipeline = $true)]
        [int]
        $ComponentId = 10013,
        # Id of the record
        [Parameter(Mandatory = $false, ValueFromPipeline = $true)]
        [int]
        $RecordId = 1,
        # Id of the field
        [Parameter(Mandatory = $false, ValueFromPipeline = $true)]
        [int]
        $FieldId = 618,
        # Id of the document
        [Parameter(Mandatory = $false, ValueFromPipeline = $true)]
        [int]
        $DocumentId = 26
    )

    begin {
        $ResourcePath = "/ComponentService/GetRecordAttachment"
        $Method = "GET"
        $Query = "?ComponentId=$ComponentId&recordId=$RecordId&FieldId=$FieldId&DocumentId=$DocumentId"
        $Parameters = @{
            Uri        = $LpUrl + $ResourcePath + $Query
            WebSession = $LpSession
            Method     = $Method
        }
    }

    Process {
        try {
            $Response = Invoke-RestMethod @Parameters -ErrorAction Stop
        } catch {
            # Get the message returned from the server which will be in JSON format
            #$ErrorMessage = $_.ErrorDetails.Message | ConvertFrom-Json | Select -ExpandProperty Message
            $ErrorRecord = New-Object System.Management.Automation.ErrorRecord(
                (New-Object Exception("Exception executing the Invoke-RestMethod cmdlet. $($_.ErrorDetails.Message)")),
                'Invoke-RestMethod',
                [System.Management.Automation.ErrorCategory]$_.CategoryInfo.Category,
                $parameters
            )
            $ErrorRecord.CategoryInfo.Reason = $_.CategoryInfo.Reason;
            $ErrorRecord.CategoryInfo.Activity = $_.InvocationInfo.InvocationName;
            $PSCmdlet.ThrowTerminatingError($ErrorRecord);
        }
    }
    end {
        Return $Response
    }
}
