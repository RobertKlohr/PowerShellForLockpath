# Copyright (c) Robert Klohr. All rights reserved.
# Licensed under the MIT License.

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

        The Git repo for this module can be found here: https://git.io/powershellforlockpath

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
            Mandatory = $true,
            Position = 0,
            ValueFromPipeline = $true,
            ValueFromPipelineByPropertyName = $true
        )]
        [Array] $Attributes
    )

    begin {
        $level = 'Information'
        $functionName = ($PSCmdlet.CommandRuntime.ToString())
        $service = 'SecurityService'

        $logParameters = [ordered]@{
            'Confirm'      = $false
            'FunctionName' = $functionName
            'Level'        = $level
            'Message'      = "Executing cmdlet: $functionName"
            'Service'      = $service
            'Result'       = "Executing cmdlet: $functionName"
            'WhatIf'       = $false
        }
    }

    process {
        Write-LockpathInvocationLog @logParameters

        $restParameters = [ordered]@{
            'Body'        = $Attributes | ConvertTo-Json -Compress -Depth $Script:LockpathConfig.conversionDepth
            'Description' = 'Creating User'
            'Method'      = 'POST'
            'Service'     = $service
            'UriFragment' = 'CreateUser'
        }

        $shouldProcessTarget = "$($restParameters.Description) with Attributes = $($restParameters.Body)"

        if ($PSCmdlet.ShouldProcess($shouldProcessTarget)) {
            try {
                [string] $result = Invoke-LockpathRestMethod @restParameters
                $logParameters.Message = 'Success: ' + $shouldProcessTarget
                try {
                    $logParameters.Result = (ConvertFrom-Json -InputObject $result) | ConvertTo-Json -Compress
                } catch {
                    $logParameters.Result = 'Unable to convert API response.'
                }
            } catch {
                $logParameters.Level = 'Error'
                $logParameters.Message = 'Failed: ' + $shouldProcessTarget
                $logParameters.Result = $_.Exception.Message
            } finally {
                Write-LockpathLog @logParameters
            }
            return $result
        }
    }

    end {
    }
}
