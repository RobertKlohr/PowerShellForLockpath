# Copyright (c) Robert Klohr. All rights reserved.
# Licensed under the MIT License.

function Get-LockpathField {
    <#
    .SYNOPSIS
        Returns details for a fields specified by it's Id.

    .DESCRIPTION
        Returns available fields for a given component. The field Id may be found by using Get-LockpathFieldList.

        The Git repo for this module can be found here: https://git.io/powershellforlockpath

    .PARAMETER FieldId
        Specifies the Id number of the field.

    .EXAMPLE
        Get-LockpathField -FieldId 7

    .EXAMPLE
        Get-LockpathField 7

    .EXAMPLE
        7 | Get-LockpathField

    .EXAMPLE
        7,8,9 | Get-LockpathField

    .EXAMPLE
        $fieldObject | Get-LockpathField
        If $fieldObject has an property called FieldId that value is automatically passed as a parameter.

    .INPUTS
        System.UInt32

    .OUTPUTS
        String

    .NOTES
        Native API Request: https://[InstanceName]:[InstancePort]/ComponentService/GetField?Id=$FieldId

        The authentication account must have Read General Access permissions for the specific component and field.

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
        [UInt32] $FieldId
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
            'Description' = "Getting Field with Id $FieldId"
            'Method'      = 'GET'
            'Query'       = "?Id=$FieldId"
            'Service'     = $service
            'UriFragment' = 'GetField'
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
