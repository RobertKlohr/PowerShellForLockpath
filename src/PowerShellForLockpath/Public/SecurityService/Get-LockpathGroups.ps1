function Get-LockpathGroups {
    <#
    .SYNOPSIS
        Returns a list of groups and available fields.

    .DESCRIPTION
        Returns a list of groups and available fields.

    .PARAMETER PageIndex
        The index of the page of result to return. Must be an integer >= 0. If not set it defaults to the value set
        in the configuration.

    .PARAMETER PageSize
        The size of the page results to return. Must be an integer >= 1. If not set it defaults to the value set in
        the configuration.

    .PARAMETER Filters
        The filter parameters the groups must meet to be included. Must be an array. Use filters to return only the
        groups meeting the selected criteria. Remove all filters to return a list of all groups.

    .EXAMPLE
        Get-LockpathGroups

    .EXAMPLE
        Get-LockpathGroups -PageIndex 0 -PageSize 100

    .EXAMPLE
        Get-LockpathGroups -Filter @{'Field'= @{'ShortName'='BusinessUnit'}; 'FilterType'='5'; 'Value'='False'}

    .EXAMPLE
        Get-LockpathGroups -PageIndex 0 -PageSize 100 -Filter @{'Field'= @{'ShortName'='BusinessUnit'}; FilterType'='5'; 'Value'='False'}

    .INPUTS
        System.Array, System.Uint32

    .OUTPUTS
        System.String

    .NOTES
        The authentication account must have Read Administrative Access permissions to administer groups.

    .LINK
        https://github.com/RobertKlohr/PowerShellForLockpath
    #>

    [CmdletBinding(
        ConfirmImpact = 'Low',
        PositionalBinding = $false,
        SupportsShouldProcess = $true)]
    [OutputType('System.String')]

    param(
        [Alias("Index")]
        [ValidateRange("NonNegative")]
        [uint] $PageIndex = $(Get-LockpathConfiguration -Name 'pageIndex'),

        [Alias("Size")]
        [ValidateRange("Positive")]
        [uint] $PageSize = $(Get-LockpathConfiguration -Name 'pageSize'),

        [Alias("Filter")]
        [array]$Filters = @()
    )

    Write-LockpathInvocationLog -Confirm:$false -WhatIf:$false

    $Body = @{
        'pageIndex' = $PageIndex
        'pageSize'  = $PageSize
    }

    If ($Filters.Count -gt 0) {
        $Body.Add('filters', $Filters)
    }

    $params = @{
        'UriFragment' = 'SecurityService/GetGroups'
        'Method'      = 'POST'
        'Description' = "Getting groups with filter: $($Filters | ConvertTo-Json -Compress)"
        'Body'        = $Body | ConvertTo-Json -Depth 10
    }

    if ($PSCmdlet.ShouldProcess("Getting groups with body: $([environment]::NewLine) $($params.Body)", $($params.Body), 'Getting groups with body:')) {
        $result = Invoke-LockpathRestMethod @params -Confirm:$false
        return $result
    } else {
        Write-LockpathLog -Message "$($PSCmdlet.CommandRuntime.ToString()) ShouldProcess confirmation was denied." -Level Verbose -Confirm:$false -WhatIf:$false
    }
}
