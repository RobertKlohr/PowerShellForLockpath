function Get-LpRecordsDetail {
    [CmdletBinding()]
    [OutputType([int])]
    #TODO: Work on making this more user friendly, and to only allow valid combinations (parameter sets)
    param(
        # Full URi to the Lockpath instance.
        [Parameter(Mandatory = $false, ValueFromPipeline = $true)]
        $Session,
        # Id of the component
        [Parameter(Mandatory = $true, ValueFromPipeline = $true)]
        [int]
        $ComponentId,
        # The index of the page of result to return. Must be >0.
        [Parameter(Mandatory = $true, ValueFromPipeline = $true)]
        [ValidateRange(0, [int]::MaxValue)]
        [int]
        $PageIndex,
        # The size of the page results to return. Must be >=1.
        [Parameter(Mandatory = $true, ValueFromPipeline = $true)]
        [ValidateRange(1, [int]::MaxValue)]
        [int]
        $PageSize,
        # The filter parameters the users must meet to be included.
        [Parameter(Mandatory = $false, ValueFromPipeline = $true)]
        [ValidateSet("Active", "Deleted", "AccountType")]
        [string]
        $FilterField,
        # The filter parameters the users must meet to be included.
        [Parameter(Mandatory = $false, ValueFromPipeline = $true)]
        [ValidateSet("5", "6", "10002")]
        [string]
        $FilterType,
        # The filter parameters the users must meet to be included.
        [Parameter(Mandatory = $false, ValueFromPipeline = $true)]
        [ValidateSet("True", "False", "1", "2", "4")]
        [string]
        $FilterValue
    )

    begin {
        $ResourcePath = "/ComponentService/GetDetailRecords"
        $Method = 'POST'

        #TODO: Implement Filters
        $Body = [ordered]@{
            "componentId" = $ComponentId
            "pageIndex"   = $PageIndex
            "pageSize"    = $PageSize
            "filters"     = @()
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
