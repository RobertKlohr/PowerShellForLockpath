function Get-LockpathUser {
    <#
    .SYNOPSIS
        Retrieves information about the specified user on Lockpath.

    .DESCRIPTION
        Retrieves information about the specified user on Lockpath.
        The Git repo for this module can be found here: https://github.com/RjKGitHub/PowerShellForLockpath

    .PARAMETER All
        If specified, gets all users in the Lockpath system.
        Optional filters can be used to narrow the scope.
        This is the default switch if no paramters passed to the function.

    .PARAMETER Count
        If specified, gets count of user in the Lockpath system.
        Optional filters can be used to narrow the scope.

    .PARAMETER FilterField
        The field to use for filtering.

    .PARAMETER FilterType
        The type of filter to use.

    .PARAMETER FilterValue
        The value of the filter.

    .PARAMETER Id
        If specified, The Id of the user to retrieve information for.

    .PARAMETER PageIndex
        The index of the page of result to return. Must be > 0

    .PARAMETER PageSize
        The size of the page results to return. Must be >= 1

    .EXAMPLE
        Get-LockpathUser -Id 6
        Gets information on just the user with Id '6'

    .EXAMPLE
        Get-LockpathUser
        Gets information on every Lockpath user.

    .EXAMPLE
        Get-LockpathUser -Count
        Gets the count of the number of Lockpath users using the default filter.

    .NOTES
        Author: Robert Klohr
        Version: 0.1
        Copyright (c): Robert Klohr. All rights reserved.
        License: Licensed under the MIT License.
    #>
    [CmdletBinding(
        SupportsShouldProcess,
        DefaultParametersetName = 'None')]
    [Diagnostics.CodeAnalysis.SuppressMessageAttribute("PSShouldProcess", "", Justification = "Methods called within here make use of PSShouldProcess, and the switch is passed on to them inherently.")]
    param(
        [Parameter(ParameterSetName = 'All')]
        [switch] $All,

        [Parameter(ParameterSetName = 'Count')]
        [switch] $Count,

        [Parameter(ParameterSetName = 'All')]
        [Parameter(ParameterSetName = 'Count')]
        # change AccountType to Type for input
        [ValidateSet("Active", "Deleted", "AccountType")]
        [string] $FilterField = 'Active',

        [Parameter(ParameterSetName = 'All')]
        [Parameter(ParameterSetName = 'Count')]
        #Change these to named values
        [ValidateSet("5", "6", "10002")]
        [string] $FilterType = '5',

        [Parameter(ParameterSetName = 'All')]
        [Parameter(ParameterSetName = 'Count')]
        #Change these to named values
        #split this into additional parameter groups to ensure that true/false are used with 5/6 and 1/2/4 are used with 10002
        [ValidateSet("True", "False", "1", "2", "4")]
        [string] $FilterValue = 'True',

        [Parameter(ParameterSetName = 'Id', Mandatory = $true)]
        [string] $Id,

        [Parameter(ParameterSetName = 'All', Mandatory = $true)]
        [int] $PageIndex = 1000,

        [Parameter(ParameterSetName = 'All', Mandatory = $true)]
        [int] $PageSize = 0
    )

    Write-InvocationLog

    $hashBodyPage = @{ }
    $hashBodyPage = @{
        'pageIndex' = $PageIndex
        'pageSize'  = $PageSize
    }

    $hashBodyFilter = @{ }
    if ($PSBoundParameters.ContainsKey('FilterField')) {
        $hashBodyFilter = @{
            'FilterField' = $FilterField
            'FilterType'  = $FilterType
            'FilterValue' = $FilterValue
        }
    }

    $params = @{ }

    if ($All) {
        if (-not $PSBoundParameters.ContainsKey('FilterField')) {
            $body = (ConvertTo-Json -InputObject $hashBodyPage)}
    else {
                $body = (ConvertTo-Json -InputObject $hashBodyPage, $hashBodyFilter)
        }
        $params = @{
            'UriFragment'          = '/SecurityService/GetUserUsers'
            'Method'               = 'Post'
            'Body'                 = $body
            'Description'          = "Getting all users"
            'AuthenticationCookie' = $AuthenticationCookie
        }
    } elseif ($Count) {
        if (-not $PSBoundParameters.ContainsKey('FilterField')) {
            $body = '{}'
            else {
                $body = (ConvertTo-Json -InputObject $hashBodyFilter)
            }
        }
        $params = @{
            'UriFragment'          = '/SecurityService/GetUserCount'
            'Method'               = 'Post'
            'Body'                 = $body
            'Description'          = "Getting user count"
            'AuthenticationCookie' = $AuthenticationCookie
        }
    } else {
        $params = @{
            'UriFragment'          = "/SecurityService/GetUser?Id=$Id"
            'Method'               = 'Get'
            'Description'          = "Getting user with Id $Id"
            'AuthenticationCookie' = $AuthenticationCookie
        }
    }
    return Invoke-LockpathRestMethod @params
}
