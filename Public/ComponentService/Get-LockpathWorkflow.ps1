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
                $result = $_.ErrorDetails.Message.Split('"')[3]
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
