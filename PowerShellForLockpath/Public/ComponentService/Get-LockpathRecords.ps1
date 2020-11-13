function Get-LockpathRecords {
    <#
    .SYNOPSIS
        Return the title/default field for a set of records within a chosen component.

    .DESCRIPTION
        Return the title/default field for a set of records within a chosen component. Filters may be applied to
        return only the records meeting selected criteria.

        The Git repo for this module can be found here: https://github.com/RobertKlohr/PowerShellForLockpath

    .PARAMETER PageIndex
        The index of the page of result to return.

        If not set it defaults to the value set in the configuration.

    .PARAMETER PageSize
        The size of the page results to return.

        If not set it defaults to the value set in the configuration.

    .PARAMETER ComponentId
        Specifies the Id number of the component.

    .PARAMETER Filters
        The filter parameters the groups must meet to be included. Must be an array. Use filters to return only the
        records meeting the selected criteria. Remove all filters to return a list of all records.

    .EXAMPLE
        Get-LockpathRecords -ComponentId 3

    .EXAMPLE
        Get-LockpathRecords 3

    .EXAMPLE
        Get-LockpathRecords -ComponentId 3 -Filter @{'FieldPath'= @(84); 'FilterType'='1'; 'Value'='Test'}

    .INPUTS
        System.Array System.UInt32

    .OUTPUTS
        String

    .NOTES
        Native API Request: https://[InstanceName]:[InstancePort]/ComponentService/GetRecords

        The authentication account must have Read General Access permissions for the specific component, record and
        field.

    .LINK
        https://github.com/RobertKlohr/PowerShellForLockpath/wiki
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
        [ValidateRange('Positive')]
        [Int64] $ComponentId,

        [ValidateRange('NonNegative')]
        [Int32] $PageIndex = $Script:configuration.pageIndex,

        [ValidateRange('Positive')]
        [Int32] $PageSize = $Script:configuration.pageSize,

        [Array]$Filters = @()
    )

    Write-LockpathInvocationLog -Confirm:$false -WhatIf:$false

    $Body = @{
        'componentId' = $ComponentId
        'pageIndex'   = $PageIndex
        'pageSize'    = $PageSize
    }

    If ($Filters.Count -gt 0) {
        $Body.Add('filters', $Filters)
    }

    $params = @{
        'UriFragment' = 'ComponentService/GetRecords'
        'Method'      = 'POST'
        'Description' = "Getting records from component with Id: $ComponentId & filter: $($Filters | ConvertTo-Json -Depth $Script:configuration.jsonConversionDepth -Compress)"
        'Body'        = $Body | ConvertTo-Json -Depth $Script:configuration.jsonConversionDepth
    }

    if ($PSCmdlet.ShouldProcess("Getting records from component with Id: $([environment]::NewLine) $ComponentId", $ComponentId, 'Getting records from component with Id:')) {
        [String] $result = Invoke-LockpathRestMethod @params -Confirm:$false
        return $result
    } else {
        Write-LockpathLog -Message "$($PSCmdlet.CommandRuntime.ToString()) ShouldProcess confirmation was denied." -Level Verbose -Confirm:$false -WhatIf:$false
    }
}
