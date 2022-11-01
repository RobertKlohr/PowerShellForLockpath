# requires PowerShellForLockpath module to be loaded and a current API session
# use Connect-Lockpath to create an API session

function RemoveInactiveUsersFromAllGroups {
    #TODO configure into an advanced function
    #TODO add parameters for what to skip
    #TODO add parameter for targeting a single group
    #TODO add logging

    # Get the list of groups
    $groups = Get-LockpathGroups | ConvertFrom-Json -AsHashtable

    # get list of active users
    $activeUsers = Get-LockpathUsers -PageIndex 0 -PageSize 10000 -Filter @(@{'Field' = @{'ShortName' = 'Active' }; 'FilterType' = '5'; 'Value' = 'true' }) | ConvertFrom-Json -AsHashtable

    # keep track of the employees that will be removed
    $activeUserIds = @()

    #extract just the user Ids
    foreach ($user in $activeUsers) {
        $activeUserIds += $user.Id
    }

    #extract just the user Ids
    foreach ($group in $groups) {

        # skipping the 'Platform Administrators (Local)' group with ID 108
        if ($group.Id -eq 108) {
            "Skipping '$($group.Name)' group with Id $($group.Id)."
            continue
        }

        # get the current details of the group
        $groupDetail = Get-LockpathGroup -GroupId $group.Id | ConvertFrom-Json -AsHashtable

        # skip business groups, standard groups and empty groups
        if ($groupDetail.BusinessUnit -eq $True -Or $groupDetail.Users.Count -eq 0 -Or $null -eq $groupDetail.LDAPDirectory) {
            "Skipping '$($group.Name)' group with Id $($group.Id) and user count $($groupDetail.Users.Count)."
            continue
        }

        # keep track of the users that will be retained
        $userIdsInGroup = @()

        #extract just the user Ids
        foreach ($user in $groupDetail.Users) {
            $userIdsInGroup += $user.Id
        }

        #get the difference between the two arrays
        $activeUsersToKeep = Compare-Object $userIdsInGroup $activeUserIds -ExcludeDifferent -PassThru

        if ($userIdsInGroup.Count -ne $activeUsersToKeep.Count) {
            #update the employees group with the list of active employees
            $null = Set-LockpathGroup -Id $group.Id -Users $activeUsersToKeep
            "Removed $($userIdsInGroup.Count - $activeUsersToKeep.Count) inactive users from the '$($group.Name)' group with Id $($group.Id)."
        } else {
            "No inactive users in the '$($group.Name)' group with Id $($group.Id)."
        }

    }

    #
    # old code to keep until second test run
    #

    # $inactiveUsers = Get-LockpathUsers -PageIndex 0 -PageSize 10000 -Filter @(@{'Field' = @{'ShortName' = 'Active' }; 'FilterType' = '5'; 'Value' = 'false' }) | ConvertFrom-Json -AsHashtable

    # keep track of the employees that will be removed
    # $employeesToRemove = @()

    # foreach ($member in $groupDetail.Users) {
    #     foreach ($user in $inactiveUsers) {
    #         if ($member.Id -eq $user.Id) {
    #             $employeesToRemove += $member.Id
    #             # Group 97 is "#No Access"
    #             $null = Set-LockpathUser -Id $member.Id -Groups 97 -Confirm:$false
    #         }
    #     }
    # }

}
