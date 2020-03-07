function Get-LpFieldList {
    [CmdletBinding()]
    [OutputType([int])]

    param(
        # Full URi to the Lockpath instance.
        [Parameter(Mandatory = $false, ValueFromPipeline = $true)]
        $Session,
        # Id of the component
        [Parameter(Mandatory = $true, ValueFromPipeline = $true)]
        [int]
        $ComponentId
    )

    begin {
        $ResourcePath = "/ComponentService/GetFieldList"
        $Method = 'GET'
        $Query = '?ComponentId=' + $ComponentId

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
