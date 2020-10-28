function Set-LockpathRecordAttachments {
    <#
    .SYNOPSIS
        Adds new attachments and/or updates existing attachments to the provided Documents field(s) on a specific
        record, from the provided the component Id, record Id, field Id.

    .DESCRIPTION
        Adds new attachments and/or updates existing attachments to the provided Documents field(s) on a specific
        record, from the provided the component Id, record Id, field Id. FileData is represented as a Base64
        string. The maximum data size of the request is controlled by the maxAllowedContentLength and
        maxReceivedMessageSize values in the API web.config.

        The Git repo for this module can be found here: https://github.com/RobertKlohr/PowerShellForLockpath

    .PARAMETER ComponentId
        Specifies the Id number of the component as a positive integer. The component Id may be found by using
        Get-LockpathComponents.

    .PARAMETER RecordId
        Specifies the Id number of the record as a positive integer. The record Id may be found by using
        Get-LockpathRecords.

    .PARAMETER FieldId
        Specifies the Id number of the field as a positive integer. The field Id may be found by using
        Get-LockpathFieldsList.

    .PARAMETER FilePath
        Specifies the absolute path to the file being updated.

    .EXAMPLE
        Set-LockpathRecordAttachments -ComponentId 10066 -RecordId 301 -FieldId 1434 -FilePath 'c:\temp\test.txt'

    .INPUTS
        System.IO.FileInfo, System.String

    .OUTPUTS
        System.String

    .NOTES
        The authentication account must have Read and Update General Access permissions for the specific component,
        record and field.

    .LINK
        https://github.com/RobertKlohr/PowerShellForLockpath/wiki
    #>

    [CmdletBinding(
        ConfirmImpact = 'Medium',
        PositionalBinding = $false,
        SupportsShouldProcess = $true)]
    [OutputType('System.String')]

    param(
        [Parameter(
            Mandatory = $true,
            ValueFromPipeline = $true,
            ValueFromPipelineByPropertyName = $true)]
        [Alias('Component')]
        [ValidateRange('Positive')]
        [uint] $ComponentId,

        [Parameter(
            Mandatory = $true,
            ValueFromPipeline = $true,
            ValueFromPipelineByPropertyName = $true)]
        [Alias('Record')]
        [ValidateRange('Positive')]
        [uint] $RecordId,

        [Parameter(
            Mandatory = $true,
            ValueFromPipeline = $true,
            ValueFromPipelineByPropertyName = $true)]
        [Alias('Field')]
        [ValidateRange('Positive')]
        [uint] $FieldId,

        [Parameter(
            Mandatory = $true,
            ValueFromPipeline = $true,
            ValueFromPipelineByPropertyName = $true)]
        [Alias('File')]
        [System.IO.FileInfo] $FilePath
    )

    begin {
        Write-LockpathInvocationLog -Confirm:$false -WhatIf:$false
    }

    process {
        $fileData = [Convert]::ToBase64String([IO.File]::ReadAllBytes($FilePath))

        $Body = [ordered]@{
            'componentId'   = $ComponentId
            'dynamicRecord' = [ordered]@{'Id' = $RecordId
                'FieldValues'                 = @(@{'key' = $FieldId
                        'value'           = @(@{'FileName' = $FilePath.Name
                                'FileData'       = $fileData
                            }
                        )
                    }
                )
            }
        }

        $params = @{
            'UriFragment' = 'ComponentService/UpdateRecordAttachments'
            'Method'      = 'POST'
            'Description' = "Updating attachment from component Id: $ComponentId, record Id: $RecordId, field Id: $FieldId & File: $($FilePath.Name)"
            'Body'        = $Body | ConvertTo-Json -Depth 10
        }

        if ($PSCmdlet.ShouldProcess("Updating attachments with: $([environment]::NewLine) component Id $ComponentId, record Id: $RecordId, field Id: $FieldId & File: $($FilePath.Name)", "component Id $ComponentId, record Id: $RecordId, field Id: $FieldId & File: $($FilePath.Name)", 'Updating attachments with:')) {
            [string] $result = Invoke-LockpathRestMethod @params -Confirm:$false
            return $result
        } else {
            Write-LockpathLog -Message "$($PSCmdlet.CommandRuntime.ToString()) ShouldProcess confirmation was denied." -Level Verbose -Confirm:$false -WhatIf:$false
        }
    }

    end {
    }
}
