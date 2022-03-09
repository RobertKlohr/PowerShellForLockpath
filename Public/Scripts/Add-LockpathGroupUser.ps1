# Copyright (c) Robert Klohr. All rights reserved.
# Licensed under the MIT License.

function Add-LockpathGroupUser {
    <#
    .SYNOPSIS
        Add a user to a group.

    .DESCRIPTION
        Add a user to a group. Existing users in the group remain in the group.

        The Git repo for this module can be found here: https://git.io/powershellforlockpath

    .PARAMETER GroupId
        Specifies the Id number of the group.

    .PARAMETER UserId
        Specifies the Id number of the user.

    .EXAMPLE
        Add-LockpathGroupUser -GroupId 71 -UserId (6,10,11,12,13)

    .INPUTS
        System.Array

    .OUTPUTS
        String

    .NOTES
        Native API Request: https://[InstanceName]:[InstancePort]/SecurityService/UpdateGroup

        The authentication account must have Read and Update Administrative Access permissions to administer groups.

    .LINK
        https://git.io/powershellforlockpathhelp
    #>

    [CmdletBinding(
        ConfirmImpact = 'Medium',
        PositionalBinding = $false,
        SupportsShouldProcess = $true
    )]

    [OutputType([System.String])]

    param(
        [Parameter(
            Mandatory = $true,
            ValueFromPipeline = $true,
            ValueFromPipelineByPropertyName = $true
        )]
        [ValidateRange('NonNegative')]
        [Int32] $GroupId,

        # FIXME add ability to use group name

        [Parameter(
            Mandatory = $true,
            ValueFromPipeline = $true,
            ValueFromPipelineByPropertyName = $true
        )]
        [ValidateRange('NonNegative')]
        [Int32[]] $UserId
    )

    begin {
        $level = 'Information'
        $functionName = ($PSCmdlet.CommandRuntime.ToString())
        $service = 'SecurityService'
        $users = @()
    }

    process {
        if ($Script:LockpathConfig.loggingLevel -eq 'Debug') {
            Write-LockpathInvocationLog -Confirm:$false -WhatIf:$false -FunctionName $functionName -Level $level -Service $service
        }

        $logParameters = [ordered]@{
            'Confirm'      = $false
            'WhatIf'       = $false
            'Message'      = $message
            'FunctionName' = $functionName
            'Level'        = $level
            'Service'      = $service
        }

        $shouldProcessTarget = "Properties=$($restParameters.Body)"

        if ($PSCmdlet.ShouldProcess($shouldProcessTarget)) {
            try {
                $existingUsers = (Get-LockpathGroup -GroupId $GroupId | ConvertFrom-Json -Depth $Script:LockpathConfig.conversionDepth).Users
                foreach ($user in $existingUsers) {
                    $users += $user.Id
                }
                foreach ($Id in $UserId) {
                    $users += $Id
                }
                Set-LockpathGroup -GroupId $GroupId -Users $users
                $logParameters.message = 'success'
            } catch {

                $logParameters.message = 'failed'
                $logParameters.level = 'Warning'
            } finally {
                Write-LockpathLog @logParameters
            }
            return $result
        }
    }

    end {
    }
}
