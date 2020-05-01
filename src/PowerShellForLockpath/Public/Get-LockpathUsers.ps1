#TODO setup for filters - Maybe not, just get filter in this function and build the filter in the calling function
#TODO check parameter sets
function Get-LockpathUsers {
    [CmdletBinding(SupportsShouldProcess, DefaultParameterSetName = '__AllParameterSets')]
    [OutputType([string])]
    [Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSShouldProcess', '', Justification = 'Methods called within here make use of PSShouldProcess, and the switch is passed on to them inherently.')]

    param(
        #TODO is string the correct type or should this be a PSCustomObject type?
        [array] $Filter = '',

        [ValidateRange(0, [int]::MaxValue)]
        [int] $PageIndex = $(Get-LockpathConfiguration -Name 'pageIndex'),

        [ValidateRange(1, [int]::MaxValue)]
        [int] $PageSize = $(Get-LockpathConfiguration -Name 'pageSize')
    )

    Write-LockpathInvocationLog

    $params = @{ }
    $params = @{
        'UriFragment' = 'SecurityService/GetUsers'
        'Method'      = 'POST'
        'Description' = "Getting User Records with Filter: $Filter"
        'Body'        = [ordered]@{
            'pageIndex' = $PageIndex
            'pageSize'  = $PageSize
            'filters'   = $Filter
            # 'filters'   = @(
            #     [ordered]@{
            #         'Field'      = [ordered]@{
            #             'ShortName' = 'AccountType'
            #         }
            #         'FilterType' = '10002'
            #         'Value'      = '1|2|4'
            #     }
            # )
        } | ConvertTo-Json -Depth 10
    }

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

    <# possible code for convert individual parameters to filter
    $hashBodyFilter = @{ }
    if ($PSBoundParameters.ContainsKey('AccountStatus')) {
        $hashBodyFilter = @{
            'Filters' = @{
                'Field'      = @{
                    'ShortName' = $AccountStatus
                }
                'FilterType' = '5' #EqualsTo
                'Value'      = 'True'
            }
        }
    } elseif ($PSBoundParameters.ContainsKey('AccountType')) {
        $hashBodyFilter = @{
            'Filters' = @{
                'Field'      = @{
                    'ShortName' = 'Accounttype'
                }
                'FilterType' = '10002' #Contains
                'Value'      = '1|2|4'
            }
        }
    }

    $body = ''
    $body = (ConvertTo-Json -InputObject ($hashBodyPage + $hashBodyFilter))

    $params = @{ }
    $params = @{
        'UriFragment' = '/SecurityService/GetUsers'
        'Method'      = 'POST'
        'Body'        = $body
        'Description' = "Getting users with FilterField: $FilterField, FilterType: $FilterType and FilterValue: $FilterValue."
    }
 #>

    $result = Invoke-LockpathRestMethod @params

    return $result
}
