function Get-LockpathUserCount {
    <#
    .SYNOPSIS
        Returns the number of users.

    .DESCRIPTION
        Returns the number of users. The count does not include Deleted users and can include non-Lockpath user
        accounts, such as Vendor Contacts.

        The Git repo for this module can be found here: https://github.com/RobertKlohr/PowerShellForLockpath

    .PARAMETER Filter
        The filter parameters the groups must meet to be included.

        Remove the filter to return a list of all groups.

    .EXAMPLE
        Get-LockpathUserCount

    .EXAMPLE
        Get-LockpathUserCount -Filter @{'Field'= @{'ShortName'='AccountType'}; 'FilterType'='10002'; 'Value'='1|2'}

    .INPUTS
        System.Array

    .OUTPUTS
        System.Int64

    .NOTES
        Native API Request: https://[InstanceName]:[InstancePort]/SecurityService/GetUserCount

        The authentication account must have Read Administrative Access permissions to administer users.

    .LINK
        https://github.com/RobertKlohr/PowerShellForLockpath/wiki
    #>

    [CmdletBinding(
        ConfirmImpact = 'Low',
        PositionalBinding = $false,
        SupportsShouldProcess = $true)]
    [OutputType('System.Int64')]

    param(
        [Array] $Filter = @()
    )

    begin {
        $level = 'Information'
        $functionName = ($PSCmdlet.CommandRuntime.ToString())
        $service = 'SecurityService'
    }

    process {
        Write-LockpathInvocationLog -Confirm:$false -WhatIf:$false -FunctionName $functionName -Level $level -Service $service

        If ($Filter.Count -gt 0) {
            $Body = [ordered]@{}
            $Body.Add('filters', $Filter)
        }

        $params = @{
            'Body'        = $Body | ConvertTo-Json -Depth $Script:LockpathConfig.jsonConversionDepth
            'Description' = 'Getting User Count By Filter'
            'Method'      = 'POST'
            'Service'     = $service
            'UriFragment' = 'GetUserCount'
        }

        # FIXME check all functions with filters

        # TODO There is a bug in the GetUserCount API request (NAVEX Global ticket 01817531)
        # To compensate for this bug we need to edit the JSON in $params.body so that it does not use the filters key
        # and to then wrap it in a set of brackets.
        # When the bug is fixed we can delete the next line.
        $params.Body = "[$($Filter | ConvertTo-Json -Depth $Script:LockpathConfig.jsonConversionDepth)]"

        $target = "Filter=$($params.Body)"

        if ($PSCmdlet.ShouldProcess($target)) {
            try {
                $result = Invoke-LockpathRestMethod @params
                $message = 'success'
            } catch {
                $message = 'failed'
                $level = 'Warning'
            }
            Write-LockpathLog -Confirm:$false -WhatIf:$false -Message $message -FunctionName $functionName -Level $level -Service $service
            If ($message -eq 'failed') {
                return $message
            } else {
                return $result
            }
        }
    }

    end {
    }
}
