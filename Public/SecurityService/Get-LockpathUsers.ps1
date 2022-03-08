# Copyright (c) Robert Klohr. All rights reserved.
# Licensed under the MIT License.

function Get-LockpathUsers {
    <#
    .SYNOPSIS
        Returns a list of users and available fields.

    .DESCRIPTION
        Returns a list of users and available fields. The list does not include Deleted users and can include
        non-Lockpath user accounts. Use a filter to return only the users meeting the selected criteria.

        Remove the filter to return a list of all users including deleted non-Lockpath user accounts.

        The Git repo for this module can be found here: https://git.io/powershellforlockpath

    .PARAMETER All
        Get all users.

        Sets -PageIndex = 0, -PageSize = Get-LockpathUserCount, and $Filter = @()

    .PARAMETER PageIndex
        The index of the page of result to return.

        If not set it defaults to the value set in the configuration.

    .PARAMETER PageSize
        The size of the page results to return.

        If not set it defaults to the value set in the configuration.

    .PARAMETER Filter
        A filter used to return only the users meeting the selected criteria.

    .EXAMPLE
        Get-LockpathUsers

        Returns all users with the -PageIndex and -PageSize defaulting to the values in the module configuration.

    .EXAMPLE
        Get-LockpathUsers -All

        Returns all users by setting -PageIndex = 0, -PageSize = Get-LockpathUserCount, and $Filter = @()

    .EXAMPLE
        Get-LockpathUsers -PageIndex 0 -PageSize 100

        Returns the first 100 users in the system.

    .EXAMPLE
        Get-LockpathUsers -Filter @{'Field'= @{'ShortName'='AccountType'}; 'FilterType'='10002'; 'Value'='1|2'}

        Returns a set of users with the account type of Vendor or Full User with the -PageIndex and -PageSize defaulting to the values in the module configuration.

    .EXAMPLE
        Get-LockpathUsers -PageIndex 1 -PageSize 100 -Filter @(@{'Field'= @{'ShortName'='AccountType'}; 'FilterType'='5'; 'Value'='2'},@{'Field'= @{'ShortName'='Active'}; 'FilterType'='5'; 'Value'='false'})

        Returns the first 100 users with the account type of vendor and status of Inactive.

    .INPUTS
        System.Array System.UInt32

    .OUTPUTS
        String

    .NOTES
        Native API Request: https://[InstanceName]:[InstancePort]/SecurityService/GetUsers

        The authentication account must have Read Administrative Access permissions to administer users.

    .LINK
        https://git.io/powershellforlockpathhelp
    #>

    [CmdletBinding(
        ConfirmImpact = 'Low',
        PositionalBinding = $false,
        SupportsShouldProcess = $true,
        DefaultParameterSetName = 'Default')]
    [OutputType('System.String')]

    [Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSUseSingularNouns', '', Justification = 'This cmdlets is a wrapper for an API call that uses a plural noun.')]

    param(
        [Parameter(
            Mandatory = $false,
            ParameterSetName = 'All')]
        [Switch] $All,

        [Parameter(
            Mandatory = $false,
            ParameterSetName = 'Default')]
        [ValidateRange('NonNegative')]
        [Int32] $PageIndex = $Script:LockpathConfig.pageIndex,

        [Parameter(
            Mandatory = $false,
            ParameterSetName = 'Default')]
        [ValidateRange('Positive')]
        [Int32] $PageSize = $Script:LockpathConfig.pageSize,

        [Parameter(
            Mandatory = $false,
            ParameterSetName = 'Default')]
        [Array] $Filter = @()
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

        if ($All) {
            $PageIndex = 0
            [int32] $PageSize = Get-LockpathUserCount
            $Filter = @()
        }

        $Body = [ordered]@{
            'pageIndex' = $PageIndex
            'pageSize'  = $PageSize
            'filters'   = $Filter
        }

        $restParameters = [ordered]@{
            'Body'        = $Body | ConvertTo-Json -Depth $Script:LockpathConfig.jsonConversionDepth -Compress
            'Description' = 'Getting Users By Filter'
            'Method'      = 'POST'
            'Service'     = $service
            'UriFragment' = 'GetUsers'
        }

        $shouldProcessTarget = "Filter=$($restParameters.Body)"

        if ($PSCmdlet.ShouldProcess($shouldProcessTarget)) {
            try {
                [string] $result = Invoke-LockpathRestMethod @restParameters
                $logParameters.message = 'success: ' + $restParameters.Description + ' with filter ' + $Filter
                if ($Script:LockpathConfig.logRequestBody) {
                    try {
                        $logParameters.result = (ConvertFrom-Json -InputObject $result) | ConvertTo-Json -Compress
                    } catch {
                        $logParameters.result = 'Unable to convert API response.'
                    }
                } else {
                    $logParameters.result = 'Response includes a body: <message body logging disabled>'
                }
            } catch {
                $logParameters.Level = 'Error'
                $logParameters.Message = 'failed: ' + $restParameters.Description + ' with filter ' + $Filter
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
