function Get-LockpathComponentByAlias {
    [CmdletBinding(SupportsShouldProcess)]
    [OutputType([string])]
    [Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSShouldProcess', '', Justification = 'Methods called within here make use of PSShouldProcess, and the switch is passed on to them inherently.')]
    param(
        [Parameter(Mandatory = $true, ValueFromPipeline = $true)]
        [string] $Alias
    )

    Write-InvocationLog

    $params = @{ }
    $params = @{
        'UriFragment'          = "/ComponentService/GetComponent?id=$Alias"
        'Method'               = 'Get'
        'Description'          = "Getting Component with Alias: $Alias"
        'AuthenticationCookie' = $AuthenticationCookie
    }
    return Invoke-LockpathRestMethod @params
}
