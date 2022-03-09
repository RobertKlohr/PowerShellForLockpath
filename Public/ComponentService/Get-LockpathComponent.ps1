# Copyright (c) Robert Klohr. All rights reserved.
# Licensed under the MIT License.

function Get-LockpathComponent {
    <#
    .SYNOPSIS
        Returns information about a component specified by its Id.

    .DESCRIPTION
        Returns information about a component specified by its Id.

        Returns the Id, Name, SystemName and ShortName for the component.

        The Git repo for this module can be found here: https://git.io/powershellforlockpath

    .PARAMETER ComponentId
        Specifies the Id number of the component.

        The component Id may be found by using Get-LockpathComponentList.

    .EXAMPLE
        Get-LockpathComponent -ComponentId 2

    .EXAMPLE
        Get-LockpathComponent 2

    .INPUTS
        System.UInt32

    .OUTPUTS
        {
            "Id": 10050, "Name": "Incident Reports",
            "SystemName": "LPIncidentReports",
            "ShortName": "LPIncidentReports"
        }

    .NOTES
        Native API Request: https://[InstanceName]:[InstancePort]/ComponentService/GetComponent?id=$ComponentId

        The authentication account must have Read General Access permissions for the specific component.

    .LINK
        https://git.io/powershellforlockpathhelp
    #>

    [CmdletBinding(
        ConfirmImpact = 'Low',
        PositionalBinding = $false,
        SupportsShouldProcess = $true
    )]

    [OutputType([System.String])]

    param(
        [Parameter(
            Mandatory = $true,
            Position = 0,
            ValueFromPipeline = $true,
            ValueFromPipelineByPropertyName = $true
        )]
        [ValidateRange('Positive')]
        [Int32] $ComponentId
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

        $restParameters = [ordered]@{
            'Description' = "Getting Component with Id $ComponentId"
            'Method'      = 'GET'
            'Query'       = "?Id=$ComponentId"
            'Service'     = $service
            'UriFragment' = 'GetComponent'
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
