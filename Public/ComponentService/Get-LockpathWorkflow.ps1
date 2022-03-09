# Copyright (c) Robert Klohr. All rights reserved.
# Licensed under the MIT License.

function Get-LockpathWorkflow {
    <#
    .SYNOPSIS
        Retrieves workflow details and all workflow stages specified by Id.

    .DESCRIPTION
        Retrieves workflow details and all workflow stages specified by Id. The Id for a workflow may be found by
        using Get-LockpathWorkflows.

        The Git repo for this module can be found here: https://git.io/powershellforlockpath

    .PARAMETER WorkflowId
        Specifies the Id number of the workflow.

    .EXAMPLE
        Get-LockpathWorkflow -WorkflowId 57

    .EXAMPLE
        Get-LockpathWorkflow 57

    .EXAMPLE
        $workflowObject | Get-LockpathWorkflow
        If $workflowObject has an property called WorkflowId that value is automatically passed as a parameter.

    .INPUTS
        System.UInt32

    .OUTPUTS
        String

    .NOTES
        Native API Request: https://[InstanceName]:[InstancePort]/ComponentService/GetWorkflow?Id=$WorkflowId

        The authentication account must have Read Administrative Access permissions for the specific component
        containing the workflow.

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
            Position = 0,
            ValueFromPipeline = $true,
            ValueFromPipelineByPropertyName = $true)]
        [ValidateRange('Positive')]
        [Int64] $WorkflowId
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
        if ($Script:LockpathConfig.loggingLevel -eq 'Debug') {
            Write-LockpathInvocationLog -Confirm:$false -WhatIf:$false -FunctionName $functionName -Level $level -Service $service
        }

        $restParameters = [ordered]@{
            'Description' = 'Getting Workflow By Id'
            'Method'      = 'GET'
            'Query'       = "?Id=$WorkflowId"
            'Service'     = $service
            'UriFragment' = 'GetWorkflow'
        }

        $shouldProcessTarget = "Filter=$($restParameters.Body)"

        if ($PSCmdlet.ShouldProcess($shouldProcessTarget)) {
            try {
                [string] $result = Invoke-LockpathRestMethod @restParameters
                $logParameters.message = 'success: ' + $restParameters.Description + ' with ' + $shouldProcessTarget
                try {
                    $logParameters.result = (ConvertFrom-Json -InputObject $result) | ConvertTo-Json -Compress
                } catch {
                    $logParameters.result = 'Unable to convert API response.'
                }
            } catch {
                $logParameters.Level = 'Error'
                $logParameters.Message = 'failed: ' + $restParameters.Description + ' with ' + $shouldProcessTarget
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
