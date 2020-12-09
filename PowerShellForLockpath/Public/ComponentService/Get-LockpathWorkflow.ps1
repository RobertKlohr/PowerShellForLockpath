function Get-LockpathWorkflow {
    <#
    .SYNOPSIS
        Retrieves workflow details and all workflow stages specified by Id.

    .DESCRIPTION
        Retrieves workflow details and all workflow stages specified by Id. The Id for a workflow may be found by
        using Get-LockpathWorkflows.

        The Git repo for this module can be found here: https://github.com/RobertKlohr/PowerShellForLockpath

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
        https://github.com/RobertKlohr/PowerShellForLockpath/wiki
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
        Write-LockpathInvocationLog -Confirm:$false -WhatIf:$false -FunctionName $functionName -Level $level -Service $service

        $params = @{
            'Description' = 'Getting Workflow By Id'
            'Method'      = 'GET'
            'Query'       = "?Id=$WorkflowId"
            'Service'     = $service
            'UriFragment' = 'GetWorkflow'
        }

        $target = "Filter=$($params.Body)"

        if ($PSCmdlet.ShouldProcess($target)) {
            try {
                $result = Invoke-LockpathRestMethod @params
                $message = 'success'
            } catch {
                $message = 'failed'
                $level = 'Warning'
            }
            Write-LockpathLog -Confirm:$false -WhatIf:$false -Message $message -FunctionName $functionName -Level $level -Service $service
            If ($message -eq 'failed') {
                return $message
            } else {
                return $result
            }
        }
    }

    end {
    }
}
