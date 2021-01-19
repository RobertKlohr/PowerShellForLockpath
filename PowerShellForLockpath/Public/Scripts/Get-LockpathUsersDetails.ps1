function Get-LockpathUsersDetails {
    <#
    .SYNOPSIS
        Returns all user details for selected users based on the applied filter.

    .DESCRIPTION
        Returns all user details for selected users based on the applied filter.

        Combines Get-LockpathUsers and Get-LockpathUser and uses the same filter as Get-LockpathUsers.

        The Git repo for this module can be found here: https://git.io/powershellforlockpath

    .EXAMPLE
        Get-LockpathUsersDetails

    .EXAMPLE
        Get-LockpathUsersDetails -PageIndex 0 -PageSize 100

    .EXAMPLE
        Get-LockpathUsersDetails -Filter @{'Field'= @{'ShortName'='AccountType'}; 'FilterType'='10002'; 'Value'='1|2'}

    .EXAMPLE
        Get-LockpathUsersDetails -PageIndex 1 -PageSize 100 -Filter @{'Field'= @{'ShortName'='AccountType'}; 'FilterType'='10002'; 'Value'='1|2'}

    .INPUTS
        System.Array System.UInt32

    .OUTPUTS
        String

    .NOTES
        The authentication account must have Read Administrative Access permissions to administer users.

    .LINK
        https://git.io/powershellforlockpathhelp
    #>

    [CmdletBinding(
        ConfirmImpact = 'Low',
        PositionalBinding = $false,
        SupportsShouldProcess = $true)]
    [OutputType('System.String')]

    param(
        # FIXME decide if there will be parameters on this call and how they will work
        # [Parameter(
        #     Mandatory = $true,
        #     ParameterSetName = 'All')]
        # [Switch] $All,

        # [Parameter(
        #     Mandatory = $true,
        #     ParameterSetName = 'Filter')]
        # [Array] $Filter,

        # [Parameter(
        #     Mandatory = $false)]
        # [Int32] $PageIndex = $Script:LockpathConfig.pageIndex,

        # [Parameter(
        #     Mandatory = $false)]
        # [Int32] $PageSize = $Script:LockpathConfig.pageSize
    )

    $level = 'Information'
    $functionName = ($PSCmdlet.CommandRuntime.ToString())
    $service = 'SecurityService'

    if ($Script:LockpathConfig.loggingLevel -eq 'Debug') {
        Write-LockpathInvocationLog -Confirm:$false -WhatIf:$false -FunctionName $functionName -Level $level -Service $service
    }

    if ($PSCmdlet.ShouldProcess("Getting users with body:  $($restParameters.Body)", $($restParameters.Body), 'Getting groups with body:')) {

        # TODO not sure where to test for valid session yet
        # Test-LockpathAuthentication

        # Get-LockpathUsers -All will return vendor contacts without login account that we filter out
        $users = Get-LockpathUsers -All | ConvertFrom-Json -Depth $Script:LockpathConfig.jsonConversionDepth -AsHashtable | Where-Object -Property AccountType -NE $null

        # TODO add paramters and logic to filter users after we get all users above

        $userProgress = $users.count
        $result = @()
        $i = 1
        foreach ($user In $users) {
            try {
                $userDetails = Get-LockpathUser -UserId $user.Id | ConvertFrom-Json -Depth $Script:LockpathConfig.jsonConversionDepth -AsHashtable
                $result += $userDetails
            } catch {
                Write-LockpathLog -Confirm:$false -WhatIf:$false -Message "There was a problem retriving details user Id: $($user.Id)." -Level $level -ErrorRecord $ev[0] -Service $service
            }
            Write-Progress -Id 0 -Activity "Get details for $userProgress users:" -CurrentOperation "Getting details for user: $i $($user.Fullname)" -PercentComplete ($i / $userProgress * 100)
            $i += 1
        }
        return $result
    } else {
        Write-LockpathLog -Confirm:$false -WhatIf:$false -Message 'ShouldProcess confirmation was denied.' -FunctionName $functionName -Level $level -Service $service
    }
}
