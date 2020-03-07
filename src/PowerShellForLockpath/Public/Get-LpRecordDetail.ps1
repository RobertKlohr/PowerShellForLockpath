#TODO: rename
function Get-LpRecordDetail {
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
        $RecordId = 5,
        # Flag to extract embedded images in rich text files
        [Parameter(Mandatory = $false, ValueFromPipeline = $true)]
        [switch]
        $ExtractRichTextImages
    )

    begin {
        $ResourcePath = "/ComponentService/GetDetailRecord"
        $Method = 'GET'
        #TODO: implement extracting embedded images from rich text fields
        $Query = '?ComponentId=' + $ComponentId + "&recordId=" + $RecordId

        $Parameters = @{
            Uri        = $LpUrl + $ResourcePath + $Query
            WebSession = $LpSession
            Method     = $Method
        }
    }

    process {
        try {
            $Response = Invoke-RestMethod @parameters -ErrorAction Stop
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
