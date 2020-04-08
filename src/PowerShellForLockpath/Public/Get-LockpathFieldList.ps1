function Get-LockpathFieldList {
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
            'UriFragment' = "/ComponentService/GetFieldList?componentId=$Id"
            'Method'      = 'Get'
            'Description' = "Getting field list with component Id: $Id"
        }
    }
    process {
        $result = Invoke-LockpathRestMethod @params
    }

    end {
        return $result
    }
}
