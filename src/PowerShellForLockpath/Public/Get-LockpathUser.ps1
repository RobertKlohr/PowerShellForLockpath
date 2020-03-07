function Get-LockpathUser {
    [CmdletBinding(
        SupportsShouldProcess,
        DefaultParametersetName = 'None')]
    [Diagnostics.CodeAnalysis.SuppressMessageAttribute("PSShouldProcess", "", Justification = "Methods called within here make use of PSShouldProcess, and the switch is passed on to them inherently.")]
    param(
        [Parameter(ParameterSetName = 'All')]
        [switch] $All,

        [Parameter(ParameterSetName = 'Count')]
        [switch] $Count,

        [Parameter(ParameterSetName = 'All')]
        [Parameter(ParameterSetName = 'Count')]
        # change AccountType to Type for input
        [ValidateSet("Active", "Deleted", "AccountType")]
        [string] $FilterField = 'Active',

        [Parameter(ParameterSetName = 'All')]
        [Parameter(ParameterSetName = 'Count')]
        #Change these to named values
        [ValidateSet("5", "6", "10002")]
        [string] $FilterType = '5',

        [Parameter(ParameterSetName = 'All')]
        [Parameter(ParameterSetName = 'Count')]
        #TODO: Change these to named values
        #TODO: split this into additional parameter groups to ensure that true/false are used with 5/6 and 1/2/4 are used with 10002
        [ValidateSet("True", "False", "1", "2", "4")]
        [string] $FilterValue = 'True',

        [Parameter(ParameterSetName = 'Id', Mandatory = $true)]
        [string] $Id,

        [Parameter(ParameterSetName = 'All', Mandatory = $true)]
        [int] $PageIndex = 1000,

        [Parameter(ParameterSetName = 'All', Mandatory = $true)]
        [int] $PageSize = 0
    )

    Write-InvocationLog

    $hashBodyPage = @{ }
    $hashBodyPage = @{
        'pageIndex' = $PageIndex
        'pageSize'  = $PageSize
    }

    $hashBodyFilter = @{ }
    if ($PSBoundParameters.ContainsKey('FilterField')) {
        $hashBodyFilter = @{
            'FilterField' = $FilterField
            'FilterType'  = $FilterType
            'FilterValue' = $FilterValue
        }
    }

    $params = @{ }

    if ($All) {
        if (-not $PSBoundParameters.ContainsKey('FilterField')) {
            $body = (ConvertTo-Json -InputObject $hashBodyPage)
        } else {
            $body = (ConvertTo-Json -InputObject $hashBodyPage, $hashBodyFilter)
        }
        $params = @{
            'UriFragment'          = '/SecurityService/GetUserUsers'
            'Method'               = 'Post'
            'Body'                 = $body
            'Description'          = "Getting all users"
            'AuthenticationCookie' = $AuthenticationCookie
        }
    } elseif ($Count) {
        if (-not $PSBoundParameters.ContainsKey('FilterField')) {
            $body = '{}'
            else {
                $body = (ConvertTo-Json -InputObject $hashBodyFilter)
            }
        }
        $params = @{
            'UriFragment'          = '/SecurityService/GetUserCount'
            'Method'               = 'Post'
            'Body'                 = $body
            'Description'          = "Getting user count"
            'AuthenticationCookie' = $AuthenticationCookie
        }
    } else {
        $params = @{
            'UriFragment'          = "/SecurityService/GetUser?Id=$Id"
            'Method'               = 'Get'
            'Description'          = "Getting user with Id $Id"
            'AuthenticationCookie' = $AuthenticationCookie
        }
    }
    return Invoke-LockpathRestMethod @params
}
