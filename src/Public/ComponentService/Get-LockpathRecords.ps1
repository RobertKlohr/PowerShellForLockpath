# Copyright (c) Robert Klohr. All rights reserved.
# Licensed under the MIT License.

function Get-LockpathRecords {
    <#
    .SYNOPSIS
        Return the title/default field for a set of records within a chosen component.

    .DESCRIPTION
        Return the title/default field for a set of records within a chosen component. A filter may be applied to
        return only the records meeting selected criteria.

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
        The filter parameter that a group must meet to be included in the results.

        Remove the filter to return a list of all records.

    .EXAMPLE
        Get-LockpathRecords -ComponentId 3

    .EXAMPLE
        Get-LockpathRecords 3

    .EXAMPLE
        Get-LockpathRecords -ComponentId 3 -Filter @{'FieldPath'= @(84); 'FilterType'='1'; 'Value'='Test'}

    .INPUTS
        System.Array System.UInt32

    .OUTPUTS
        String

    .NOTES
        Native API Request: https://[InstanceName]:[InstancePort]/ComponentService/GetRecords

        The authentication account must have Read General Access permissions for the specific component, record and
        field.

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
        [UInt32] $ComponentId,

        [ValidateRange('NonNegative')]
        [UInt32] $PageIndex = $Script:LockpathConfig.pageIndex,

        [ValidateRange('Positive')]
        [UInt32] $PageSize = $Script:LockpathConfig.pageSize,

        [Array]$Filter = @()
    )

    begin {
        $level = 'Information'
        $functionName = ($PSCmdlet.CommandRuntime.ToString())
        $service = 'ComponentService'

        $logParameters = [ordered]@{
            'FunctionName' = $functionName
            'Level'        = $level
            'Message'      = "Executing cmdlet: $functionName"
            'Service'      = $service
            'Result'       = "Executing cmdlet: $functionName"
        }
    }

    process {
        Write-LockpathInvocationLog @logParameters

        $Body = [ordered]@{
            'componentId' = $ComponentId
            'pageIndex'   = $PageIndex
            'pageSize'    = $PageSize
        }

        If ($Filter.Count -gt 0) {
            $Body.Add('filters', $Filter)
        }

        $restParameters = [ordered]@{
            'Body'        = $Body | ConvertTo-Json -Compress -Depth $Script:LockpathConfig.conversionDepth
            'Description' = 'Getting Records'
            'Method'      = 'POST'
            'Service'     = $service
            'UriFragment' = 'GetRecords'
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
            return $result
        }
    }

    end {
    }
}
