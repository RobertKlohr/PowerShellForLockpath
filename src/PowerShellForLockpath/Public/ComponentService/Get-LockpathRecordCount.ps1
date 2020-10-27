function Get-LockpathRecordCount {
    <#
    .SYNOPSIS
        Return the number of records in a given component.

    .DESCRIPTION
        Return the number of records in a given component. TFilters may be applied to return the count of records
        meeting a given criteria. This function may be used to help determine the amount of records before
        retrieving the records themselves.

    .PARAMETER ComponentId
        Specifies the Id number of the component as a positive integer.

    .PARAMETER Filters
        The filter parameters the groups must meet to be included. Must be an array. Use filters to return only the
        groups meeting the selected criteria. Remove all filters to return a list of all groups.

    .EXAMPLE
        Get-LockpathRecordCount -ComponentId 3

    .EXAMPLE
        Get-LockpathRecordCount 3

    .EXAMPLE
        Get-LockpathRecordCount -ComponentId 3 -Filter @{'FieldPath'= @(84); 'FilterType'='1'; 'Value'='Test'}

    .INPUTS
        System.Array

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
    [OutputType('System.String')]

    param(
        [Parameter(
            Mandatory = $true,
            Position = 0)]
        [Alias("Id")]
        [ValidateRange("Positive")]
        [uint] $ComponentId,

        [Alias("Filter")]
        [array]$Filters = @()
    )

    Write-LockpathInvocationLog -Confirm:$false -WhatIf:$false

    $Body = @{
        'componentId' = $ComponentId
        'filters'     = $Filters
    }

    $params = @{
        'UriFragment' = 'ComponentService/GetRecordCount'
        'Method'      = 'POST'
        'Description' = "Getting record count with filter: $($Filters | ConvertTo-Json -Compress)"
        'Body'        = $Body | ConvertTo-Json -Depth 10
    }

    if ($PSCmdlet.ShouldProcess("Getting record count for: $([environment]::NewLine) component Id: $ComponentId, record Id: $RecordId & filter $($params.Body)", "component Id: $ComponentId, record Id: $RecordId & filter $($params.Body)", 'Getting record count for:')) {
        [string] $result = Invoke-LockpathRestMethod @params -Confirm:$false
        return $result
    } else {
        Write-LockpathLog -Message "$($PSCmdlet.CommandRuntime.ToString()) ShouldProcess confirmation was denied." -Level Verbose -Confirm:$false -WhatIf:$false
    }
}
