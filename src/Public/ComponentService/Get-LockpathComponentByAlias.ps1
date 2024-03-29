﻿# Copyright (c) Robert Klohr. All rights reserved.
# Licensed under the MIT License.

function Get-LockpathComponentByAlias {
    <#
    .SYNOPSIS
        Returns available fields for a given component.

    .DESCRIPTION
        Returns available fields for a given component. A component is a user-defined data object such as a custom
        content table. The component alias may be found by using Get-LockpathComponentList.

        The Git repo for this module can be found here: https://git.io/powershellforlockpath

    .PARAMETER ComponentAlias
        Specifies the system alias of the component.

    .EXAMPLE
        Get-LockpathComponentByAlias -ComponentAlias 'Controls'

    .EXAMPLE
        Get-LockpathComponentByAlias 'Controls'

    .EXAMPLE
        'Controls' | Get-LockpathComponentByAlias

    .EXAMPLE
        'Controls', 'AuthorityDocs', 'AwarenessEvents' | Get-LockpathComponentByAlias

    .EXAMPLE
        $componentObject | Get-LockpathComponentByAlias
        If $componentObject has an property called ComponentAlias that value is automatically passed as a parameter.

    .INPUTS
        String

    .OUTPUTS
        String

    .NOTES
        Native API Request: https://[InstanceName]:[InstancePort]/ComponentService/GetComponentByAlias?alias=$ComponentAlias

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
        [ValidateLength(2, 64)]
        [ValidatePattern('^_?[A-Za-z]{1}[_A-Za-z0-9]+$')]
        [String] $ComponentAlias
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

        $restParameters = [ordered]@{
            'Description' = "Getting Component with Alias $ComponentAlias"
            'Method'      = 'GET'
            'Query'       = "?Alias=$ComponentAlias"
            'Service'     = $service
            'UriFragment' = 'GetComponentByAlias'
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
