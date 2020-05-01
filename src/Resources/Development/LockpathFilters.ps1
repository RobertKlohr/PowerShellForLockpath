
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
