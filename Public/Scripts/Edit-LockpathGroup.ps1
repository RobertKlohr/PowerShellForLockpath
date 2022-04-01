# Copyright (c) Robert Klohr. All rights reserved.
# Licensed under the MIT License.

function Edit-LockpathGroup {
    <#
    .SYNOPSIS
        Edits a group.

    .DESCRIPTION
        Bulk edits a group membership based on the parameters.

        The Git repo for this module can be found here: https://git.io/powershellforlockpath

    .PARAMETER GroupId
        Specifies the Id number of the group.

    .PARAMETER Action
        Action to preform on the group.

    .PARAMETER UserFilter
        A filter used to return only the users meeting the selected criteria.

    .PARAMETER UserId
        Specifies the Id number of the user.

    .EXAMPLE
        Edit-LockpathGroup -GroupId 41 -Action Remove -UserId (6,10,11,12,13)

        Removes the users with Ids 6, 10, 11, 12, and 13 from the group with Id 41.

    .EXAMPLE
        Edit-LockpathGroup -GroupId 41 -Action Remove -UserFilter  @(@{'Field' = @{'ShortName' = 'Active' }; 'FilterType' = '5'; 'Value' = 'false' })

        Removes inactive users from the group with Id 41.

    .INPUTS
        System.Array System.UInt32

    .OUTPUTS
        String

    .NOTES
        The authentication account must have Read and Update Administrative Access permissions to administer users.

    .LINK
        https://git.io/powershellforlockpathhelp
    #>

    [CmdletBinding(
        ConfirmImpact = 'Medium',
        PositionalBinding = $false,
        SupportsShouldProcess = $true,
        DefaultParameterSetName = 'Default'
    )]

    [OutputType([System.String])]

    param(
        [Parameter(
            Mandatory = $true
        )]
        [ValidateRange('NonNegative')]
        [UInt32] $GroupId,

        # TODO combine with Add-LockpathGroupUser and expand the Actions
        [Parameter(
            Mandatory = $true
        )]
        [ValidateSet('Replace')]
        [String] $Action,


        [Parameter(
            Mandatory = $false
        )]
        [ValidateRange('NonNegative')]
        [UInt32] $NewGroupId = $GroupId,

        # [Parameter(
        #     ParameterSetName = 'Ids',
        #     Mandatory = $true
        # )]
        # [ValidateRange('NonNegative')]
        # [Int32[]] $UserIds,

        [Parameter(
            ParameterSetName = 'Filter',
            Mandatory = $false
        )]
        [Array] $UserFilter = @()
    )

    begin {
        $level = 'Information'
        $functionName = ($PSCmdlet.CommandRuntime.ToString())
        $service = 'SecurityService'

        $logParameters = [ordered]@{
            'FunctionName' = $functionName
            'Level'        = $level
            'Message'      = "Executing cmdlet: $functionName"
            'Service'      = $service
            'Result'       = "Executing cmdlet: $functionName"
        }
    }

    process {
        Write-LockpathInvocationLog @logParameters

        $shouldProcessTarget = "$Action users from group Id $GroupId"

        if ($PSCmdlet.ShouldProcess($shouldProcessTarget)) {
            try {
                # capture list of users edited in group
                $editedMembers = @()
                # get group membership and return a hash table
                $groupMembership = Get-LockpathGroup -GroupId $GroupId | ConvertFrom-Json -AsHashtable
                # [string] $result = Invoke-LockpathRestMethod @restParameters
                if ($UserFilter) {
                    # get list of inactive users and return a hash table
                    $filteredUsers = Get-LockpathUsers -PageIndex 0 -PageSize $(Get-LockpathUserCount) -Filter $UserFilter | ConvertFrom-Json -AsHashtable
                }
                foreach ($member in $groupMembership.Users) {
                    foreach ($user in $filteredUsers) {
                        if ($member.Id -eq $user.Id) {
                            $editedMembers += $member.Id
                            if ($Action -eq 'Replace') {
                                $null = Set-LockpathUser -Id $member.Id -Groups $NewGroupId -Confirm:$false
                            }
                        }
                    }
                }
                $result = "Replaced $($editedMembers.Count) users from group Id $GroupId."
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
