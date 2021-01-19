function Get-LockpathGroupsDetails {
    <#
    .SYNOPSIS
        Returns all group details for selected groups based on the applied filter.

    .DESCRIPTION
        Returns all group details for selected groups based on the applied filter.

        Combines Get-LockpathGroupsDetails and Get-LockpathGroup and uses the same filter as Get-LockpathGroups.

        The Git repo for this module can be found here: https://git.io/powershellforlockpath

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
        https://git.io/powershellforlockpathhelp
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

    $level = 'Information'
    $functionName = ($PSCmdlet.CommandRuntime.ToString())
    $service = 'SecurityService'

    if ($Script:LockpathConfig.loggingLevel -eq 'Debug') {
        Write-LockpathInvocationLog -Confirm:$false -WhatIf:$false -FunctionName $functionName -Level $level -Service $service
    }

    $Body = [ordered]@{
        'pageIndex' = $PageIndex
        'pageSize'  = $PageSize
    }

    If ($Filter.Count -gt 0) {
        $Body.Add('filters', $Filter)
    }

    $restParameters = [ordered]@{
        'UriFragment' = 'SecurityService/GetGroups'
        'Method'      = 'POST'
        'Description' = "Getting groups with filter: $($Filter | ConvertTo-Json -Depth $Script:LockpathConfig.jsonConversionDepth -Compress)"
        'Body'        = $Body | ConvertTo-Json -Depth $Script:LockpathConfig.jsonConversionDepth -Compress
    }

    if ($PSCmdlet.ShouldProcess("Getting groups with body:  $($restParameters.Body)", $($restParameters.Body), 'Getting groups with body:')) {
        $groups = Invoke-LockpathRestMethod @restParameters -Confirm:$false | ConvertFrom-Json -Depth $Script:LockpathConfig.jsonConversionDepth -AsHashtable
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
                Write-LockpathLog -Confirm:$false -WhatIf:$false -Message "There was a problem retriving details group Id: $($group.Id)." -Level $level -ErrorRecord $ev[0] -Service $service
            }
            Write-Progress -Id 0 -Activity "Get details for $groupsProgress groups:" -CurrentOperation "Getting details for group: $i $($group.Name)" -PercentComplete ($i / $groupsProgress * 100)
            $i += 1
        }
        return $result
    } else {
        Write-LockpathLog -Confirm:$false -WhatIf:$false -Message 'ShouldProcess confirmation was denied.' -FunctionName $functionName -Level $level -Service $service
    }
}
