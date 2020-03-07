function Get-LpLookupReportColumnFields {
    [CmdletBinding()]
    [OutputType([int])]

    #FIXME: Remove defaults after testing is complete
    param(
        # Full URi to the Lockpath instance.
        [Parameter(Mandatory = $false, ValueFromPipeline = $true)]
        $LookupFieldId = 605,
        # Id of field
        [Parameter(Mandatory = $false, ValueFromPipeline = $true)]
        [int]
        $FieldPathId = 5042
    )

    begin {
        $ResourcePath = "/ComponentService/GetLookupReportColumnFields"
        $Query = "?lookupFieldId=$LookupFieldId&fieldPathId=$FieldPathId"

        $Parameters = @{
            Uri        = $LpUrl + $ResourcePath + $Query
            WebSession = $LpSession
            Method     = "GET"
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
