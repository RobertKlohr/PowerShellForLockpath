function Get-LockpathComponent {
    # TODO: Can I take out the SupportsShouldProcess setting on all the functions that just 'get' and not 'set'
    [CmdletBinding(
        SupportsShouldProcess,
        DefaultParametersetName = 'All')]
    [Diagnostics.CodeAnalysis.SuppressMessageAttribute("PSShouldProcess", "", Justification = "Methods called within here make use of PSShouldProcess, and the switch is passed on to them inherently.")]
    param(
        [Parameter(ParameterSetName = 'All')]
        [switch] $All,

        [Parameter(ParameterSetName = 'Alias', Mandatory = $true)]
        [string] $Alias,

        [Parameter(ParameterSetName = 'Id', Mandatory = $true)]
        [string] $Id
    )

    Write-InvocationLog

    $params = @{ }

    if ($All) {
        $params = @{
            'UriFragment'          = "/ComponentService/GetComponentList"
            'Method'               = 'Get'
            'Description'          = "Getting all Components"
            'AuthenticationCookie' = $AuthenticationCookie
        }
    } elseif ($Alias) {
        $params = @{
            'UriFragment'          = "/ComponentService/GetComponentByAlias?alias=$Alias"
            'Method'               = 'Get'
            'Description'          = "Getting Component with Alias $Alias"
            'AuthenticationCookie' = $AuthenticationCookie
        }
    } else {
        $params = @{
            'UriFragment'          = "/ComponentService/GetComponent?id=$Id"
            'Method'               = 'Get'
            'Description'          = "Getting Component with Id $Id"
            'AuthenticationCookie' = $AuthenticationCookie
        }
    }
    return Invoke-LockpathRestMethod @params
}
