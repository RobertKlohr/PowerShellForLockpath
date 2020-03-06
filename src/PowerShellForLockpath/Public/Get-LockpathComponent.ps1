function Get-LockpathComponent {
    <#
    .SYNOPSIS
      Retrieves information about the specified Component on Lockpath.

    .DESCRIPTION
      Retrieves information about the specified Component on Lockpath. The Git repo for this module can be found
      here: https://github.com/RjKGitHub/PowerShellForLockpath

    .PARAMETER All
      The Id of the Component to retrieve information for. If not specified, will retrieve information on all
      Lockpath Component (and may take a while to complete).

    .PARAMETER Id
      The Id of the Component to retrieve information for. If not specified, will retrieve information on all
      Lockpath Component (and may take a while to complete).

    .PARAMETER AliAS
      If specified, gets information on the current user.

    .PARAMETER PageIndex
      The index of the page of result to return. Must be > 0

    .PARAMETER PageSize
      The size of the page results to return. Must be >= 1

    .PARAMETER FieldFilter
      The filter parameters the users must meet to be included.  If the filer is not set all users are returned.

    .EXAMPLE
        Get-LockpathComponent -Id 6
        Gets information on the Lockpath Component with Id '6'

    .EXAMPLE
        Get-LockpathComponent
        Gets information on every Lockpath Component.

    .EXAMPLE
        Get-LockpathComponent -Alias 'Test'
        Gets information on the Lockpath Component with the Alias 'Test'.

    .NOTES
      Author: Robert Klohr Version: 0.1 Copyright (c): Robert Klohr. All rights reserved. License: Licensed under
      the MIT License.
    #>

    # TODO: Can I take out the SupportsShouldProcess setting on all the functions that just 'get' and not 'set'
    [CmdletBinding(
        SupportsShouldProcess,
        DefaultParametersetName = 'All')]
    [Diagnostics.CodeAnalysis.SuppressMessageAttribute("PSShouldProcess", "", Justification = "Methods called within here make use of PSShouldProcess, and the switch is passed on to them inherently.")]
    param(
        [Parameter(ParameterSetName = 'All')]
        [switch] $All,

        [Parameter(ParameterSetName = 'Alias', Mandatory = $true)]
        [string] $Alias,

        [Parameter(ParameterSetName = 'Id', Mandatory = $true)]
        [string] $Id,
    )

    Write-InvocationLog

    $params = @{ }

    if ($All) {
        $params = @{
            'UriFragment'          = "/ComponentService/GetComponentList"
            'Method'               = 'Get'
            'Description'          = "Getting all Components"
            'AuthenticationCookie' = $AuthenticationCookie
        }
    } elseif ($Alias) {
        $params = @{
            'UriFragment'          = "/ComponentService/GetComponentByAlias?alias=$Alias"
            'Method'               = 'Get'
            'Description'          = "Getting Component with Alias $Alias"
            'AuthenticationCookie' = $AuthenticationCookie
        }
    } else {
        $params = @{
            'UriFragment'          = "/ComponentService/GetComponent?id=$Id"
            'Method'               = 'Get'
            'Description'          = "Getting Component with Id $Id"
            'AuthenticationCookie' = $AuthenticationCookie
        }
    }
    return Invoke-LockpathRestMethod @params
}
