#TODO setup for pipeline
#TODO setup for filters
function Get-LockpathUsers {
    [CmdletBinding(SupportsShouldProcess, DefaultParameterSetName = '__AllParameterSets')]
    [OutputType([string])]
    [Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSShouldProcess', '', Justification = 'Methods called within here make use of PSShouldProcess, and the switch is passed on to them inherently.')]

    param(
        [Parameter(Mandatory = $true, ParameterSetName = 'FilterField')]
        [ValidateSet('Active', 'Deleted', 'AccountType')]
        [string] $FilterField,

        [Parameter(Mandatory = $true, ParameterSetName = 'FilterType')]
        # 5 = EqualTo
        # 6 = NotEqualTo
        # 1002 = ContainsAny
        [ValidateSet('EqualTo', 'NotEqualTo', 'Contains')]
        [string] $FilterType,

        [Parameter(Mandatory = $true, ParameterSetName = 'FilterValue')]
        # 1 = FullUser
        # 2 = AwarenessUser
        # 4 = VendorUser
        [ValidateSet('True', 'False', 'Awareness', 'Full', 'Vendor')]
        [string] $FilterValue,

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
        'UriFragment' = '/SecurityService/GetUsers'
        'Method'      = 'POST'
        'Body'        = $body
        'Description' = "Getting users with FilterField: $FilterField, FilterType: $FilterType and FilterValue: $FilterValue."
    }
    return Invoke-LockpathRestMethod @params
}
