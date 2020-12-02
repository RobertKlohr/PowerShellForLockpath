﻿function Set-LockpathUser {

    #TODO update parameters to be individual values. This will help with client-side syntax checking
    # EXAMPLE: Set-LockpathUser -Id 6 -EmailAddress 'user@test.com' -Manager 6857 -Department 54

    <#
    .SYNOPSIS
        Updates a user account.

    .DESCRIPTION
        Updates a user account.

        All attributes that are updated are overwritten with the new value.

        The Git repo for this module can be found here: https://github.com/RobertKlohr/PowerShellForLockpath

    .PARAMETER Attributes
        The list of fields and values to change as an array.

        The list of attributes must include the Id field and the user Id as the value for the user being updated.

    .EXAMPLE
        Set-LockpathUser -Attributes @{'Id' = '6'; 'Manager' = @{'Id'= '10'}}

    .EXAMPLE
        Set-LockpathUser -Attributes @{'Id' = '6'; 'Groups' = @(@{'Id'= '7'}@{'Id'= '8'})}

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
        [Parameter(
            Mandatory = $true,
            Position = 0,
            ValueFromPipeline = $true,
            ValueFromPipelineByPropertyName = $true)]
        [Array] $Attributes
    )

    begin {
        Write-LockpathInvocationLog -Confirm:$false -WhatIf:$false
    }

    process {

        $UserId = $Attributes.Id

        $params = @{
            'UriFragment' = 'SecurityService/UpdateUser'
            'Method'      = 'POST'
            'Description' = "Updating user with Id: $UserId and values $($Attributes | ConvertTo-Json -Depth $Script:configuration.jsonConversionDepth -Compress)"
            'Body'        = $Attributes | ConvertTo-Json -Depth $Script:configuration.jsonConversionDepth
        }
        if ($PSCmdlet.ShouldProcess("Updating user with user with Id $($UserId) and settings: $([environment]::NewLine) $($params.Body)", "$($params.Body)", "Updating user with user with Id $($UserId) and settings:")) {
            [String] $result = Invoke-LockpathRestMethod @params -Confirm:$false
            #FIXME supressing the GetUser response; need to figure out what calls return what information
            # TODO maybe suppress by default and with a -switch get the response
            If ($false) {
                return $result
            }
        } else {
            Write-LockpathLog -Message "$($PSCmdlet.CommandRuntime.ToString()) ShouldProcess confirmation was denied." -Level Verbose -Confirm:$false -WhatIf:$false
        }
    }

    end {
    }
}
