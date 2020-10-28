function Get-LockpathRecordsAvailableForLookup {
    <#
    .SYNOPSIS
        Returns specified fields for a set of records within a chosen component.

    .DESCRIPTION
        Returns specified fields for a set of records within a chosen component. A list of fields may be applied to
        specify which fields are returned. Filters may be applied to return only the records meeting selected
        criteria. One or more sort orders may be applied to the results.

        The Git repo for this module can be found here: https://github.com/RobertKlohr/PowerShellForLockpath

    .PARAMETER PageIndex
        The index of the page of result to return. Must be an integer >= 0. If not set it defaults to the value set
        in the configuration.

    .PARAMETER PageSize
        The size of the page results to return. Must be an integer >= 1. If not set it defaults to the value set in
        the configuration.

    .PARAMETER FieldId
        Specifies the Id number of the field as a positive integer.

    .PARAMETER RecordId
        Specifies the Id number of the record as a positive integer.

    .EXAMPLE
        Get-LockpathRecordsAvailableForLookup -FieldId 3 -RecordId 4

    .EXAMPLE
        Get-LockpathRecordsAvailableForLookup -FieldId 3 -RecordId 4 -PageIndex 0 -PageSize 10

    .INPUTS
        System.Uint32

    .OUTPUTS
        System.String

    .NOTES
        The authentication account must have Read General Access permissions for the specific component, record and
        fields.

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
        [Alias('Field')]
        [ValidateRange('Positive')]
        [uint] $FieldId,

        [Alias('Record')]
        [ValidateRange('Positive')]
        [uint] $RecordId,

        [Alias('index')]
        [ValidateRange('NonNegative')]
        [uint] $PageIndex = $(Get-LockpathConfiguration -Name 'pageIndex'),

        [Alias('size')]
        [ValidateRange('Positive')]
        [uint] $PageSize = $(Get-LockpathConfiguration -Name 'pageSize')
    )

    Write-LockpathInvocationLog -Confirm:$false -WhatIf:$false

    $Body = @{
        'pageIndex' = $PageIndex
        'pageSize'  = $PageSize
        'fieldId'   = $FieldId
    }

    If ($RecordId) {
        $Body.Add('recordId', $RecordId)
    }

    $params = @{
        'UriFragment' = 'ComponentService/GetAvailableLookupRecords'
        'Method'      = 'POST'
        'Description' = "Getting records available for lookup from field with: $FieldId & filter: $($Filters | ConvertTo-Json -Compress)"
        'Body'        = $Body | ConvertTo-Json -Depth 10
    }

    if ($PSCmdlet.ShouldProcess("Getting records from component with Id: $([environment]::NewLine) $FieldId", $FieldId, 'Getting records from component with Id:')) {
        [string] $result = Invoke-LockpathRestMethod @params -Confirm:$false
        return $result
    } else {
        Write-LockpathLog -Message "$($PSCmdlet.CommandRuntime.ToString()) ShouldProcess confirmation was denied." -Level Verbose -Confirm:$false -WhatIf:$false
    }
}
