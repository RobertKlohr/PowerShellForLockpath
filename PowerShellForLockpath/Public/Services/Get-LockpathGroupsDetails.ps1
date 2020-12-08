function Get-LockpathGroupsDetails {
    <#
    .SYNOPSIS
        Returns all group details for selected groups based on the applied filter.

    .DESCRIPTION
        Returns all group details for selected groups based on the applied filter.

        Combines Get-LockpathGroupsDetails and Get-LockpathGroup and uses the same filter as Get-LockpathGroups.

        The Git repo for this module can be found here: https://github.com/RobertKlohr/PowerShellForLockpath

    .PARAMETER PageIndex
        The index of the page of result to return.

        If not set it defaults to the value set in the configuration.

    .PARAMETER PageSize
        The size of the page results to return.

        If not set it defaults to the value set in the configuration.

    .PARAMETER Filter
        The filter parameters that a group must meet to be included in the result.

        Remove the filter to return a list of all groups.

    .EXAMPLE
        Get-LockpathGroupsDetails

    .EXAMPLE
        Get-LockpathGroupsDetails -PageIndex 0 -PageSize 100

    .EXAMPLE
        Get-LockpathGroupsDetails -Filter @{'Field'= @{'ShortName'='BusinessUnit'}; 'FilterType'='5'; 'Value'='False'}

    .EXAMPLE
        Get-LockpathGroupsDetails -PageIndex 0 -PageSize 100 -Filter @{'Field'= @{'ShortName'='BusinessUnit'}; FilterType'='5'; 'Value'='False'}

    .INPUTS
        System.Array, System.UInt32

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
        [Int32] $PageIndex = $Script:LockpathConfig.pageIndex,

        [ValidateRange('Positive')]
        [Int32] $PageSize = $Script:LockpathConfig.pageSize,

        [Array] $Filter = @()
    )

    Write-LockpathInvocationLog -Service ComponentService

    $Body = @{
        'pageIndex' = $PageIndex
        'pageSize'  = $PageSize
    }

    If ($Filter.Count -gt 0) {
        $Body.Add('filters', $Filter)
    }

    $params = @{
        'UriFragment' = 'SecurityService/GetGroups'
        'Method'      = 'POST'
        'Description' = "Getting groups with filter: $($Filter | ConvertTo-Json -Depth $Script:LockpathConfig.jsonConversionDepth -Compress)"
        'Body'        = $Body | ConvertTo-Json -Depth $Script:LockpathConfig.jsonConversionDepth -Compress
    }

    if ($PSCmdlet.ShouldProcess("Getting groups with body: $([environment]::NewLine) $($params.Body)", $($params.Body), 'Getting groups with body:')) {
        $groups = Invoke-LockpathRestMethod @params -Confirm:$false | ConvertFrom-Json -Depth $Script:LockpathConfig.jsonConversionDepth -AsHashtable
        $groupsProgress = $groups.count
        # Array
        # $result = @()
        $result = @{}
        $i = 1
        foreach ($group In $groups) {
            try {
                $groupDetails = Get-LockpathGroup -GroupId $group.Id | ConvertFrom-Json -Depth $Script:LockpathConfig.jsonConversionDepth -AsHashtable
                $result.Add($i, $groupDetails)
                # Array
                # $result += $userDetails
            } catch {
                Write-LockpathLog -Message "There was a problem retriving details group Id: $($group.Id)." -Level Warning -ErrorRecord $ev[0] -Service ComponentService
            }
            Write-Progress -Id 0 -Activity "Get details for $groupsProgress groups:" -CurrentOperation "Getting details for group: $i $($group.Name)" -PercentComplete ($i / $groupsProgress * 100)
            $i += 1
        }
        return $result
    } else {
        Write-LockpathLog -Message "$($PSCmdlet.CommandRuntime.ToString()) ShouldProcess confirmation was denied." -Level Verbose -Service ComponentService
    }
}
