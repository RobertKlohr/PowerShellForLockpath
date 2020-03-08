function Get-LockpathField {
    [CmdletBinding(SupportsShouldProcess)]
    [OutputType([string])]
    [Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSShouldProcess', '', Justification = 'Methods called within here make use of PSShouldProcess, and the switch is passed on to them inherently.')]

    param(
        [Parameter(Mandatory = $true, ValueFromPipeline = $true)]
        [ValidateRange(0, [int]::MaxValue)]
        [int] $Id,

        # change AccountType to Type for input
        [ValidateSet('Active', 'Deleted', 'AccountType')]
        [string] $FilterField = 'Active',

        #Change these to named values
        [ValidateSet('5', '6', '10002')]
        [string] $FilterType = '5',

        #TODO: Change these to named values
        #TODO: split this into additional parameter groups to ensure that true/false are used with 5/6 and 1/2/4 are used with 10002
        [ValidateSet('True', 'False', '1', '2', '4')]
        [string] $FilterValue = 'True',

        [ValidateRange(0, [int]::MaxValue)]
        [int] $PageIndex = 1000,

        [ValidateRange(1, [int]::MaxValue)]
        [int] $PageSize = 0
    )

    Write-InvocationLog

    $params = @{ }
    $params = @{
        'UriFragment'          = "/SecurityService/GetField?Id=$Id"
        'Method'               = 'Get'
        'Description'          = "Getting field with Id: $Id, FilterField: $FilterField, FilterType: $FilterType and FilterValue: $FilterValue."
        'AuthenticationCookie' = $AuthenticationCookie
    }
    return Invoke-LockpathRestMethod @params
}
