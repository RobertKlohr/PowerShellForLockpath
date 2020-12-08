function Get-LockpathRecordAttachments {
    <#
    .SYNOPSIS
        Returns the file name, field Id and document Id for all attachments associated with a given record.

    .DESCRIPTION
        Returns the file name, field Id and document Id for all attachments associated with a given record. The
        contents of the attachment are not returned.

        The Git repo for this module can be found here: https://github.com/RobertKlohr/PowerShellForLockpath

    .PARAMETER ComponentId
        Specifies the Id number of the component.

    .PARAMETER RecordId
        Specifies the Id number of the record.

    .PARAMETER FieldId
        Specifies the Id number of the field.

    .EXAMPLE
        Get-LockpathRecordAttachments -ComponentId 2 -RecordId 1 -FieldId 1

    .INPUTS
        System.UInt32

    .OUTPUTS
        String

    .NOTES
        Native API Request: https://[InstanceName]:[InstancePort]/ComponentService/GetRecordAttachments?componentId=$ComponentId&recordId=$RecordId&fieldId=$FieldId

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

        [Parameter(Mandatory = $true,
            ValueFromPipeline = $true,
            ValueFromPipelineByPropertyName = $true)]
        [ValidateRange('Positive')]
        [Int64] $FieldId
    )

    begin {
        Write-LockpathInvocationLog -Confirm:$false -WhatIf:$false -Service ComponentService
    }

    process {
        $params = @{
            'UriFragment' = "ComponentService/GetRecordAttachments?componentId=$ComponentId&recordId=$RecordId&fieldId=$FieldId"
            'Method'      = 'GET'
            'Description' = "Getting attachments from component Id: $ComponentId, record Id: $RecordId & field Id: $FieldId"
        }

        if ($PSCmdlet.ShouldProcess("Getting attachments from field with: $([environment]::NewLine) component Id $ComponentId, record Id: $RecordId & F$ieldId", "component Id $ComponentId, record Id: $RecordId & $FieldId", 'Getting attachments from field with:')) {
            [String] $result = Invoke-LockpathRestMethod @params -Confirm:$false
            return $result
        } else {
            Write-LockpathLog -Confirm:$false -WhatIf:$false -Message 'ShouldProcess confirmation was denied.' -Level Verbose -FunctionName ($PSCmdlet.CommandRuntime.ToString()) -Service ComponentService
        }
    }

    end {
    }
}
