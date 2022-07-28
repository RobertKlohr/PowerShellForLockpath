# Copyright (c) Robert Klohr. All rights reserved.
# Licensed under the MIT License.

function Get-LockpathUsersDetail {
    <#
    .SYNOPSIS
        Returns all user details for selected users based on the applied filter.

    .DESCRIPTION
        Returns all user details for selected users based on the applied filter.

        Combines Get-LockpathUsers and Get-LockpathUser and uses the same filter as Get-LockpathUsers.

        The Git repo for this module can be found here: https://git.io/powershellforlockpath

    .EXAMPLE
        Get-LockpathUsersDetails

    .EXAMPLE
        Get-LockpathUsersDetails -PageIndex 0 -PageSize 100

    .EXAMPLE
        Get-LockpathUsersDetails -Filter @{'Field'= @{'ShortName'='AccountType'}; 'FilterType'='10002'; 'Value'='1|2'}

    .EXAMPLE
        Get-LockpathUsersDetails -PageIndex 1 -PageSize 100 -Filter @{'Field'= @{'ShortName'='AccountType'}; 'FilterType'='10002'; 'Value'='1|2'}

    .INPUTS
        System.Array System.UInt32

    .OUTPUTS
        String

    .NOTES
        The authentication account must have Read Administrative Access permissions to administer users.

    .LINK
        https://git.io/powershellforlockpathhelp
    #>

    [CmdletBinding(
        ConfirmImpact = 'Low',
        PositionalBinding = $false,
        SupportsShouldProcess = $true
    )]

    [OutputType([System.String])]

    param(
        [Parameter(
            ParameterSetName = 'All',
            Mandatory = $false
        )]
        [Switch] $All,

        [Parameter(
            ParameterSetName = 'Default',
            Mandatory = $false
        )]
        [ValidateRange('NonNegative')]
        [UInt32] $PageIndex = $Script:LockpathConfig.pageIndex,

        [Parameter(
            ParameterSetName = 'Default',
            Mandatory = $false
        )]
        [ValidateRange('Positive')]
        [UInt32] $PageSize = $Script:LockpathConfig.pageSize,

        [Parameter(
            ParameterSetName = 'Default',
            Mandatory = $false
        )]
        [Array] $Filter = @()
    )

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

    Write-LockpathInvocationLog @logParameters

    if ($PSCmdlet.ShouldProcess("Getting users with body:  $($restParameters.Body)", $($restParameters.Body), 'Getting groups with body:')) {

        if ($All) {
            $users = Get-LockpathUsers -All | ConvertFrom-Json -Depth $Script:LockpathConfig.conversionDepth -AsHashtable | Where-Object -Property AccountType -NE $null
        } else {
            $users = Get-LockpathUsers -PageIndex $PageIndex -PageSize $PageSize -Filter @Filter | ConvertFrom-Json -Depth $Script:LockpathConfig.conversionDepth -AsHashtable | Where-Object -Property AccountType -NE $null
        }
        $userProgress = $users.count
        $result = @()
        $i = 0
        Clear-Host
        foreach ($user In $users) {
            try {
                $userDetails = Get-LockpathUser -UserId $user.Id | ConvertFrom-Json -Depth $Script:LockpathConfig.conversionDepth
                $result += $userDetails
            } catch {
                Write-LockpathLog -Confirm:$false -WhatIf:$false -Message "There was a problem retriving details user Id: $($user.Id)." -Level $level -ErrorRecord $ev[0] -Service $service
            }
            Write-Progress -Id 0 -Activity "Get details for $userProgress users:" -Status "Getting details for user: $i $($user.Fullname)" -PercentComplete ($i / $userProgress * 100)
            $i += 1
        }
        return $result
    } else {
        Write-LockpathLog -Confirm:$false -WhatIf:$false -Message 'ShouldProcess confirmation was denied.' -FunctionName $functionName -Level $level -Service $service
    }
}
