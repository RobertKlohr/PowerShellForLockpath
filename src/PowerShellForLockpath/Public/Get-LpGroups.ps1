function Get-LpGroups {
    [CmdletBinding()]
    [OutputType([PSCustomObject])]

    param(
        # The index of the page of result to return. Must be >0.
        [Parameter(Mandatory = $false, ValueFromPipeline = $true)]
        [ValidateRange(0, [int]::MaxValue)]
        [int]
        $PageIndex = 0,
        # The size of the page results to return. Must be >=1.
        [Parameter(Mandatory = $false, ValueFromPipeline = $true)]
        [ValidateRange(1, [int]::MaxValue)]
        [int]
        $PageSize = 1000,
        #TODO: implement filter
        # The filter parameters the groups must meet to be included.
        [Parameter(Mandatory = $false, ValueFromPipeline = $true)]
        [string]
        $PageFilter,
        # URL to the Lockpath instance.
        [Parameter(Mandatory = $false, ValueFromPipeline = $true)]
        [uri]
        $Url = $LpUrl,
        # Web session with authentication cookie set.
        [Parameter(Mandatory = $false, ValueFromPipeline = $true)]
        $Session = $LpSession
    )

    begin {
        $Parameters = @{
            Body       = @{
                "pageIndex" = $PageIndex
                "pageSize"  = $PageSize
            } | ConvertTo-Json
            Method     = 'POST'
            Uri        = $LpUrl + "/SecurityService/GetGroups"
            WebSession = $Session
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
