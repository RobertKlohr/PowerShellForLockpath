# Copyright (c) Robert Klohr. All rights reserved.
# Licensed under the MIT License.

function Get-LockpathRecordsDetails {
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

    .PARAMETER ComponentId
        Specifies the Id number of the component.

    .PARAMETER Filter
        The filter parameters the groups must meet to be included.

        Remove the filter to return a list of all records.

    .PARAMETER FieldIds
        Specifies the Id numbers of the field as a an array of positive integers.

    .PARAMETER SortOrder
        Specifies the field path Id and sort order as an array.

    .EXAMPLE
        Get-LockpathRecordsDetails -ComponentId 10066

    .EXAMPLE
        Get-LockpathRecordsDetails 10066

    .EXAMPLE
        Get-LockpathRecordsDetails -ComponentId 10066 -Filter @{'FieldPath'= @(9129); 'FilterType'='5'; 'Value'='True'}

    .EXAMPLE
        Get-LockpathRecordsDetails -ComponentId 10066 -FieldIds @(1417,1418,1430,9129)

    .EXAMPLE
        Get-LockpathRecordsDetails -ComponentId 10066 -SortOrder @{'FieldPath'= @(1418); 'Ascending'='True'}

    .EXAMPLE
        Get-LockpathRecordsDetails -ComponentId 10066 -FieldIds @(1417,1418,1430,9129) -Filter @{'FieldPath'= @(9129); 'FilterType'='5'; 'Value'='True'} -SortOrder @{'FieldPath'= @(1418); 'Ascending'='True'}

    .INPUTS
        System.Array System.UInt32

    .OUTPUTS
        String

    .NOTES
        Native API Request: https://[InstanceName]:[InstancePort]/ComponentService/GetDetailRecords

        The authentication account must have Read General Access permissions for the specific component, records
        and fields.

    .LINK
        https://git.io/powershellforlockpathhelp
    #>

    [Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSUseSingularNouns', '', Justification = 'This cmdlets is a wrapper for an API call that uses a plural noun.')]

    [CmdletBinding(
        ConfirmImpact = 'Low',
        PositionalBinding = $false,
        SupportsShouldProcess = $true
    )]

    [OutputType([System.String])]

    param(
        [Parameter(
            Mandatory = $true,
            Position = 0
        )]
        [ValidateRange('Positive')]
        [Int32] $ComponentId,

        [ValidateRange('NonNegative')]
        [Int32] $PageIndex = $Script:LockpathConfig.pageIndex,

        [ValidateRange('Positive')]
        [Int32] $PageSize = $Script:LockpathConfig.pageSize,

        [Array] $Filter = @(),

        [Array] $FieldIds = @(),

        [Array] $SortOrder = @()
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
            'componentId' = $ComponentId
            'pageIndex'   = $PageIndex
            'pageSize'    = $PageSize
            'filters'     = $Filter
            'fieldIds'    = $FieldIds
            'sortOrder'   = $SortOrder
        }

        $restParameters = [ordered]@{
            'Body'        = $Body | ConvertTo-Json -Compress -Depth $Script:LockpathConfig.conversionDepth
            'Description' = 'Getting Records Details'
            'Method'      = 'POST'
            'Service'     = $service
            'UriFragment' = 'GetDetailRecords'
        }

        $shouldProcessTarget = "$($restParameters.Description) with Filter = $($restParameters.Body)"

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
            return $logParameters.Message
        }
    }

    end {
    }
}
