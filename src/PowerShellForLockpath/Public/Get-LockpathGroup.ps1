﻿function Get-LockpathGroup {
    [CmdletBinding(SupportsShouldProcess)]
    [OutputType([string])]
    [Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSShouldProcess', '', Justification = 'Methods called within here make use of PSShouldProcess, and the switch is passed on to them inherently.')]

    param(
        [Parameter(Mandatory = $true, ValueFromPipeline = $true)]
        [ValidateRange(0, [int]::MaxValue)]
        [int] $GroupId
    )

    begin {
        Write-InvocationLog
        $params = @{ }
        $params = @{
            'UriFragment' = "SecurityService/GetGroup?Id=$GroupId"
            'Method'      = 'GET'
            'Description' = "Getting Group with Group Id: $GroupId"
        }
    }

    process {
        $result = Invoke-LockpathRestMethod @params
    }

    end {
        return $result
    }
}
