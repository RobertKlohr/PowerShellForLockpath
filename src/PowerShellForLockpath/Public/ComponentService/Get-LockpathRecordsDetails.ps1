function Get-LockpathRecordsDetails {
    <#
.SYNOPSIS
    Returns specified fields for a set of records within a chosen component.
.DESCRIPTION
    Returns specified fields for a set of records within a chosen component. A list of fields may be applied to
    specify which fields are returned. Filters may be applied to return only the records meeting selected criteria.
    One or more sort orders may be applied to the results.
.PARAMETER PageIndex
    The index of the page of result to return. Must be an integer >= 0. If not set it defaults to the value set in
    the configuration.
.PARAMETER PageSize
    The size of the page results to return. Must be an integer >= 1. If not set it defaults to the value set in the
    configuration.
.PARAMETER ComponentId
    Specifies the Id number of the component as a positive integer.
.PARAMETER Filters
    The filter parameters the groups must meet to be included. Must be an array. Use filters to return only the
    records meeting the selected criteria. Remove all filters to return a list of all records.
.PARAMETER FieldIds
    Specifies the Id numbers of the field as a an array of positive integers.
.PARAMETER SortOrder
    Specifies the field path Id and sort order as an array.
.EXAMPLE
    Get-LockpathRecordsDetails -ComponentId 3
.EXAMPLE
    Get-LockpathRecordsDetails 3
.EXAMPLE
    Get-LockpathRecordsDetails -ComponentId 3 -Filter @{'FieldPath'= @(84); 'FilterType'='1'; 'Value'='Test'}
.EXAMPLE
    Get-LockpathRecordsDetails -ComponentId 3 -FieldIds @(1,2,3)
.EXAMPLE
    Get-LockpathRecordsDetails -ComponentId 3 -SortOrder @{'FieldPath'= @(84); 'Ascending'='true'}
.EXAMPLE
    Get-LockpathRecordsDetails -ComponentId 3 -FieldIds @(1,2,3) -Filter @{'FieldPath'= @(84); 'FilterType'='1'; 'Value'='Test'} -SortOrder @{'FieldPath'= @(84); 'Ascending'='true'}
.INPUTS
    System.Array.
    System.Uint32.
.OUTPUTS
    System.String.
.NOTES
    The authentication account must have Read General Access permissions for the specific component, records and
    fields.
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
        [int] $ComponentId,

        [Alias("index")]
        [ValidateRange("NonNegative")]
        [int] $PageIndex = $(Get-LockpathConfiguration -Name 'pageIndex'),

        [Alias("size")]
        [ValidateRange("Positive")]
        [int] $PageSize = $(Get-LockpathConfiguration -Name 'pageSize'),

        [Alias("Filter")]
        [array]$Filters = @(),

        [Alias("Fields")]
        [array]$FieldIds = @(),

        [Alias("Sort")]
        [array]$SortOrder = @()
    )

    Write-LockpathInvocationLog -Confirm:$false -WhatIf:$false

    $Body = @{
        'componentId' = $ComponentId
        'pageIndex'   = $PageIndex
        'pageSize'    = $PageSize
        'filters'     = $Filters
        'fieldIds'    = $FieldIds
        'sortOrder'   = $SortOrder
    }

    $params = @{
        'UriFragment' = 'ComponentService/GetDetailRecords'
        'Method'      = 'POST'
        'Description' = "Getting records from component with Id: $ComponentId & filter: $($Filters | ConvertTo-Json -Compress)"
        'Body'        = $Body | ConvertTo-Json -Depth 10
    }
    if ($PSCmdlet.ShouldProcess("Getting records from component with Id: $([environment]::NewLine) $ComponentId", $ComponentId, 'Getting records from component with Id:')) {
        $result = Invoke-LockpathRestMethod @params -Confirm:$false
        return $result
    } else {
        Write-LockpathLog -Message "$($PSCmdlet.CommandRuntime.ToString()) ShouldProcess confirmation was denied." -Level Verbose -Confirm:$false -WhatIf:$false
    }
}
