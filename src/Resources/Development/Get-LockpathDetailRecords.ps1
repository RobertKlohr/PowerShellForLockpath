function Get-LockpathDetailRecord {
    [CmdletBinding(SupportsShouldProcess)]
    [OutputType([string])]
    [Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSShouldProcess', '', Justification = 'Methods called within here make use of PSShouldProcess, and the switch is passed on to them inherently.')]
    param(
        [Parameter(Mandatory = $true, ValueFromPipeline = $true)]
        [ValidateRange(1, [int]::MaxValue)]
        [int] $ComponentId,

        [Parameter(Mandatory = $true, ValueFromPipeline = $true)]
        [ValidateRange(0, [int]::MaxValue)]
        [int] $PageIndex,

        [Parameter(Mandatory = $true, ValueFromPipeline = $true)]
        [ValidateRange(1, [int]::MaxValue)]
        [int] $PageSize,

        #TODO Need to update this to except an array of integers
        [Parameter(Mandatory = $false, ValueFromPipeline = $true)]
        [ValidateRange(1, [int]::MaxValue)]
        [int] $FieldIds,

        #TODO Need to update this to except a custom filter object
        [Parameter(Mandatory = $false, ValueFromPipeline = $true)]
        [string] $Filter
    )

    begin {
        Write-LockpathInvocationLog
        $params = @{ }
        $params = @{
            'UriFragment' = 'ComponentService/GetDetailRecords'
            'Method'      = 'POST'
            'Description' = "Getting Detail Records with Component Id: $ComponentId and Field Ids: $FieldIds"
            'Body'        = 'test'
        }
    }

    process {
        $result = Invoke-LockpathRestMethod @params
    }

    end {
        return $result
    }
}
