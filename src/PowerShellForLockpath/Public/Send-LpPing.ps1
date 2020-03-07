function Send-LpPing {
    [CmdletBinding()]
    [OutputType([Boolean])]

    #TODO: change $config to string URL
    param(
        # Lockpath session object.
        [Parameter(Mandatory = $true, ValueFromPipeline = $true)]
        [psobject]
        $WebSession,
        # Lockpath configuration object.
        [Parameter(Mandatory = $true, ValueFromPipeline = $true)]
        [psobject]
        $Config
    )

    begin {
        $Params = @{
            Config     = $Config
            WebSession = $WebSession
            HttpMethod = 'GET'
            UrlPath    = "/SecurityService/Ping"
        }
    }

    process {
        try {
            Invoke-LpRestMethod @Params | Write-Output -ErrorAction Stop
        } catch {
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
    }
}
