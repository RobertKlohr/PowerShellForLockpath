function Get-LockpathDetailRecord {
    [CmdletBinding(
        ConfirmImpact = 'Low',
        PositionalBinding = $false,
        SupportsShouldProcess = $true)]
    [OutputType('System.String')]
    [Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSShouldProcess', '', Justification = 'Methods called within here make use of PSShouldProcess, and the switch is passed on to them inherently.')]

    param(
        [Parameter(Mandatory = $true, ValueFromPipeline = $true)]
        [ValidateRange(1, [int]::MaxValue)]
        [int] $ComponentId,

        [Parameter(Mandatory = $true, ValueFromPipeline = $true)]
        [ValidateRange(1, [int]::MaxValue)]
        [int] $RecordId,

        [Parameter(ValueFromPipeline = $true)]
        [ValidateSet($false, $true)]
        [boolean] $EmbedRichTextImages = $false
    )

    begin {
        Write-LockpathInvocationLog
        $params = @{ }
        $params = @{
            'UriFragment' = "ComponentService/GetDetailRecord?componentId=$ComponentId&recordId=$RecordId&embedRichTextImages=$EmbedRichTextImages"
            'Method'      = 'GET'
            'Description' = "Getting Detail Record with Component Id: $ComponentId,  Record Id: $RecordId and Rich Text Images: $EmbedRichTextImages"
        }
    }

    process {
        $result = Invoke-LockpathRestMethod @params
    }

    end {
        return $result
    }
}
