#TODO setup for pipeline
#TODO setup for filters
function Get-LockpathUsers {
    [CmdletBinding(SupportsShouldProcess, DefaultParameterSetName = '__AllParameterSets')] #TODO check parameter sets
    [OutputType([string])]
    [Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSShouldProcess', '', Justification = 'Methods called within here make use of PSShouldProcess, and the switch is passed on to them inherently.')]

    param(
        [Parameter(ParameterSetName = 'FilterField')]
        [ValidateSet('Active', 'Deleted', 'AccountType')]
        [string] $FilterField,

        [Parameter(ParameterSetName = 'FilterType')]
        # 5 = EqualTo
        # 6 = NotEqualTo
        # 1002 = ContainsAny
        [ValidateSet('EqualTo', 'NotEqualTo', 'Contains')]
        [string] $FilterType,

        [Parameter(ParameterSetName = 'FilterValue')]
        # 1 = FullUser
        # 2 = AwarenessUser
        # 4 = VendorUser
        [ValidateSet('True', 'False', 'Awareness', 'Full', 'Vendor')]
        [string] $FilterValue,

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

    $result = Invoke-LockpathRestMethod @params

    return $result
}
