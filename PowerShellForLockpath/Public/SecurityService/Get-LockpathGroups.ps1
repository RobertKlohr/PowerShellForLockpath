function Get-LockpathGroups {
    <#
    .SYNOPSIS
        Returns a list of groups and available fields.

    .DESCRIPTION
        Returns a list of groups and available fields.

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
        Get-LockpathGroups

    .EXAMPLE
        Get-LockpathGroups -PageIndex 0 -PageSize 100

    .EXAMPLE
        Get-LockpathGroups -Filter @{'Field'= @{'ShortName'='BusinessUnit'}; 'FilterType'='5'; 'Value'='False'}

    .EXAMPLE
        Get-LockpathGroups -PageIndex 0 -PageSize 100 -Filter @{'Field'= @{'ShortName'='BusinessUnit'}; FilterType'='5'; 'Value'='False'}

    .INPUTS
        System.Array, System.UInt32

    .OUTPUTS
        String

    .NOTES
        Native API Request: https://[InstanceName]:[InstancePort]/SecurityService/GetGroups

        The authentication account must have Read Administrative Access permissions to administer groups.

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
        [Int32] $PageIndex = $Script:configuration.pageIndex,

        [ValidateRange('Positive')]
        [Int32] $PageSize = $Script:configuration.pageSize,

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
        'UriFragment' = 'SecurityService/GetGroups'
        'Method'      = 'POST'
        'Description' = "Getting groups with filter: $($Filters | ConvertTo-Json -Depth $Script:configuration.jsonConversionDepth -Compress)"
        'Body'        = $Body | ConvertTo-Json -Depth $Script:configuration.jsonConversionDepth
    }

    if ($PSCmdlet.ShouldProcess("Getting groups with body: $([environment]::NewLine) $($params.Body)", $($params.Body), 'Getting groups with body:')) {
        [String] $result = Invoke-LockpathRestMethod @params -Confirm:$false
        return $result
    } else {
        Write-LockpathLog -Message "$($PSCmdlet.CommandRuntime.ToString()) ShouldProcess confirmation was denied." -Level Verbose -Confirm:$false -WhatIf:$false
    }
}
