function Get-LockpathUsers {
    [CmdletBinding(SupportsShouldProcess)]
    [Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSShouldProcess', '', Justification = 'Methods called within here make use of PSShouldProcess, and the switch is passed on to them inherently.')]

    param(
        [ValidateRange(0, [int]::MaxValue)]
        [int] $PageIndex = $(Get-LockpathConfiguration -Name 'pageIndex'),

        [ValidateRange(1, [int]::MaxValue)]
        [int] $PageSize = $(Get-LockpathConfiguration -Name 'pageSize'),

        [array] $Filter = $null
    )

    Write-LockpathInvocationLog

    $params = @{ }
    $params = @{
        'UriFragment' = 'SecurityService/GetUsers'
        'Method'      = 'POST'
        'Description' = "Getting Users with Filter: $Filter"
        'Body'        = [ordered]@{
            'pageIndex' = $PageIndex
            'pageSize'  = $PageSize
            'filters'   = $Filter
        } | ConvertTo-Json -Depth 10
    }

    $result = Invoke-LockpathRestMethod @params

    return $result
}
