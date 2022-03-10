# Copyright (c) Robert Klohr. All rights reserved.
# Licensed under the MIT License.

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

        The Git repo for this module can be found here: https://git.io/powershellforlockpath

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
        https://git.io/powershellforlockpathhelp
    #>

    [Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSUseSingularNouns', '', Justification = 'This cmdlets is a wrapper for an API call that uses a plural noun.')]

    [CmdletBinding(
        ConfirmImpact = 'Medium',
        PositionalBinding = $false,
        SupportsShouldProcess = $true
    )]

    [OutputType([System.String])]

    param(
        [Parameter(
            Mandatory = $true,
            ValueFromPipeline = $true,
            ValueFromPipelineByPropertyName = $true
        )]
        [ValidateRange('Positive')]
        [UInt32] $ComponentId,

        [Parameter(
            Mandatory = $true,
            ValueFromPipeline = $true,
            ValueFromPipelineByPropertyName = $true
        )]
        [ValidateRange('Positive')]
        [UInt32] $RecordId,

        [Parameter(
            Mandatory = $true,
            ValueFromPipeline = $true,
            ValueFromPipelineByPropertyName = $true
        )]
        [ValidateRange('Positive')]
        [UInt32] $FieldId,

        [Parameter(
            Mandatory = $true,
            ValueFromPipeline = $true,
            ValueFromPipelineByPropertyName = $true
        )]
        [System.IO.FileInfo] $FilePath
    )

    begin {
        $level = 'Information'
        $functionName = ($PSCmdlet.CommandRuntime.ToString())
        $service = 'ComponentService'

        $logParameters = [ordered]@{
            'Confirm'      = $false
            'FunctionName' = $functionName
            'Level'        = $level
            'Message'      = "Executing cmdlet: $functionName"
            'Service'      = $service
            'Result'       = "Executing cmdlet: $functionName"
            'WhatIf'       = $false
        }
    }

    process {
        Write-LockpathInvocationLog @logParameters

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

        $restParameters = [ordered]@{
            'Body'        = $Body | ConvertTo-Json -Compress -Depth $Script:LockpathConfig.conversionDepth
            'Description' = "Updating Attachment with Component Id $ComponentId, Record Id $RecordId, and Field Id $FieldId and File Name $($FilePath.Name)"
            'Method'      = 'POST'
            'Service'     = $service
            'UriFragment' = 'UpdateRecordAttachments'
        }

        $shouldProcessTarget = $restParameters.Description

        if ($PSCmdlet.ShouldProcess($shouldProcessTarget)) {
            try {
                [string] $result = Invoke-LockpathRestMethod @restParameters
                $logParameters.Message = 'Success: ' + $shouldProcessTarget
                try {
                    $logParameters.Result = (ConvertFrom-Json -InputObject $result) | ConvertTo-Json -Compress
                } catch {
                    $logParameters.Result = 'Unable to convert API response.'
                }
            } catch {
                $logParameters.Level = 'Error'
                $logParameters.Message = 'Failed: ' + $shouldProcessTarget
                $logParameters.Result = $_.Exception.Message
            } finally {
                Write-LockpathLog @logParameters
            }
            return $result
        }
    }

    end {
    }
}
