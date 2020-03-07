function Send-LpLogout {
    [CmdletBinding()]
    [OutputType([Boolean])]
    param(
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
            Method     = 'GET'
            Uri        = $LpUrl + "/SecurityService/Logout"
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
