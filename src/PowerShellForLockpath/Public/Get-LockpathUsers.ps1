function Get-LockpathUsers {
    [CmdletBinding(SupportsShouldProcess, DefaultParameterSetName = '__AllParameterSets')]
    [OutputType([string])]
    [Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSShouldProcess', '', Justification = 'Methods called within here make use of PSShouldProcess, and the switch is passed on to them inherently.')]

    param(
        [Parameter(ParameterSetName = 'AdvancedFilter')]
        [switch] $AdvancedFilter,

        [Parameter(ParameterSetName = 'AdvancedFilter')]
        [string] $Filter = '',

        # [Parameter(ParameterSetName = 'AccountStatusFilter')]
        # [switch] $AccountStatusFilter,

        [Parameter(ParameterSetName = 'AccountStatusFilter')]
        [ValidateSet('Active', 'Deleted')]
        [string] $AccountStatus = 'Active',

        # [Parameter(ParameterSetName = 'FilterAccountType')]
        # [switch] $AccountTypeFilter,

        [Parameter(ParameterSetName = 'FilterAccountType')]
        # 1 = FullUser
        # 2 = AwarenessUser
        # 4 = VendorUser
        [ValidateSet('Awareness', 'Full', 'Vendor')]
        [string] $AccountType = 'Full',

        [Parameter(ParameterSetName = 'FilterAccountType')]
        # 5 = EqualTo
        # 6 = NotEqualTo
        # 1002 = ContainsAny
        [ValidateSet('EqualTo', 'NotEqualTo', 'Contains')]
        [string] $FilterType = 'EqualTo',


        [ValidateRange(0, [int]::MaxValue)]
        [int] $PageIndex = 0,

        [ValidateRange(1, [int]::MaxValue)]
        [int] $PageSize = 1000
    )

    Write-InvocationLog

    $hashBodyPage = @{ }
    $hashBodyPage = @{
        'pageIndex' = $PageIndex
        'pageSize'  = $PageSize
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
        'UriFragment'          = '/SecurityService/GetUsers'
        'Method'               = 'Post'
        'Body'                 = $body
        'Description'          = "Getting users with FilterField: $FilterField, FilterType: $FilterType and FilterValue: $FilterValue."
        'AuthenticationCookie' = $AuthenticationCookie
    }
    return Invoke-LockpathRestMethod @params
}
