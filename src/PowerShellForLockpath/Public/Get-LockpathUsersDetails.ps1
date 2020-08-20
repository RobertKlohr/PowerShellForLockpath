function Get-LockpathUsersDetails {
    [CmdletBinding()]
    [OutputType([int])]

    param(
        [array] $Filter = @(
            [ordered]@{
                'Field'      = [ordered]@{
                    'ShortName' = 'Active'
                }
                'FilterType' = '5'
                'Value'      = 'false'
            }
        ),

        [ValidateRange(0, [int]::MaxValue)]
        [int] $PageIndex = $(Get-LockpathConfiguration -Name 'pageIndex'),

        [ValidateRange(1, [int]::MaxValue)]
        [int] $PageSize = $(Get-LockpathConfiguration -Name 'pageSize')
    )

    # Filter Syntax an array of hashtables
    # (@{Shortname = "AccountType"; FilterType = 5; Value = 1 }, @{ Shortname = "Deleted"; FilterType = 5; Value = "true" })

    # if (${Filter}) {
    #     $fieldCount = 0
    #     $filterString = '"filters":['
    #     foreach ($filterField in $Filter) {
    #         $fieldCount++
    #         $filterString = $filterString + '{"Field":{"ShortName":"' + $filterField.ShortName + '"},' + '"FilterType":"' + $filterField.FilterType + '",' + '"Value":"' + $filterField.Value + '"}'
    #         if ($fieldCount -ne $Filter.Count) {
    #             $filterString = $filterString + ','
    #         }
    #     }
    #     $filterString = $filterString + "]"
    # }

    $result = @()
    $users = @()
    $userCount = Get-LockpathUserCount -Filter $Filter
    if (-not $PSBoundParameters.ContainsKey('PageSize')) {
        # There is some inconsistency in the results (always low) of the UserCount API call so we are padding the
        # count to ensure that we are capturing all records unless the PageSize is explicitly set.
        $PageSize = $userCount + 100
    }

    $i = 0
    $users = $(Get-LockpathUsers -PageIndex $PageIndex -PageSize $PageSize -Filter $Filter)
    $userProgress = $users.count
    foreach ($user in $users) {
        $i += 1
        if ($i % 100 -eq 0) {
            Send-LockpathPing
        }
        try {
            $userDetails = Get-LockpathUser -UserId $user.id
            $result += $userDetails
        } catch {
            $result += $user
        }
        Write-Progress -Id 0 -Activity "Get details for $userProgress users:" -CurrentOperation "Getting details for user: $i $($user.Fullname)" -PercentComplete ($i / $userProgress * 100)
    }

    return $result
}
