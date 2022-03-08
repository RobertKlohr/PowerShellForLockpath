# Copyright (c) Robert Klohr. All rights reserved.
# Licensed under the MIT License.

function Set-LockpathVendorGroup {
    <#
    .SYNOPSIS
        Adds all vendor contacts to a single group.

    .DESCRIPTION
        Adds all vendor contacts to a single group.

        The Git repo for this module can be found here: https://git.io/powershellforlockpath

    .PARAMETER GroupId
        Specifies the Id number of the group to add the vendor contacts.

        The GroupId parameter cannot be used with the GroupName parameter.

    .PARAMETER GroupName
        Specifies the name of the group to add the vendor contacts.

        The GroupName parameter cannot be used with the GroupId parameter.

    .PARAMETER Active
        Add only active vendor contacts to the group.

        The Active parameter cannot be used with the All or Inactive parameter.

    .PARAMETER All
        Adds both active and inactive vendor contacts to the group.

        The All parameter cannot be used with the Active or Inactive parameter.

    .PARAMETER Inactive
        Add only inactive vendor contacts to the group.

        The Inactive parameter cannot be used with the Active or All parameter.

    .EXAMPLE
        Add-LockpathGroupUser -GroupId 71 -Active

        Set the memberhip of the group with Id 71 to all active vendor contacts.

    .EXAMPLE
        Add-LockpathGroupUser -GroupName 'Vendor Contacts' -All

        Set the memberhip of the group with the name 'Vendor Contacts' to all active and inactive vendor contacts.

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
        SupportsShouldProcess = $true)]
    [OutputType('System.String')]

    param(
        [Parameter(
            Mandatory = $true,
            ValueFromPipeline = $true,
            ValueFromPipelineByPropertyName = $true,
            ParameterSetName = 'Id-Active')]
        [Parameter(
            Mandatory = $true,
            ValueFromPipeline = $true,
            ValueFromPipelineByPropertyName = $true,
            ParameterSetName = 'Id-All')]
        [Parameter(
            Mandatory = $true,
            ValueFromPipeline = $true,
            ValueFromPipelineByPropertyName = $true,
            ParameterSetName = 'Id-Inactive')]
        [ValidateRange('NonNegative')]
        [Int64] $GroupId,

        [Parameter(
            Mandatory = $true,
            ValueFromPipeline = $true,
            ValueFromPipelineByPropertyName = $true,
            ParameterSetName = 'Group-Active')]
        [Parameter(
            Mandatory = $true,
            ValueFromPipeline = $true,
            ValueFromPipelineByPropertyName = $true,
            ParameterSetName = 'Group-All')]

        [Parameter(
            Mandatory = $true,
            ValueFromPipeline = $true,
            ValueFromPipelineByPropertyName = $true,
            ParameterSetName = 'Group-Inactive')]
        [String] $GroupName,

        [Parameter(
            Mandatory = $true,
            ValueFromPipeline = $true,
            ValueFromPipelineByPropertyName = $true,
            ParameterSetName = 'Id-Active')]
        [Parameter(
            Mandatory = $true,
            ValueFromPipeline = $true,
            ValueFromPipelineByPropertyName = $true,
            ParameterSetName = 'Group-Active')]
        [Switch] $Active,

        [Parameter(
            Mandatory = $true,
            ValueFromPipeline = $true,
            ValueFromPipelineByPropertyName = $true,
            ParameterSetName = 'Id-All')]
        [Parameter(
            Mandatory = $true,
            ValueFromPipeline = $true,
            ValueFromPipelineByPropertyName = $true,
            ParameterSetName = 'Group-All')]
        [Switch] $All,

        [Parameter(
            Mandatory = $true,
            ValueFromPipeline = $true,
            ValueFromPipelineByPropertyName = $true,
            ParameterSetName = 'Id-Inactive')]
        [Parameter(
            Mandatory = $true,
            ValueFromPipeline = $true,
            ValueFromPipelineByPropertyName = $true,
            ParameterSetName = 'Group-Inactive')]
        [Switch] $Inactive
    )

    begin {
        $level = 'Information'
        $functionName = ($PSCmdlet.CommandRuntime.ToString())
        $service = 'SecurityService'
        [int32] $pagesize = Get-LockpathUserCount
    }

    process {
        if ($Script:LockpathConfig.loggingLevel -eq 'Debug') {
            Write-LockpathInvocationLog -Confirm:$false -WhatIf:$false -FunctionName $functionName -Level $level -Service $service
        }

        $vendorIds = @()

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
                if ($GroupName) {
                    $GroupId = Get-LockpathGroups | ConvertFrom-Json | Where-Object Name -EQ $GroupName | Select-Object -ExpandProperty Id
                }
                if ($Active) {
                    $vendors = Get-LockpathUsers -PageSize $pagesize -Filter @(@{'Field' = @{'ShortName' = 'AccountType' }; 'FilterType' = '5'; 'Value' = '2' }, @{'Field' = @{'ShortName' = 'Active' }; 'FilterType' = '5'; 'Value' = 'true' })
                } elseif ($All) {
                    $vendors = Get-LockpathUsers -PageSize $pagesize -Filter @{'Field' = @{'ShortName' = 'AccountType' }; 'FilterType' = '5'; 'Value' = '2' } | ConvertFrom-Json -Depth 10 -AsHashtable
                } else {
                    $vendors = Get-LockpathUsers -PageSize $pagesize -Filter @(@{'Field' = @{'ShortName' = 'AccountType' }; 'FilterType' = '5'; 'Value' = '2' }, @{'Field' = @{'ShortName' = 'Active' }; 'FilterType' = '5'; 'Value' = 'false' })
                }
                foreach ($vendor in $vendors) {
                    $vendorIds += $vendor.Id
                }
                Set-LockpathGroup -GroupId $GroupId -Users $vendorIds
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
