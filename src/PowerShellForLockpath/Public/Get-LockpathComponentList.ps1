function Get-LockpathComponentList {
    [CmdletBinding(SupportsShouldProcess)]
    [OutputType([string])]
    [Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSShouldProcess', '', Justification = 'Methods called within here make use of PSShouldProcess, and the switch is passed on to them inherently.')]
    param(
        [Parameter(Mandatory = $true, ValueFromPipeline = $true)]
        [ValidateRange(0, [int]::MaxValue)]
        [int] $Id
    )

    Write-InvocationLog

    $params = @{ }
    $params = @{
        'UriFragment'          = '/ComponentService/GetComponentList'
        'Method'               = 'Get'
        'Description'          = 'Getting Component List.'
        'AuthenticationCookie' = $AuthenticationCookie
    }
    return Invoke-LockpathRestMethod @params
}
