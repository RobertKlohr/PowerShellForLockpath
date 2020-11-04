function Get-LockpathGroupsDetails {
    #FIXME Update to new coding standards
    [CmdletBinding()]
    [OutputType('System.Int32')]

    param(
        # Full URi to the Lockpath instance.
        [Parameter(ValueFromPipeline = $true)]
        $Session
    )

    begin {
        Write-LockpathInvocationLog -Confirm:$false -WhatIf:$false
        $Response = @()
        $Groups = Get-LpGroups $SessionManager
    }

    process {
        try {
            for ($i = 0; $i -lt $Groups.length; $i++) {
                $Response += (Get-LockpathGroup $SessionManager $Groups[$i].id)
            }
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
