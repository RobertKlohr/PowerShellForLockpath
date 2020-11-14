function Set-LockpathUsers {

    #FIXME Need to configure parameters and filtering

    <#
    .SYNOPSIS
        Bulk update user accounts.

    .DESCRIPTION
        Bulk update user accounts.

        All attributes that are updated are overwritten with the new value.

        The Git repo for this module can be found here: https://github.com/RobertKlohr/PowerShellForLockpath

    .PARAMETER Attributes
        The list of fields and values to change as an array.

        The list of attributes must include the Id field and the user Id as the value for the user being updated.

    .EXAMPLE
        Set-LockpathUsers -Attributes @{'Id' = '6'; 'Manager' = @{'Id'= '10'}}

    .EXAMPLE
        Set-LockpathUsers -Attributes @{'Id' = '6'; 'Groups' = @(@{'Id'= '7'}@{'Id'= '8'})}

    .INPUTS
        System.Array

    .OUTPUTS
        String

    .NOTES
        Native API Request: https://[InstanceName]:[InstancePort]/SecurityService/UpdateUser

        The authentication account must have Read and Update Administrative Access permissions to administer users.
        For vendor contacts, the authentication account must also have the Read and Update General Access to Vendor
        Profiles, View and Edit Vendor Profiles workflow stage and Vendor Profiles record permission.

    .LINK
        https://github.com/RobertKlohr/PowerShellForLockpath/wiki
    #>

    [CmdletBinding(
        ConfirmImpact = 'High',
        PositionalBinding = $false,
        SupportsShouldProcess = $true)]
    [OutputType('System.String')]

    param(
        # [Parameter(
        #     Mandatory = $true)]
        # [Array] $Attributes
    )

    Write-LockpathInvocationLog -Confirm:$false -WhatIf:$false

    if ($PSCmdlet.ShouldProcess("Updating users with: $([environment]::NewLine) $($params.Body)", $($params.Body), 'Updating users with:')) {

        $users = Get-LockpathUsers -All | ConvertFrom-Json -Depth $Script:configuration.jsonConversionDepth -AsHashtable
        $usersProgress = $users.count

        foreach ($user In $users) {
            try {
                #FIXME the update is currently hardcoded
                if (!$user.Deleted -and $user.AccountType -eq 1) {
                    $ProgressPreference = 'SilentlyContinue'
                    Set-LockpathUser -Attributes @{'Id' = "$($user.Id)"; 'LDAPDirectory' = @{'Id' = '5' } } -Confirm:$false -WhatIf:$false
                    $ProgressPreference = 'Continue'
                }
            } catch {
                Write-LockpathLog -Message "There was a problem updating $($user.Fullname) with user Id: $($user.Id)." -Level Warning -Exception $ev[0]
            }
            Write-Progress -Id 0 -Activity "Updating $usersProgress users:" -CurrentOperation "Updating user: $i $($user.Fullname)" -PercentComplete ($i / $usersProgress * 100)
            $i += 1
        }
    } else {
        Write-LockpathLog -Message "$($PSCmdlet.CommandRuntime.ToString()) ShouldProcess confirmation was denied." -Level Verbose -Confirm:$false -WhatIf:$false
    }
}
