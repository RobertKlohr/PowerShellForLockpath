function New-LockpathGroup {
    #FIXME Update to new coding standards
    [CmdletBinding()]
    [OutputType('System.Int32')]

    param(
        # Full URi to the Lockpath instance.
        [Parameter(ValueFromPipeline = $true)]
        $Session = 0,
        # The fields used to populate the group configuration.
        [Parameter(Mandatory = $true, ValueFromPipeline = $true)]
        [string]
        $Fields = 10000
    )

    begin {
        $ResourcePath = "/SecurityService/CreateGroup"
        $Body = @{
            "Fields" = $Fields
        } | ConvertTo-Json

        $Parameters = @{
            Uri        = $LpUrl + $ResourcePath
            WebSession = $LpSession
            Method     = "POST"
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
