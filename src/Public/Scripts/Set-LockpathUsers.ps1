# Copyright (c) Robert Klohr. All rights reserved.
# Licensed under the MIT License.

function Set-LockpathUsers {
    # FIXME Need to configure parameters and filtering
    # FIXME Check and update all help sections
    # FIXME check and update all parameter sections
    <#
    .SYNOPSIS
        Bulk update user accounts.

    .DESCRIPTION
        Bulk update user accounts.

        All attributes that are updated are overwritten with the new value.

        The Git repo for this module can be found here: https://git.io/powershellforlockpath

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
        https://git.io/powershellforlockpathhelp
    #>

    [CmdletBinding(
        ConfirmImpact = 'High',
        PositionalBinding = $false,
        SupportsShouldProcess = $true
    )]

    [OutputType([System.String])]

    param(
        [Parameter(
            Mandatory = $true
        )]
        #TODO set validate list
        [String] $UpdateField,

        [Parameter(
            Mandatory = $true
        )]
        [String] $UpdateValue,

        [Parameter(
            ParameterSetName = 'Default',
            Mandatory = $false
        )]
        [Array] $Filter = @()
    )

    $level = 'Information'
    $functionName = ($PSCmdlet.CommandRuntime.ToString())
    $service = 'SecurityService'

    Write-LockpathInvocationLog -Confirm:$false -WhatIf:$false -FunctionName $functionName -Level $level -Service $service

    if ($PSCmdlet.ShouldProcess("Updating users with:  $($restParameters.Body)", $($restParameters.Body), 'Updating users with:')) {

        [string] $userCount = Get-LockpathUserCount
        #FIXME The ConvertFrom-Json is throwing an error
        # ConvertFrom-Json: C:\Users\r634204\Documents\GitHub\PowerShellForLockpath\src\Public\Scripts\Set-LockpathUsers.ps1:80:88

        [string] $returned = Get-LockpathUsers -Filter $Filter -PageIndex 0 -PageSize $userCount
        $users = ConvertFrom-Json -InputObject $returned -Depth $Script:LockpathConfig.conversionDepth #-AsHashtable

        $usersProgress = $users.count
        $i = 1

        foreach ($user In $users) {
            try {
                $ProgressPreference = 'SilentlyContinue'
                # Set-LockpathUser -Attributes @{'Id' = "$($user.Id)"; $UpdateField = $UpdateValue }
                # -Confirm:$false -WhatIf:$false
                # if ($UpdateValue -eq $true) {
                #     [int] $UpdateValue = 0
                # } else {
                #     [int] $UpdateValue = 0
                # }

                $parameters = @{
                    Id           = $user.Id
                    $UpdateField = $UpdateValue
                    Confirm      = $false
                    WhatIf       = $false
                }
                # Set-LockpathUser -Id $user.Id -$UpdateField $UpdateValue -Confirm:$false
                # -WhatIf:$false
                if ($user.Id -gt 14) {
                    $null = Set-LockpathUser @parameters
                }
                $ProgressPreference = 'Continue'
            } catch {
                Write-LockpathLog -Confirm:$false -WhatIf:$false -Message "There was a problem updating $($user.Fullname) with user Id: $($user.Id)." -Level $level -ErrorRecord $ev[0] -Service $service
            }
            Write-Progress -Id 0 -Activity "Updating $usersProgress users:" -CurrentOperation "Updating user: $i $($user.Fullname)" -PercentComplete ($i / $usersProgress * 100)
            $i += 1
        }
    } else {
        Write-LockpathLog -Confirm:$false -WhatIf:$false -Message 'ShouldProcess confirmation was denied.' -FunctionName $functionName -Level $level -Service $service
    }
}
