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

        #TODO Need to update the next three parameters to except all filter objects
        #TODO maybe a simple filter via parameters and advanced where a JSON object is passed
        [array] $FieldIds = $null,

        [int] $Filter = $null,

        [int] $SortOrder = $null
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
