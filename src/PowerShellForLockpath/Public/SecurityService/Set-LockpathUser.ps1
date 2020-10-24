function Set-LockpathUser {
    <#
    .SYNOPSIS
        Updates a user account.

    .DESCRIPTION
        Updates a user account.  All attributes that are updated are overwritten with the new value.

    .PARAMETER Attributes
        The list of fields and values to change as an array. The list of attributes must include the Id field and
        the user Id as the value for the user being updated. The field names in the array are case sensitive.

    .EXAMPLE
        Set-LockpathUser -Attributes @{'Id' = '6'; 'Manager' = @{'Id'= '10'}}

    .EXAMPLE
        Set-LockpathUser -Attributes @{'Id' = '6'; 'Groups' = @(@{'Id'= '7'}@{'Id'= '8'})}

    .INPUTS
        System.Array

    .OUTPUTS
        System.String

    .NOTES
        The authentication account must have Read and Update Administrative Access permissions to administer users.
        For vendor contacts, the authentication account must also have the Read and Update General Access to Vendor
        Profiles, View and Edit Vendor Profiles workflow stage and Vendor Profiles record permission.

    .LINK
        https://github.com/RobertKlohr/PowerShellForLockpath
    #>

    [CmdletBinding(
        ConfirmImpact = 'High',
        PositionalBinding = $false,
        SupportsShouldProcess = $true)]
    [OutputType('System.String')]

    #TODO get the Id as a separate parameter
    param(
        [Parameter(
            Mandatory = $true,
            Position = 0,
            ValueFromPipeline = $true,
            ValueFromPipelineByPropertyName = $true)]
        [array] $Attributes
    )

    begin {
        Write-LockpathInvocationLog -Confirm:$false -WhatIf:$false
    }

    process {

        $UserId = $Attributes.Id

        $params = @{
            'UriFragment' = "SecurityService/UpdateUser"
            'Method'      = 'POST'
            'Description' = "Updating user with Id: $UserId and values $($Attributes | ConvertTo-Json -Depth 10 -Compress)"
            'Body'        = $Attributes | ConvertTo-Json -Depth 10
        }
        if ($PSCmdlet.ShouldProcess("Updating user with user with Id $($UserId) and settings: $([environment]::NewLine) $($params.Body)", "$($params.Body)", "Updating user with user with Id $($UserId) and settings:")) {
            $result = Invoke-LockpathRestMethod @params -Confirm:$false
            return $result
        } else {
            Write-LockpathLog -Message "$($PSCmdlet.CommandRuntime.ToString()) ShouldProcess confirmation was denied." -Level Verbose -Confirm:$false -WhatIf:$false
        }
    }

    end {
    }
}
