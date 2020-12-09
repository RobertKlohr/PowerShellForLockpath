function Get-LockpathUsers {
    <#
    .SYNOPSIS
        Returns a list of users and available fields.

    .DESCRIPTION
        Returns a list of users and available fields. The list does not include Deleted users and can include
        non-Lockpath user accounts. Use a filter to return only the users meeting the selected criteria.

        Remove the filter to return a list of all users including deleted non-Lockpath user accounts.

        The Git repo for this module can be found here: https://github.com/RobertKlohr/PowerShellForLockpath

    .PARAMETER All
        Get all users.

        Sets -PageIndex = 0, -PageSize = Get-LockpathUserCount, and $Filter = @()

    .PARAMETER PageIndex
        The index of the page of result to return.

        If not set it defaults to the value set in the configuration.

    .PARAMETER PageSize
        The size of the page results to return.

        If not set it defaults to the value set in the configuration.

    .PARAMETER Filter
        A filter used to return only the users meeting the selected criteria.

    .EXAMPLE
        Get-LockpathUsers

        Returns all users with the -PageIndex and -PageSize defaulting to the values in the module configuration.

    .EXAMPLE
        Get-LockpathUsers -All

        Returns all users by setting -PageIndex = 0, -PageSize = Get-LockpathUserCount, and $Filter = @()

    .EXAMPLE
        Get-LockpathUsers -PageIndex 0 -PageSize 100

        Returns the first 100 users in the system.

    .EXAMPLE
        Get-LockpathUsers -Filter @{'Field'= @{'ShortName'='AccountType'}; 'FilterType'='10002'; 'Value'='1|2'}

        Returns a set of users matching the filter with the -PageIndex and -PageSize defaulting to the values in the module configuration.

    .EXAMPLE
        Get-LockpathUsers -PageIndex 1 -PageSize 100 -Filter @{'Field'= @{'ShortName'='AccountType'}; 'FilterType'='10002'; 'Value'='1|2'}

        Returns the first 100 users in the system matching the filter.

    .INPUTS
        System.Array System.UInt32

    .OUTPUTS
        String

    .NOTES
        Native API Request: https://[InstanceName]:[InstancePort]/SecurityService/GetUsers

        The authentication account must have Read Administrative Access permissions to administer users.

    .LINK
        https://github.com/RobertKlohr/PowerShellForLockpath/wiki
    #>

    [CmdletBinding(
        ConfirmImpact = 'Low',
        PositionalBinding = $false,
        SupportsShouldProcess = $true,
        DefaultParameterSetName = 'Default')]
    [OutputType('System.String')]

    param(
        [Parameter(
            Mandatory = $false,
            ParameterSetName = 'All')]
        [Switch] $All,

        [Parameter(
            Mandatory = $false,
            ParameterSetName = 'Default')]
        [ValidateRange('NonNegative')]
        [Int32] $PageIndex = $Script:LockpathConfig.pageIndex,

        [Parameter(
            Mandatory = $false,
            ParameterSetName = 'Default')]
        [ValidateRange('Positive')]
        [Int32] $PageSize = $Script:LockpathConfig.pageSize,

        [Parameter(
            Mandatory = $false,
            ParameterSetName = 'Default')]
        [Array] $Filter = @()
    )

    begin {
        $level = 'Information'
        $functionName = ($PSCmdlet.CommandRuntime.ToString())
        $service = 'SecurityService'
    }

    process {
        Write-LockpathInvocationLog -Confirm:$false -WhatIf:$false -FunctionName $functionName -Level $level -Service $service

        if ($All) {
            $PageIndex = 0
            $PageSize = Get-LockpathUserCount
            $Filter = @()
            #$Filter = '[{"Field":{"ShortName":"AccountType"},"FilterType":"10002","Value":"1|2|4"}]'
        }

        $Body = [ordered]@{
            'pageIndex' = $PageIndex
            'pageSize'  = $PageSize
            'filters'   = $Filter
        }

        $params = @{
            'Body'        = $Body | ConvertTo-Json -Depth $Script:LockpathConfig.jsonConversionDepth -Compress
            'Description' = 'Getting Users By Filter'
            'Method'      = 'POST'
            'Service'     = $service
            'UriFragment' = 'GetUsers'
        }

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
