function Get-LockpathRecords {
    <#
    .SYNOPSIS
        Return the title/default field for a set of records within a chosen component.

    .DESCRIPTION
        Return the title/default field for a set of records within a chosen component. Filters may be applied to
        return only the records meeting selected criteria.

        The Git repo for this module can be found here: https://github.com/RobertKlohr/PowerShellForLockpath

    .PARAMETER PageIndex
        The index of the page of result to return. Must be an integer >= 0. If not set it defaults to the value set
        in the configuration.

    .PARAMETER PageSize
        The size of the page results to return. Must be an integer >= 1. If not set it defaults to the value set in
        the configuration.

    .PARAMETER ComponentId
        Specifies the Id number of the component as a positive integer.

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
        System.Array System.Uint32

    .OUTPUTS
        System.String

    .NOTES
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
        [Alias('Id')]
        [ValidateRange('Positive')]
        [uint] $ComponentId,

        [Alias('index')]
        [ValidateRange('NonNegative')]
        [uint] $PageIndex = $(Get-LockpathConfiguration -Name 'pageIndex'),

        [Alias('size')]
        [ValidateRange('Positive')]
        [uint] $PageSize = $(Get-LockpathConfiguration -Name 'pageSize'),

        [Alias('Filter')]
        [array]$Filters = @()
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
        'Description' = "Getting records from component with Id: $ComponentId & filter: $($Filters | ConvertTo-Json -Compress)"
        'Body'        = $Body | ConvertTo-Json -Depth 10
    }

    if ($PSCmdlet.ShouldProcess("Getting records from component with Id: $([environment]::NewLine) $ComponentId", $ComponentId, 'Getting records from component with Id:')) {
        [string] $result = Invoke-LockpathRestMethod @params -Confirm:$false
        return $result
    } else {
        Write-LockpathLog -Message "$($PSCmdlet.CommandRuntime.ToString()) ShouldProcess confirmation was denied." -Level Verbose -Confirm:$false -WhatIf:$false
    }
}
