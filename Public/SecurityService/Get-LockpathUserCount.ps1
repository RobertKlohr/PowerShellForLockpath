# Copyright (c) Robert Klohr. All rights reserved.
# Licensed under the MIT License.

function Get-LockpathUserCount {
    <#
    .SYNOPSIS
        Returns the number of users.

    .DESCRIPTION
        Returns the number of users. The count does not include Deleted users and can include non-Lockpath user
        accounts, such as Vendor Contacts.

        The Git repo for this module can be found here: https://git.io/powershellforlockpath

    .PARAMETER Filter
        The filter parameters the groups must meet to be included.

        Remove the filter to return a list of all groups.

    .EXAMPLE
        Get-LockpathUserCount

    .EXAMPLE
        Get-LockpathUserCount -Filter @(@{'Field'= @{'ShortName'='AccountType'}; 'FilterType'='5'; 'Value'='2'})

        Returns a set of users with the account type of Vendor.

    .EXAMPLE
        Get-LockpathUserCount -Filter @(@{'Field'= @{'ShortName'='Deleted'}; 'FilterType'='5'; 'Value'='true'},@{'Field'= @{'ShortName'='AccountType'}; 'FilterType'='5'; 'Value'='1'})

        Returns a set of users with the account type of vendor and status of Inactive.

    .INPUTS
        System.Array

    .OUTPUTS
        System.Int64

    .NOTES
        Native API Request: https://[InstanceName]:[InstancePort]/SecurityService/GetUserCount

        The authentication account must have Read Administrative Access permissions to administer users.

    .LINK
        https://git.io/powershellforlockpathhelp
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
        if ($Script:LockpathConfig.loggingLevel -eq 'Debug') {
            Write-LockpathInvocationLog -Confirm:$false -WhatIf:$false -FunctionName $functionName -Level $level -Service $service
        }

        If ($Filter.Count -gt 0) {
            $Body = [ordered]@{}
            $Body.Add('filters', $Filter)
        }

        $restParameters = [ordered]@{
            'Body'        = $Body | ConvertTo-Json -Depth $Script:LockpathConfig.jsonConversionDepth -AsArray
            'Description' = 'Getting User Count By Filter'
            'Method'      = 'POST'
            'Service'     = $service
            'UriFragment' = 'GetUserCount'
        }
        # TODO There is a bug in the GetUserCount API request (NAVEX Global ticket 01817531)
        # To compensate for this bug we need to edit the JSON in $restParameters.body so that it does not use the
        # filters key. When the bug is fixed we can delete the next line.
        $restParameters.Body = $Filter | ConvertTo-Json -Depth $Script:LockpathConfig.jsonConversionDepth

        $logParameters = [ordered]@{
            'Confirm'      = $false
            'WhatIf'       = $false
            'Message'      = $message
            'FunctionName' = $functionName
            'Level'        = $level
            'Service'      = $service
        }

        $shouldProcessTarget = "Filter=$($restParameters.Body)"

        if ($PSCmdlet.ShouldProcess($shouldProcessTarget)) {
            try {
                $result = Invoke-LockpathRestMethod @restParameters
                $logParameters.message = 'success'
            } catch {
                $result = ($_.ErrorDetails.Message | ConvertFrom-Json).Message
                $logParameters.message = 'failed'
                $logParameters.level = 'Warning'
            } finally {
                Write-LockpathLog @logParameters
            }
            return $result
        }
    }

    end {
    }
}
