# requires PowerShellForLockpath module to be loaded and a current API session
# use Connect-Lockpath to create an API session

function RemoveInactiveUsersFromEmployeesGroup {

    # get the current membership of the Employees group
    $employeeGroup = Get-LockpathGroup -GroupId 41 | ConvertFrom-Json -AsHashtable

    # get list of inactive users
    $inactiveUsers = Get-LockpathUsers -PageIndex 0 -PageSize 10000 -Filter @(@{'Field' = @{'ShortName' = 'Active' }; 'FilterType' = '5'; 'Value' = 'false' }) | ConvertFrom-Json -AsHashtable

    # keep track of the emploees that will be removed
    $employeesToRemove = @()

    foreach ($member in $employeeGroup.Users) {
        foreach ($user in $inactiveUsers) {
            if ($member.Id -eq $user.Id) {
                $employeesToRemove += $member.Id
                # Group 97 is "#No Access"
                $null = Set-LockpathUser -Id $member.Id -Groups 97 -Confirm:$false
            }
        }
    }

    "Removed the following $($employeesToRemove.Count) inactive employees from the Employees group."
    $employeesToRemove
}
