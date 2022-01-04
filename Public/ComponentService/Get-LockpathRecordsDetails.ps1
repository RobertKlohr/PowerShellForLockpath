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

    [CmdletBinding(
        ConfirmImpact = 'Low',
        PositionalBinding = $false,
        SupportsShouldProcess = $true)]
    [OutputType('System.String')]

    param(
        [Parameter(
            Mandatory = $true,
            Position = 0)]
        [ValidateRange('Positive')]
        [Int64] $ComponentId,

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
    }

    process {
        if ($Script:LockpathConfig.loggingLevel -eq 'Debug') {
            Write-LockpathInvocationLog -Confirm:$false -WhatIf:$false -FunctionName $functionName -Level $level -Service $service
        }

        $Body = [ordered]@{
            'componentId' = $ComponentId
            'pageIndex'   = $PageIndex
            'pageSize'    = $PageSize
            'filters'     = $Filter
            'fieldIds'    = $FieldIds
            'sortOrder'   = $SortOrder
        }

        $restParameters = [ordered]@{
            'Body'        = $Body | ConvertTo-Json -Depth $Script:LockpathConfig.jsonConversionDepth
            'Description' = 'Getting Records By Filter'
            'Method'      = 'POST'
            'Service'     = $service
            'UriFragment' = 'GetDetailRecords'
        }

        $logParameters = [ordered]@{
            'Confirm'      = $false
            'WhatIf'       = $false
            'Message'      = $message
            'FunctionName' = $functionName
            'Level'        = $level
            'Service'      = $service
        }

        $shouldProcessTarget = "Filter=$($restParameters.Body)"

        if ($PSCmdlet.ShouldProcess($shouldProcessTarget)) {
            try {
                $result = Invoke-LockpathRestMethod @restParameters
                $logParameters.message = 'success'
            } catch {
                $result = ($_.ErrorDetails.Message | ConvertFrom-Json).Message
                $logParameters.message = 'failed'
                $logParameters.level = 'Warning'
            } finally {
                Write-LockpathLog @logParameters
            }
            return $result
        }
    }

    end {
    }
}
