function Get-LockpathUsersDetails {
    <#
    .SYNOPSIS
        Returns all user details for selected users based on the applied filter.

    .DESCRIPTION
        Returns all user details for selected users based on the applied filter.

        Combines Get-LockpathUsers and Get-LockpathUser and uses the same filter as Get-LockpathUsers.

        The Git repo for this module can be found here: https://github.com/RobertKlohr/PowerShellForLockpath

    .PARAMETER PageIndex
        The index of the page of result to return.

        If not set it defaults to the value set in the configuration.

    .PARAMETER PageSize
        The size of the page results to return.

        If not set it defaults to the value set in the configuration.

    .PARAMETER Filters
        The filter parameters the users must meet to be included. Must be an array. Use filters to return only the
        users meeting the selected criteria. Remove all filters to return a list of all users.

    .EXAMPLE
        Get-LockpathUsersDetails

    .EXAMPLE
        Get-LockpathUsersDetails -PageIndex 0 -PageSize 100

    .EXAMPLE
        Get-LockpathUsersDetails -Filter @{'Field'= @{'ShortName'='AccountType'}; 'FilterType'='10002'; 'Value'='1|2'}

    .EXAMPLE
        Get-LockpathUsersDetails -PageIndex 1 -PageSize 100 -Filter @{'Field'= @{'ShortName'='AccountType'}; 'FilterType'='10002'; 'Value'='1|2'}

    .INPUTS
        System.Array System.Uint32

    .OUTPUTS
        String

    .NOTES
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
        'UriFragment' = 'SecurityService/GetUsers'
        'Method'      = 'POST'
        'Description' = "Getting Users with Filter: $($Filters | ConvertTo-Json -Compress)"
        'Body'        = $Body | ConvertTo-Json -Depth 10 -Compress
    }

    if ($PSCmdlet.ShouldProcess("Getting users with body: $([environment]::NewLine) $($params.Body)", $($params.Body), 'Getting groups with body:')) {
        $users = Invoke-LockpathRestMethod @params -Confirm:$false | ConvertFrom-Json -AsHashtable
        $usersProgress = $users.count
        # Array
        # $result = @()
        $result = @{}
        $i = 1
        foreach ($user In $users) {
            try {
                $userDetails = Get-LockpathUser -UserId $user.Id | ConvertFrom-Json -AsHashtable
                $result.Add($i, $userDetails)
                # Array
                # $result += $userDetails
            } catch {
                Write-LockpathLog -Message "There was a problem retriving details user Id: $($user.Id)." -Level Warning -Exception $ev[0]
            }
            Write-Progress -Id 0 -Activity "Get details for $usersProgress users:" -CurrentOperation "Getting details for user: $i $($user.Fullname)" -PercentComplete ($i / $usersProgress * 100)
            $i += 1
        }
        return $result
    } else {
        Write-LockpathLog -Message "$($PSCmdlet.CommandRuntime.ToString()) ShouldProcess confirmation was denied." -Level Verbose -Confirm:$false -WhatIf:$false
    }
}
