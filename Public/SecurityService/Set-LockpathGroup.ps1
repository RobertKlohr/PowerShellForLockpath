# Copyright (c) Robert Klohr. All rights reserved.
# Licensed under the MIT License.

function Set-LockpathGroup {
    <#
    .SYNOPSIS
        Updates a group.

    .DESCRIPTION
        Updates a group.  All attributes that are updated are overwritten with the new value.

        The Git repo for this module can be found here: https://git.io/powershellforlockpath

    .PARAMETER Id
        Group Id.

    .PARAMETER BusinessUnit
        Switches group to a business unit. Once this value is set it is not possible to revet the group to a normal
        group without deleting and then recreating the group.

    .PARAMETER ChildGroups
        Array of child group Id values.

    .PARAMETER Description
        Group Description

    .PARAMETER Name
        Group Name

    .PARAMETER ParentGroups
        Array of parent group Id values.

    .PARAMETER Users
        Array of user Id values.

    .EXAMPLE
        Set-LockpathGroup -GroupId 12 -Name 'API Test Group'

        Sets the name of the group with Id 12 to 'API Test Group'

    .EXAMPLE
        Set-LockpathGroup -GroupId 12 -Users (6,10,11,12)

        Sets the membership of the group with Id 12 to the users with Ids 6, 10, 11 and 12.

    .INPUTS
        String, System.Array

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
        SupportsShouldProcess = $true)]
    [OutputType('System.String')]

    param(
        [Parameter(
            Mandatory = $true,
            Position = 0,
            ValueFromPipeline = $true,
            ValueFromPipelineByPropertyName = $true)]
        [Alias('GroupId')]
        [Int64] $Id,

        [Parameter(
            ValueFromPipeline = $true,
            ValueFromPipelineByPropertyName = $true)]
        [Switch] $BusinessUnit,

        [Parameter(
            ValueFromPipeline = $true,
            ValueFromPipelineByPropertyName = $true)]
        [Alias('ChildGroupId', 'ChildGroupIds')]
        [Int64[]] $ChildGroups,

        [Parameter(
            ValueFromPipeline = $true,
            ValueFromPipelineByPropertyName = $true)]
        [String] $Description,

        [Parameter(
            ValueFromPipeline = $true,
            ValueFromPipelineByPropertyName = $true)]
        [String] $Name,

        [Parameter(
            ValueFromPipeline = $true,
            ValueFromPipelineByPropertyName = $true)]
        [Alias('ParentGroupsId', 'ParentGroupsIds')]
        [Int64[]] $ParentGroups,

        [Parameter(
            ValueFromPipeline = $true,
            ValueFromPipelineByPropertyName = $true)]
        [Alias('UserId', 'UserIds')]
        [Int64[]] $Users
    )

    begin {
        $level = 'Information'
        $functionName = ($PSCmdlet.CommandRuntime.ToString())
        $service = 'SecurityService'
    }

    process {
        if ($Script:LockpathConfig.loggingLevel -eq 'Debug') {
            Write-LockpathInvocationLog -Confirm:$false -WhatIf:$false -FunctionName $functionName -Level $level -Service $service
        }

        $Body = [ordered]@{}
        $Ids = @()

        foreach ($parameter in $PSBoundParameters.GetEnumerator()) {
            if ($parameter.Value -is [Switch]) {
                $Body.Add($parameter.Key, $parameter.Value.ToBool().ToString().ToLower())
            } elseif ($parameter.Value -is [Int64[]]) {
                foreach ($value in $parameter.Value) {
                    $Ids += @{'Id' = $value }
                }
                $Body.Add($parameter.Key, $Ids)
            } else {
                $Body.Add($parameter.Key, $parameter.Value)
            }
        }

        $restParameters = [ordered]@{
            'Body'        = $Body | ConvertTo-Json -Depth $Script:LockpathConfig.jsonConversionDepth
            'Description' = 'Updating Group'
            'Method'      = 'POST'
            'Service'     = $service
            'UriFragment' = 'UpdateGroup'
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
                $result = Invoke-LockpathRestMethod @restParameters
                $logParameters.message = 'success'
            } catch {
                $result = $_.ErrorDetails.Message.Split('"')[3]
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
