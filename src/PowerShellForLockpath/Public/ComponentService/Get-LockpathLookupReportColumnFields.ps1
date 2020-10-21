function Get-LockpathLookupReportColumnFields {
    #TODO Create Help Section
    #TODO Update to new coding standards
    [CmdletBinding(
        ConfirmImpact = 'Low',
        PositionalBinding = $false,
        SupportsShouldProcess = $true)]
    [OutputType('System.String')]
    [Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSShouldProcess', '', Justification = 'Methods called within here make use of PSShouldProcess, and the switch is passed on to them inherently.')]

    param(
        [Parameter(Mandatory = $true, ValueFromPipeline = $true)]
        [ValidateRange(1, [int]::MaxValue)]
        [int] $LookupFieldId,

        [Parameter(Mandatory = $true, ValueFromPipeline = $true)]
        [ValidateRange(1, [int]::MaxValue)]
        [int] $FieldPathId
    )

    begin {
        Write-LockpathInvocationLog
        $params = @{ }
        $params = @{
            'UriFragment' = "ComponentService/GetLookupReportColumnFields?lookupFieldId=$LookupFieldId&fieldPathId=$FieldPathId"
            'Method'      = 'GET'
            'Description' = "Getting Lookup Fields with Field Id: $LookupFieldId and Field Path Id: $FieldPathId"
        }
    }

    process {
        $result = Invoke-LockpathRestMethod @params
    }

    end {
        return $result
    }
}
