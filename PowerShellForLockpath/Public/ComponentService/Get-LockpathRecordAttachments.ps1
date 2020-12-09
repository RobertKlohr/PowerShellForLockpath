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
        $level = 'Information'
        $functionName = ($PSCmdlet.CommandRuntime.ToString())
        $service = 'ComponentService'
    }

    process {
        Write-LockpathInvocationLog -Confirm:$false -WhatIf:$false -FunctionName $functionName -Level $level -Service $service

        $params = @{
            'UriFragment' = "ComponentService/GetRecordAttachments?componentId=$ComponentId&recordId=$RecordId&fieldId=$FieldId"
            'Method'      = 'GET'
            'Description' = "Getting attachments from component Id: $ComponentId, record Id: $RecordId & field Id: $FieldId"
        }

        $params = @{
            'Description' = 'Getting Attachments By Component, Record & Field Id'
            'Method'      = 'GET'
            'Query'       = "?ComponentId=$ComponentId&RecordId=$RecordId&FieldId=$FieldId"
            'Service'     = $service
            'UriFragment' = 'GetRecordAttachments'
        }

        $target = "ComponentId=$ComponentId, RecordId=$RecordId & FieldId=$FieldId"

        # TODO possibly update to save file similar to Get-LockpathReport

        if ($PSCmdlet.ShouldProcess($target)) {
            try {
                $result = Invoke-LockpathRestMethod @params
                $message = 'success'
            } catch {
                $message = 'failed'
                $level = 'Warning'
            }
            Write-LockpathLog -Confirm:$false -WhatIf:$false -Message $message -FunctionName $functionName -Level $level -Service $service
            If ($message -eq 'failed') {
                return $message
            } else {
                return $result
            }
        }
    }

    end {
    }
}
