function Get-LockpathDetailRecords {
    [CmdletBinding(
        ConfirmImpact = 'Low',
        PositionalBinding = $false,
        SupportsShouldProcess = $true)]
    [OutputType('System.String')]
    [Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSShouldProcess', '', Justification = 'Methods called within here make use of PSShouldProcess, and the switch is passed on to them inherently.')]
    param(
        [Parameter(Mandatory = $true)]
        [ValidateRange(1, [int]::MaxValue)]
        [int] $ComponentId,

        [ValidateRange(0, [int]::MaxValue)]
        [int] $PageIndex = $(Get-LockpathConfiguration -Name 'pageIndex'),

        [ValidateRange(1, [int]::MaxValue)]
        [int] $PageSize = $(Get-LockpathConfiguration -Name 'pageSize'),

        [array] $FieldIds = $null,

        [array] $Filter = $null,

        [array] $SortOrder = $null
    )

    Write-LockpathInvocationLog

    $params = @{ }
    $params = @{
        'UriFragment' = 'ComponentService/GetDetailRecords'
        'Method'      = 'POST'
        'Description' = "Getting Detail Records with Component Id: $ComponentId and Field Ids: $FieldIds"
        'Body'        = [ordered]@{
            'componentId' = $ComponentId
            'pageIndex'   = $PageIndex
            'pageSize'    = $PageSize
            'filters'     = $Filter
        } | ConvertTo-Json -Depth 10
    }

    $result = Invoke-LockpathRestMethod @params

    return $result
}
