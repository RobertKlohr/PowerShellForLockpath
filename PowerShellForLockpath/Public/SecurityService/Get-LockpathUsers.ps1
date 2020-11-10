function Get-LockpathUsers {
    <#
    .SYNOPSIS
        Returns a list of users and available fields.

    .DESCRIPTION
        Returns a list of users and available fields. The list does not include Deleted users and can include
        non-Lockpath user accounts. Use filters to return only the users meeting the selected criteria. Remove all
        filters to return a list of all users including deleted non-Lockpath user accounts.

        The Git repo for this module can be found here: https://github.com/RobertKlohr/PowerShellForLockpath

    .PARAMETER PageIndex
        The index of the page of result to return.

        If not set it defaults to the value set in the configuration.

    .PARAMETER PageSize
        The size of the page results to return.

        If not set it defaults to the value set in the configuration.

    .PARAMETER Filters
        The filter parameters the groups must meet to be included. Must be an array. Use filters to return only the
        groups meeting the selected criteria. Remove all filters to return a list of all groups.

    .EXAMPLE
        Get-LockpathUsers

    .EXAMPLE
        Get-LockpathUsers -PageIndex 0 -PageSize 100

    .EXAMPLE
        Get-LockpathUsers -Filter @{'Field'= @{'ShortName'='AccountType'}; 'FilterType'='10002'; 'Value'='1|2'}

    .EXAMPLE
        Get-LockpathUsers -PageIndex 1 -PageSize 100 -Filter @{'Field'= @{'ShortName'='AccountType'}; 'FilterType'='10002'; 'Value'='1|2'}

    .INPUTS
        System.Array System.Uint32

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
        SupportsShouldProcess = $true)]
    [OutputType('System.String')]

    param(
        [ValidateRange('NonNegative')]
        [Int32] $PageIndex = $(Get-LockpathConfiguration -Name 'pageIndex'),

        [ValidateRange('Positive')]
        [Int32] $PageSize = $(Get-LockpathConfiguration -Name 'pageSize'),

        [Array] $Filters = @()
    )

    Write-LockpathInvocationLog -Confirm:$false -WhatIf:$false

    $Body = @{
        'pageIndex' = $PageIndex
        'pageSize'  = $PageSize
    }

    If ($Filters.Count -gt 0) {
        $Body.Add('filters', $Filters)
    }

    $params = @{
        'UriFragment' = 'SecurityService/GetUsers'
        'Method'      = 'POST'
        'Description' = "Getting users with filter: $($Filters | ConvertTo-Json -Depth $script:configuration.jsonConversionDepth -Compress)"
        'Body'        = $Body | ConvertTo-Json -Depth $script:configuration.jsonConversionDepth -Compress
    }

    if ($PSCmdlet.ShouldProcess("Getting users with body: $([environment]::NewLine) $($params.Body)", $($params.Body), 'Getting users with body:')) {
        [String] $result = Invoke-LockpathRestMethod @params -Confirm:$false
        return $result
    } else {
        Write-LockpathLog -Message "$($PSCmdlet.CommandRuntime.ToString()) ShouldProcess confirmation was denied." -Level Verbose -Confirm:$false -WhatIf:$false
    }
}
