function Set-LockpathUser {

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
        $level = 'Information'
        $functionName = ($PSCmdlet.CommandRuntime.ToString())
        $service = 'SecurityService'
    }

    process {
        Write-LockpathInvocationLog -Confirm:$false -WhatIf:$false -FunctionName $functionName -Level $level -Service $service

        $params = @{
            'Body'        = $Attributes | ConvertTo-Json -Depth $Script:LockpathConfig.jsonConversionDepth
            'Description' = 'Updating User'
            'Method'      = 'POST'
            'Service'     = $service
            'UriFragment' = 'UpdateUser'
        }

        $target = "Properties=$($params.Body)"

        if ($PSCmdlet.ShouldProcess($target)) {
            try {
                $result = Invoke-LockpathRestMethod @params
                $message = 'success'
            } catch {
                $message = 'failed'
                $level = 'Warning'
            }
            Write-LockpathLog -Confirm:$false -WhatIf:$false -Message $message -FunctionName $functionName -Level $level -Service $service
            If ($message -eq 'failed') {
                return $message
            } else {
                return $result
            }
        }
    }

    end {
    }
}
