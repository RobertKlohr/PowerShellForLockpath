function Get-LockpathUsers {
    [CmdletBinding(
        ConfirmImpact = 'Low',
        PositionalBinding = $false,
        SupportsShouldProcess = $true)]
    [OutputType('System.String')]
    [Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSShouldProcess', '', Justification = 'Methods called within here make use of PSShouldProcess, and the switch is passed on to them inherently.')]

    param(
        [ValidateRange(0, [int]::MaxValue)]
        [int] $PageIndex = $(Get-LockpathConfiguration -Name 'pageIndex'),

        [ValidateRange(1, [int]::MaxValue)]
        [int] $PageSize = $(Get-LockpathConfiguration -Name 'pageSize'),

        [array] $Filter = $null
    )

    #TODO instead of code in the module could the parsing code go in a parameter scriptblock?

    # Filter Syntax an array of hashtables
    # (@{Shortname = "AccountType"; FilterType = 5; Value = 1 }, @{ Shortname = "Deleted"; FilterType = 5; Value = "true" })

    # TODO look at making this a private function that parses the filter and returns a hashtable that can be converted
    # to JSON

    # [array] $Filter = @(
    #     [ordered]@{
    #         'Field'      = [ordered]@{
    #             'ShortName' = 'Active'
    #         }
    #         'FilterType' = '5'
    #         'Value'      = 'true'
    #     }
    # )


    # if ($Filter) {
    #     $filterHash = @{ }

    #     foreach ($filterField in $Filter) {
    #         $fieldCount++
    #         $filterHash.Add("Value", $filterField.Value)
    #         $filterHash.Add("FilterType", $filterField.FilterType)
    #         $filterHash.Add("Field", @{"ShortName" = $filterField.Shortname })
    #     }
    # }

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
        } | ConvertTo-Json -Depth 10 #TODO remove this conversion and create the JSON separately
    }

    $result = Invoke-LockpathRestMethod @params

    return $result
}