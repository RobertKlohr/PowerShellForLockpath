function Get-LpLookupRecords {
    [CmdletBinding()]
    [OutputType([int])]

    #TODO: Work on making this more user friendly, and to only allow valid combinations (parameter sets)
    #FIXME: Remove defaults after testing is complete
    param(
        # Full URi to the Lockpath instance.
        [Parameter(Mandatory = $false, ValueFromPipeline = $true)]
        $Session,
        # Id of the field
        [Parameter(Mandatory = $false, ValueFromPipeline = $true)]
        [int]
        $FieldId = 4198,
        # The index of the page of result to return. Must be >0.
        [Parameter(Mandatory = $false, ValueFromPipeline = $true)]
        [ValidateRange(0, [int]::MaxValue)]
        [int]
        $PageIndex = 0,
        # The size of the page results to return. Must be >=1.
        [Parameter(Mandatory = $false, ValueFromPipeline = $true)]
        [ValidateRange(1, [int]::MaxValue)]
        [int]
        $PageSize = 500,
        # Id of the record
        [Parameter(Mandatory = $false, ValueFromPipeline = $true)]
        [int]
        $RecordId = 5
    )

    begin {
        $ResourcePath = "/ComponentService/GetAvailableLookupRecords"
        $Method = 'POST'

        $Body = @{
            "fieldId"   = $FieldId
            "pageIndex" = $PageIndex
            "pageSize"  = $PageSize
            "recordId"  = $RecordId
        } | ConvertTo-Json

        $Parameters = @{
            Uri        = $LpUrl + $ResourcePath
            WebSession = $LpSession
            Method     = $Method
            Body       = $Body
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
