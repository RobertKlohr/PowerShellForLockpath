﻿function Set-LockpathRecordAttachments {
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
        Specifies the Id number of the component.

        The component Id may be found by using Get-LockpathComponents.

    .PARAMETER RecordId
        Specifies the Id number of the record.

        The record Id may be found by using Get-LockpathRecords.

    .PARAMETER FieldId
        Specifies the Id number of the field.

        The field Id may be found by using Get-LockpathFieldsList.

    .PARAMETER FilePath
        Specifies the absolute path to the file being updated.

    .EXAMPLE
        Set-LockpathRecordAttachments -ComponentId 10066 -RecordId 301 -FieldId 1434 -FilePath 'c:\temp\test.txt'

    .INPUTS
        IO.FileInfo, String

    .OUTPUTS
        String

    .NOTES
        Native API Request: https://[InstanceName]:[InstancePort]/ComponentService/UpdateRecordAttachments

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
        [Int64] $FieldId,

        [Parameter(Mandatory = $true,
            ValueFromPipeline = $true,
            ValueFromPipelineByPropertyName = $true)]
        [IO.FileInfo] $FilePath
    )

    begin {
        Write-LockpathInvocationLog -ExcludeParameter FilePath -Confirm:$false -WhatIf:$false
    }

    process {
        $fileData = [Convert]::ToBase64String([IO.File]::ReadAllBytes($FilePath))

        $Body = [ordered]@{
            'componentId'   = $ComponentId
            'dynamicRecord' = [ordered]@{'Id' = $RecordId
                'FieldValues'                 = @(@{'key' = $FieldId
                        'value'           = @(@{'fileName' = $FilePath.Name
                                'fileData'       = $fileData
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
            'Body'        = $Body | ConvertTo-Json -Depth $script:configuration.jsonConversionDepth
        }

        if ($PSCmdlet.ShouldProcess("Updating attachments with: $([environment]::NewLine) component Id $ComponentId, record Id: $RecordId, field Id: $FieldId & File: $($FilePath.Name)", "component Id $ComponentId, record Id: $RecordId, field Id: $FieldId & File: $($FilePath.Name)", 'Updating attachments with:')) {
            [String] $result = Invoke-LockpathRestMethod @params -Confirm:$false
            return $result
        } else {
            Write-LockpathLog -Message "$($PSCmdlet.CommandRuntime.ToString()) ShouldProcess confirmation was denied." -Level Verbose -Confirm:$false -WhatIf:$false
        }
    }

    end {
    }
}
