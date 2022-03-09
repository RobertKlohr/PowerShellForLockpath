# Copyright (c) Robert Klohr. All rights reserved.
# Licensed under the MIT License.

function Remove-LockpathUser {
    <#
    .SYNOPSIS
        Deletes a user account.

    .DESCRIPTION
        Deletes a user account. To inactive a user account use Set-LockpathUser. To undelete an account you must
        use the platform interface.

        The Git repo for this module can be found here: https://git.io/powershellforlockpath

    .PARAMETER UserId
        Specifies the Id number of the user.

    .EXAMPLE
        Remove-LockpathUser -UserId 6

    .EXAMPLE
        Remove-LockpathUser 6

    .EXAMPLE
        6 | Remove-LockpathUser

    .EXAMPLE
        6,12,15 | Remove-LockpathUser

    .EXAMPLE
        $userObject | Remove-LockpathUser

        If $userObject has an property called UserId that value is automatically passed as a parameter.

    .INPUTS
        System.UInt32

    .OUTPUTS
        String

    .NOTES
        Native API Request: https://[InstanceName]:[InstancePort]/SecurityService/DeleteUser

        The authentication account must have Read and Delete Administrative Access permissions to administer users.
        For vendor contacts, the authentication account can alternatively have Read and Delete General Access to
        Vendor Profiles.

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
        [ValidateRange('Positive')]
        [Int32] $UserId
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
            'Body'        = $UserId | ConvertTo-Json -Compress -Depth $Script:LockpathConfig.conversionDepth
            'Description' = "Deleting User with Id $UserId"
            'Method'      = 'DELETE'
            'Service'     = $service
            'UriFragment' = 'DeleteUser'
        }

        $shouldProcessTarget = $restParameters.Description

        if ($PSCmdlet.ShouldProcess($shouldProcessTarget)) {
            try {
                [string] $result = Invoke-LockpathRestMethod @restParameters
                $logParameters.message = 'success: ' + $shouldProcessTarget
                try {
                    $logParameters.result = (ConvertFrom-Json -InputObject $result) | ConvertTo-Json -Compress
                } catch {
                    $logParameters.result = 'Unable to convert API response.'
                }
            } catch {
                $logParameters.Level = 'Error'
                $logParameters.Message = 'failed: ' + $shouldProcessTarget
                $logParameters.result = $_.Exception.Message
            } finally {
                Write-LockpathLog @logParameters
            }
            return $result
        }
    }

    end {
    }
}
