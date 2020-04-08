function Get-LockpathComponentList {
    [CmdletBinding(SupportsShouldProcess)]
    [OutputType([string])]
    [Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSShouldProcess', '', Justification = 'Methods called within here make use of PSShouldProcess, and the switch is passed on to them inherently.')]
    param(
        [Parameter(Mandatory = $true, ValueFromPipeline = $true)]
        [ValidateRange(0, [int]::MaxValue)]
        [int] $Id
    )

    begin {
        Write-InvocationLog
        $params = @{ }
        $params = @{
            'UriFragment' = '/ComponentService/GetComponentList'
            'Method'      = 'Get'
            'Description' = "Getting component list."
        }
    }

    process {
        $result = Invoke-LockpathRestMethod @params
    }

    end {
        return $result
    }
}
