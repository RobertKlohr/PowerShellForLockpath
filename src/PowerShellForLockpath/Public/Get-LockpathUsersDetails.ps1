#TODO setup for filters
#TODO check parameter sets
#TODO Implement status feedback on job (look at PS-F-GH module, need to add -status parameter to all functions)
function Get-LockpathUsersDetails {
    [CmdletBinding()]
    [OutputType([int])]

    param(
        #TODO is string the correct type or should this be a PSCustomObject type?
        [array] $Filter = @(
            [ordered]@{
                'Field'      = [ordered]@{
                    'ShortName' = 'AccountType'
                }
                'FilterType' = '10002'
                'Value'      = '1|2|4'
            }
        ),

        [ValidateRange(0, [int]::MaxValue)]
        [int] $PageIndex = $(Get-LockpathConfiguration -Name 'pageIndex'),

        [ValidateRange(1, [int]::MaxValue)]
        [int] $PageSize = $(Get-LockpathConfiguration -Name 'pageSize'),

        [switch] $All
    )

    $result = @()
    $users = @()
    if ($All) {
        $PageSize = $(Get-LockpathUserCount) + 1000 #TODO is this really 15 or should we just add 1000?
    }

    $i = 0
    $users = $(Get-LockpathUsers -PageIndex $PageIndex -PageSize $PageSize -Filter $Filter)
    foreach ($user in $users) {
        $i += 1
        if ($i % 100 -eq 0) {
            Send-LockpathPing
        }
        try {
            $userDetails = Get-LockpathUser -UserId $user.id
            $result += $userDetails
        } catch {
            # $PSCmdlet.ThrowTerminatingError($PSItem)
            $result += $user
        }

    }

    return $result
}
