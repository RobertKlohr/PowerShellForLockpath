function Get-LockpathGroupsDetails {
    <#
    .SYNOPSIS
        Combines Get-LockpathGroupsDetails and Get-LockpathGroup to return all group fields based on the applied filter.

    .DESCRIPTION
        Combines Get-LockpathGroupsDetails and Get-LockpathGroup to return all group fields based on the applied filter.

        The method uses the same filter as Get-LockpathGroups.

        The Git repo for this module can be found here: https://github.com/RobertKlohr/PowerShellForLockpath

    .PARAMETER PageIndex
        The index of the page of result to return. Must be an integer >= 0. If not set it defaults to the value set
        in the configuration.

    .PARAMETER PageSize
        The size of the page results to return. Must be an integer >= 1. If not set it defaults to the value set in
        the configuration.

    .PARAMETER Filters
        The filter parameters the groups must meet to be included. Must be an array. Use filters to return only the
        groups meeting the selected criteria. Remove all filters to return a list of all groups.

    .EXAMPLE
        Get-LockpathGroupsDetails

    .EXAMPLE
        Get-LockpathGroupsDetails -PageIndex 0 -PageSize 100

    .EXAMPLE
        Get-LockpathGroupsDetails -Filter @{'Field'= @{'ShortName'='BusinessUnit'}; 'FilterType'='5'; 'Value'='False'}

    .EXAMPLE
        Get-LockpathGroupsDetails -PageIndex 0 -PageSize 100 -Filter @{'Field'= @{'ShortName'='BusinessUnit'}; FilterType'='5'; 'Value'='False'}

    .INPUTS
        System.Array, System.Uint32

    .OUTPUTS
        String

    .NOTES
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
        [Int64] $PageIndex = $(Get-LockpathConfiguration -Name 'pageIndex'),

        [ValidateRange('Positive')]
        [Int64] $PageSize = $(Get-LockpathConfiguration -Name 'pageSize'),

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
        'Description' = "Getting groups with filter: $($Filters | ConvertTo-Json -Compress)"
        'Body'        = $Body | ConvertTo-Json -Depth 10
    }

    if ($PSCmdlet.ShouldProcess("Getting groups with body: $([environment]::NewLine) $($params.Body)", $($params.Body), 'Getting groups with body:')) {
        $groups = Invoke-LockpathRestMethod @params -Confirm:$false | ConvertFrom-Json -AsHashtable
        $groupsProgress = $groups.count
        # Array
        # $result = @()
        $result = @{}
        $i = 1
        foreach ($group In $groups) {
            try {
                $groupDetails = Get-LockpathGroup -GroupId $group.Id | ConvertFrom-Json -AsHashtable
                $result.Add($i, $groupDetails)
                # Array
                # $result += $userDetails
            } catch {
                Write-LockpathLog -Message "There was a problem retriving details group Id: $($group.Id)." -Level Warning -Exception $ev[0]
            }
            Write-Progress -Id 0 -Activity "Get details for $groupsProgress groups:" -CurrentOperation "Getting details for group: $i $($group.Name)" -PercentComplete ($i / $groupsProgress * 100)
            $i += 1
        }
        return $result
    } else {
        Write-LockpathLog -Message "$($PSCmdlet.CommandRuntime.ToString()) ShouldProcess confirmation was denied." -Level Verbose -Confirm:$false -WhatIf:$false
    }
}
