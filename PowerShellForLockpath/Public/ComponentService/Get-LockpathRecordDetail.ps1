function Get-LockpathRecordDetail {
    <#
    .SYNOPSIS
        Retrieves record information based on the provided component ID and record ID, with lookup field report
        details.

    .DESCRIPTION
        Retrieves record information based on the provided component ID and record ID, with lookup field report
        details. Lookup field records will detail information for fields on their report definition, if one is
        defined. Using the optional parameter -ExtractRichTextImages you can extract images contained in rich text
        fields. The component Id may be found by using Get-LockpathComponentList. The record Id may be found by
        using Get-LockpathRecords.

        The Git repo for this module can be found here: https://github.com/RobertKlohr/PowerShellForLockpath

    .PARAMETER ComponentId
        Specifies the Id number of the component as a positive integer.

    .PARAMETER RecordId
        Specifies the Id number of the record as a positive integer.

    .EXAMPLE
        Get-LockpathRecordDetail -ComponentId 2 -RecordId 1

    .EXAMPLE
        Get-LockpathRecordDetail -ComponentId 2 -RecordId 1 -ExtractRichTextImages True

    .INPUTS
        System.Uint32

    .OUTPUTS
        String

    .NOTES
        Native API Request: https://[InstanceName]:[InstancePort]/ComponentService/GetDetailRecord?componentId=$ComponentId&recordId=$RecordId&embedRichTextImages=$ExtractRichTextImages

        The authentication account must have Read General Access permissions for the specific component, record and
        field.

    .LINK
        https://github.com/RobertKlohr/PowerShellForLockpath/wiki
    #>

    [CmdletBinding(
        ConfirmImpact = 'Low',
        PositionalBinding = $false,
        SupportsShouldProcess = $true)]
    [OutputType('System.String')]

    param(
        [Parameter(Mandatory = $true,
            ValueFromPipeline = $true,
            ValueFromPipelineByPropertyName = $true)]
        [ValidateRange('Positive')]
        [Int64] $ComponentId,

        [Parameter(Mandatory = $true,
            ValueFromPipeline = $true,
            ValueFromPipelineByPropertyName = $true)]
        [ValidateRange('Positive')]
        [Int64] $RecordId,

        [Parameter(ValueFromPipeline = $true,
            ValueFromPipelineByPropertyName = $true)]
        [switch] $ExtractRichTextImages
    )

    begin {
        Write-LockpathInvocationLog -Confirm:$false -WhatIf:$false
    }

    process {
        $params = @{
            'UriFragment' = "ComponentService/GetDetailRecord?componentId=$ComponentId&recordId=$RecordId&embedRichTextImages=$ExtractRichTextImages"
            'Method'      = 'GET'
            'Description' = "Getting Detail Record with component Id: $ComponentId, record Id: $RecordId and extract rich text images: $ExtractRichTextImages"
        }

        if ($PSCmdlet.ShouldProcess("Getting record details for record with: $([environment]::NewLine) component Id: $ComponentId, record Id: $RecordId & extract rich text images: $ExtractRichTextImages", "component Id: $ComponentId, record Id: $RecordId & extract rich text images: $ExtractRichTextImages", 'Getting record details for record with:')) {
            [String] $result = Invoke-LockpathRestMethod @params -Confirm:$false
            return $result
        } else {
            Write-LockpathLog -Message "$($PSCmdlet.CommandRuntime.ToString()) ShouldProcess confirmation was denied." -Level Verbose -Confirm:$false -WhatIf:$false
        }
    }

    end {
    }
}
