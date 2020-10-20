function Get-LockpathUsersDetails {
    [CmdletBinding()]
    [OutputType([int])]

    param(
        [array] $Filter = $null,

        [ValidateRange(0, [int]::MaxValue)]
        [int] $PageIndex = $(Get-LockpathConfiguration -Name 'pageIndex'),

        [ValidateRange(1, [int]::MaxValue)]
        [int] $PageSize = $(Get-LockpathConfiguration -Name 'pageSize')
    )

    #TODO add stopwatch to this cmdlet

    # %%%%%%%%%%
    # Hard coded filter for testing
    [array] $Filter = @(
        [ordered]@{
            'Field'      = [ordered]@{
                'ShortName' = 'Active'
            }
            'FilterType' = '5'
            'Value'      = 'true'
        }
        [ordered]@{
            'Field'      = [ordered]@{
                'ShortName' = 'AccountType'
            }
            'FilterType' = '5'
            'Value'      = '1'
        }
    )
    # %%%%%%%%%%

    # [System.Collections.Hashtable]$result = @{}
    $result = @()
    $i = 0
    $users = $(Get-LockpathUsers -PageIndex $PageIndex -PageSize $PageSize -Filter $Filter) | ConvertFrom-Json -Depth 10 -NoEnumerate
    $usersProgress = $users.count
    foreach ($user In $users) {
        try {
            $userDetails = Get-LockpathUser -UserId $user.Id | ConvertFrom-Json # -AsHashtable
            # The next line is needed so the the hashtable key is automatically recognized as a string so dot
            # notation will work when accessing the hashtable
            # $userId = 'Id' + $user.Id
            # $result.Add($userId, $userDetails)
            $result += $userDetails
        } catch {
            # This unnecessary assignment is to avoid PSScriptAnalyzer's PSAvoidUsingEmptyCatchBlock
            $result = $result
        }
        Write-Progress -Id 0 -Activity "Get details for $usersProgress users:" -CurrentOperation "Getting details for user: $i $($user.Fullname)" -PercentComplete ($i / $usersProgress * 100)
        $i += 1
    }

    return $result
}
