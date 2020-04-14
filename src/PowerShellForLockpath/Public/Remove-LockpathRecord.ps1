function Remove-LockpathRecord {
    [CmdletBinding(SupportsShouldProcess)]
    [OutputType([string])]
    [Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSShouldProcess', '', Justification = 'Methods called within here make use of PSShouldProcess, and the switch is passed on to them inherently.')]

    param(
        [Parameter(Mandatory = $true, ValueFromPipeline = $true)]
        [ValidateRange(1, [int]::MaxValue)]
        [int] $ComponentId,

        [Parameter(Mandatory = $true, ValueFromPipeline = $true)]
        [ValidateRange(1, [int]::MaxValue)]
        [int] $RecordId
    )

    begin {
        #TODO call get record attachment to add attachment name to log
        Write-LockpathInvocationLog
        $params = @{ }
        $params = @{
            'UriFragment' = "ComponentService/DeleteRecord?componentId=$ComponentId&recordId=$RecordId"
            'Method'      = 'DELETE'
            'Description' = "Deleting Record with Component Id: $ComponentId and Record Id: $RecordId"
            'Body'        = @{
                'ComponentId' = $ComponentId
                'RecordId'    = $RecordId
            } | ConvertTo-Json
        }
    }

    process {
        $result = Invoke-LockpathRestMethod @params
    }

    end {
        return $result
    }
}
