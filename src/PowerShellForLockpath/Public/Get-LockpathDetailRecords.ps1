function Get-LockpathDetailRecords {
    [CmdletBinding(SupportsShouldProcess)]
    [OutputType([string])]
    [Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSShouldProcess', '', Justification = 'Methods called within here make use of PSShouldProcess, and the switch is passed on to them inherently.')]
    param(
        [Parameter(Mandatory = $true)]
        [ValidateRange(1, [int]::MaxValue)]
        [int] $ComponentId,

        [ValidateRange(0, [int]::MaxValue)]
        [int] $PageIndex = $(Get-LockpathConfiguration -Name 'pageIndex'),

        [ValidateRange(1, [int]::MaxValue)]
        [int] $PageSize = $(Get-LockpathConfiguration -Name 'pageSize'),

        [array] $FieldIds = (2500, 2502),

        #TODO Need to update this to except a custom filter object
        [int] $Filter = 3881,

        [int] $SortOrder = 4991
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
            'filters'     = @(
            )
        } | ConvertTo-Json -Depth 10

        # 'Body'        = [ordered]@{
        #     'ComponentId' = $ComponentId
        #     'PageIndex'   = $PageIndex
        #     'PageSize'    = $PageSize
        #     'Filters'     = @(
        #         [ordered]@{
        #             'FieldPath'  = @(
        #                 $Filter
        #             )
        #             'FilterType' = 3
        #             'Value'      = 'Blue'
        #         }
        #     )
        #     'SortOrder'   = @(
        #         [ordered]@{
        #             'FieldPath' = @(
        #                 $SortOrder
        #             )
        #             'Ascending' = $true
        #         }
        #     )
        #     'FieldIds'    = @(
        #         $FieldIds
        #     )
        # } | ConvertTo-Json
    }

    $result = Invoke-LockpathRestMethod @params

    return $result
}
