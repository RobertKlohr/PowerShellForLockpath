function New-LockpathUser {
    <#
    .SYNOPSIS
        Creates a user account.

    .DESCRIPTION
        Creates a user account.

        The following attributes are required when creating an user account:

        AccountType
        EmailAddress
        FirstName
        LastName
        Password
        SecurityConfiguration
        SecurityRoles
        Username

        The password set must meet the criteria of the settings in the selected SecurityConfiguration.

        The Git repo for this module can be found here: https://github.com/RobertKlohr/PowerShellForLockpath

    .PARAMETER Attributes
        The list of fields and values to change as an array.

    .EXAMPLE
        New-LockpathUser -Attributes @{'AccountType' = '1'; 'EmailAddress' = 'test@test.local'; 'FirstName' = 'test-api-fist'; 'LastName' = 'test-api-last'; 'Password' = 't3st-AP!-password'; 'Username' = 'test-api-username'; 'SecurityConfiguration' = @{'Id' = '1'}; 'SecurityRoles' = @(@{'Id' = '2'},@{'Id' = '5'})}

    .INPUTS
        System.Array

    .OUTPUTS
        String

    .NOTES
        Native API Request: https://[InstanceName]:[InstancePort]/SecurityService/CreateUser

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
        $params = @{
            'UriFragment' = 'SecurityService/CreateUser'
            'Method'      = 'POST'
            'Description' = "Creating user with attributes $($Attributes | ConvertTo-Json -Depth $Script:LockpathConfig.jsonConversionDepth -Compress)"
            'Body'        = $Attributes | ConvertTo-Json -Depth $Script:LockpathConfig.jsonConversionDepth
        }

        if ($PSCmdlet.ShouldProcess("Creating user with attributes: $([environment]::NewLine) $($params.Body)", "$($params.Body)", 'Creating user with attributes:')) {
            [String] $result = Invoke-LockpathRestMethod @params -Confirm:$false
            return $result
        } else {
            Write-LockpathLog -Message "$($PSCmdlet.CommandRuntime.ToString()) ShouldProcess confirmation was denied." -Level Verbose -Confirm:$false -WhatIf:$false
        }
    }

    end {
    }
}
