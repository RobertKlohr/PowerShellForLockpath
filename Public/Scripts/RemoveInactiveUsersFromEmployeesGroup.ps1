# requires PowerShellForLockpath module to be loaded and a current API session
# use Connect-Lockpath to create an API session

function RemoveInactiveUsersFromEmployeesGroup {

    # keep track of the employees that will be retained
    $employeesInGroup = @()

    # get the current membership of the Employees group
    $employeeGroup = Get-LockpathGroup -GroupId 41 | ConvertFrom-Json -AsHashtable

    #extract just the user Ids
    foreach ($employee in $employeeGroup.Users) {
        $employeesInGroup += $employee.Id
    }

    # keep track of the employees that will be removed
    $employeesToKeep = @()

    # get list of active users
    $activeUsers = Get-LockpathUsers -PageIndex 0 -PageSize 10000 -Filter @(@{'Field' = @{'ShortName' = 'Active' }; 'FilterType' = '5'; 'Value' = 'true' }) | ConvertFrom-Json -AsHashtable

    #extract just the user Ids
    foreach ($user in $activeUsers) {
        $employeesToKeep += $user.Id
    }

    #get the difference between the two arrays
    $activeEmployees = Compare-Object $employeesInGroup $employeesToKeep -ExcludeDifferent -PassThru

    #update the employees group with the list of active employees
    Set-LockpathGroup -Id 41 -Users $activeEmployees

    "Removed $($employeesInGroup.Count - $activeEmployees.Count) inactive employees from the Employees group."

    #
    # old code to keep until second test run
    #

    # $inactiveUsers = Get-LockpathUsers -PageIndex 0 -PageSize 10000 -Filter @(@{'Field' = @{'ShortName' = 'Active' }; 'FilterType' = '5'; 'Value' = 'false' }) | ConvertFrom-Json -AsHashtable

    # keep track of the employees that will be removed
    # $employeesToRemove = @()

    # foreach ($member in $employeeGroup.Users) {
    #     foreach ($user in $inactiveUsers) {
    #         if ($member.Id -eq $user.Id) {
    #             $employeesToRemove += $member.Id
    #             # Group 97 is "#No Access"
    #             $null = Set-LockpathUser -Id $member.Id -Groups 97 -Confirm:$false
    #         }
    #     }
    # }

}
