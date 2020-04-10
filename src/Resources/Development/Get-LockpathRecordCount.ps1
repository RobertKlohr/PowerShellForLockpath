#TODO setup for filters
function Get-LockpathRecordCount {
    [CmdletBinding()]
    [OutputType([int])]

    #TODO: Work on making this more user friendly, and to only allow valid combinations (parameter sets)
    param(
        # Full URi to the Lockpath instance.
        [Parameter(Mandatory = $true, ValueFromPipeline = $true)]
        $Session,
        # Id of the component
        [Parameter(Mandatory = $true, ValueFromPipeline = $true)]
        [int]
        $ComponentId,
        # The filter parameters the users must meet to be included.
        [Parameter(Mandatory = $true, ValueFromPipeline = $true)]
        [int]
        $FieldPath,
        # The filter parameters the users must meet to be included.
        [Parameter(Mandatory = $true, ValueFromPipeline = $true)]
        [ValidateSet(1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 10001, 10002, 10003, 10004, 10005)]
        [int]
        $FilterType,
        # The filter parameters the users must meet to be included.
        [Parameter(Mandatory = $true, ValueFromPipeline = $true)]
        [string]
        $Value
    )

    begin {
        $ResourcePath = "/ComponentService/GetRecordCount"
        $Method = 'POST'

        #TODO: Implement Filters
        #TODO: Exclude value tags from filter types 13, 14, 15, 16

        $Body = [ordered]@{
            "componentId" = $ComponentId
            "filters"     = @(
                [ordered]@{
                    "FieldPath"  = @(
                        $FieldPath
                    )
                    "FilterType" = $FilterType
                    "Value"      = $Value
                }
            )
        } | ConvertTo-Json -Depth 99

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
