# Copyright (c) Robert Klohr. All rights reserved.
# Licensed under the MIT License.

function Get-LockpathRecordsAvailableForLookup {
    <#
    .SYNOPSIS
        Returns specified fields for a set of records within a chosen component.

    .DESCRIPTION
        Returns specified fields for a set of records within a chosen component. A list of fields may be applied to
        specify which fields are returned. A filter may be applied to return only the records meeting selected
        criteria. One or more sort orders may be applied to the results.

        The Git repo for this module can be found here: https://git.io/powershellforlockpath

    .PARAMETER PageIndex
        The index of the page of result to return.

        If not set it defaults to the value set in the configuration.

    .PARAMETER PageSize
        The size of the page results to return.

        If not set it defaults to the value set in the configuration.

    .PARAMETER FieldId
        Specifies the Id number of the field.

    .PARAMETER RecordId
        Specifies the Id number of the record.

    .EXAMPLE
        Get-LockpathRecordsAvailableForLookup -FieldId 3 -RecordId 4

    .EXAMPLE
        Get-LockpathRecordsAvailableForLookup -FieldId 3 -RecordId 4 -PageIndex 0 -PageSize 10

    .INPUTS
        System.UInt32

    .OUTPUTS
        String

    .NOTES
        Native API Request: https://[InstanceName]:[InstancePort]/ComponentService/GetAvailableLookupRecords

        The authentication account must have Read General Access permissions for the specific component, record and
        fields.

    .LINK
        https://git.io/powershellforlockpathhelp
    #>

    [CmdletBinding(
        ConfirmImpact = 'Low',
        PositionalBinding = $false,
        SupportsShouldProcess = $true
    )]
    [OutputType('System.String')]

    param(
        [Parameter(
            Mandatory = $true,
            Position = 0
        )]
        [ValidateRange('Positive')]
        [Int32] $FieldId,

        [ValidateRange('Positive')]
        [Int32] $RecordId,

        [ValidateRange('NonNegative')]
        [Int32] $PageIndex = $Script:LockpathConfig.pageIndex,

        [ValidateRange('Positive')]
        [Int32] $PageSize = $Script:LockpathConfig.pageSize
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

        $Body = [ordered]@{
            'pageIndex' = $PageIndex
            'pageSize'  = $PageSize
            'fieldId'   = $FieldId
        }

        If ($RecordId) {
            $Body.Add('recordId', $RecordId)
        }

        $restParameters = [ordered]@{
            'Body'        = $Body | ConvertTo-Json -Compress -Depth $Script:LockpathConfig.jsonConversionDepth
            'Description' = "Getting Record Available For Lookup with Field Id $FieldId and Record Id $RecordId"
            'Method'      = 'POST'
            'Service'     = $service
            'UriFragment' = 'GetAvailableLookupRecords'
        }

        $shouldProcessTarget = $restParameters.Description

        if ($PSCmdlet.ShouldProcess($shouldProcessTarget)) {
            try {
                [string] $result = Invoke-LockpathRestMethod @restParameters
                $logParameters.message = 'success: ' + $shouldProcessTarget
                try {
                    $logParameters.result = (ConvertFrom-Json -InputObject $result) | ConvertTo-Json -Compress
                } catch {
                    $logParameters.result = 'Unable to convert API response.'
                }
            } catch {
                $logParameters.Level = 'Error'
                $logParameters.Message = 'failed: ' + $shouldProcessTarget
                $logParameters.result = $_.Exception.Message
            } finally {
                Write-LockpathLog @logParameters
            }
            return $result
        }
    }

    end {
    }
}
