function Get-LockpathUserCount {
    <#
.SYNOPSIS
    Returns a count of users.
.DESCRIPTION
    Returns a count of users. The count does not include Deleted users and can include non-Lockpath user
    accounts, such as Vendor Contacts.
.PARAMETER Filters
    The filter parameters the groups must meet to be included. Must be an array. Use filters to return only the groups meeting the selected criteria. Remove all filters to return a list of all groups.
.EXAMPLE
    Get-LockpathUserCount
.EXAMPLE
    Get-LockpathUserCount -Filter @{'Field'= @{'ShortName'='AccountType'}; 'FilterType'='10002'; 'Value'='1|2'}
.INPUTS
    System.Array.
.OUTPUTS
    System.Int32.
.NOTES
    The authentication account must have Read Administrative Access permissions to administer users.
.LINK
    https://github.com/RobertKlohr/PowerShellForLockpath
#>

    [CmdletBinding(
        ConfirmImpact = 'Low',
        PositionalBinding = $false,
        SupportsShouldProcess = $true)]
    [OutputType('System.Int32')]

    param(
        [Alias("Filter")]
        [array]$Filters
    )

    #TODO Document in examples a filter with two sets of criteria
    # (@{Shortname = "AccountType"; FilterType = 5; Value = 1 }, @{ Shortname = "Deleted"; FilterType = 5; Value =
    # "true" })

    Write-LockpathInvocationLog -Confirm:$false -WhatIf:$false

    $Body = @{
    }

    If ($Filters.Count -gt 0) {
        $Body.Add('filters', $Filters)
    }

    $params = @{
        'UriFragment' = 'SecurityService/GetUserCount'
        'Method'      = 'POST'
        'Description' = "Getting User Count with Filter: $($Filters | ConvertTo-Json -Compress)"
        'Body'        = $Body | ConvertTo-Json -Depth 10
    }

    if ($PSCmdlet.ShouldProcess("Getting user count with body: $([environment]::NewLine) $($params.Body)", $($params.Body), 'Getting user count with body:')) {
        $result = Invoke-LockpathRestMethod @params -Confirm:$false
        return $result
    } else {
        Write-LockpathLog -Message "$($PSCmdlet.CommandRuntime.ToString()) ShouldProcess confirmation was denied." -Level Verbose -Confirm:$false -WhatIf:$false
    }
}
