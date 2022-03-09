# Copyright (c) Robert Klohr. All rights reserved.
# Licensed under the MIT License.

function Get-LockpathWorkflows {
    <#
    .SYNOPSIS
        Retrieves all workflows for a component specified by its Alias.

    .DESCRIPTION
        Retrieves all workflows for a component specified by its Alias. A component is a user-defined data object
        such as a custom content table. The component Alias may be found by using GetComponentList (ShortName).

        The Git repo for this module can be found here: https://git.io/powershellforlockpath

    .PARAMETER ComponentAlias
        Specifies the system alias of the component.

    .EXAMPLE
        Get-LockpathWorkflows -ComponentAlias 'Controls'

    .EXAMPLE
        Get-LockpathWorkflows 'Controls'

    .EXAMPLE
        'Controls' | Get-LockpathWorkflows

    .EXAMPLE
        'Controls', 'AuthorityDocs', 'AwarenessEvents' | Get-LockpathWorkflows

    .EXAMPLE
        $workflowObject | Get-LockpathWorkflows
        If $workflowObject has an property called ComponentAlias that value is automatically passed as a parameter.

    .INPUTS
        String

    .OUTPUTS
        String

    .NOTES
        Native API Request: https://[InstanceName]:[InstancePort]/ComponentService/GetWorkflows?componentalias=$ComponentAlias

        The authentication account must have Read Administrative Access permissions for the specific component.

    .LINK
        https://git.io/powershellforlockpathhelp
    #>

    [Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSUseSingularNouns', '', Justification = 'This cmdlets is a wrapper for an API call that uses a plural noun.')]

    [CmdletBinding(
        ConfirmImpact = 'Low',
        PositionalBinding = $false,
        SupportsShouldProcess = $true
    )]
    [OutputType('System.String')]

    param(
        [Parameter(
            Mandatory = $true,
            Position = 0,
            ValueFromPipeline = $true,
            ValueFromPipelineByPropertyName = $true)]
        [ValidateLength(1, 128)]
        [String] $ComponentAlias
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

    # TODO add ability to lookup by component Id as well as alias

    process {
        Write-LockpathInvocationLog @logParameters

        $restParameters = [ordered]@{
            'Description' = "Getting Workflows with Component Alias $ComponentAlias"
            'Method'      = 'GET'
            'Query'       = "?ComponentAlias=$ComponentAlias"
            'Service'     = $service
            'UriFragment' = 'GetWorkflows'
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
