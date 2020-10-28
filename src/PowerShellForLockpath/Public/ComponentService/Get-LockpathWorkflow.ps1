function Get-LockpathWorkflow {
    <#
    .SYNOPSIS
        Retrieves workflow details and all workflow stages specified by Id.

    .DESCRIPTION
        Retrieves workflow details and all workflow stages specified by Id. The Id for a workflow may be found by
        using Get-LockpathWorkflows.

        The Git repo for this module can be found here: https://github.com/RobertKlohr/PowerShellForLockpath

    .PARAMETER WorkflowId
        Specifies the Id number of the workflow as a positive integer.

    .EXAMPLE
        Get-LockpathWorkflow -WorkflowId 57

    .EXAMPLE
        Get-LockpathWorkflow 57

    .EXAMPLE
        $workflowObject | Get-LockpathWorkflow
        If $workflowObject has an property called WorkflowId that value is automatically passed as a parameter.

    .INPUTS
        System.Uint32

    .OUTPUTS
        System.String

    .NOTES
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
        [Alias('Id')]
        [ValidateRange('Positive')]
        [uint] $WorkflowId
    )

    begin {
        Write-LockpathInvocationLog -Confirm:$false -WhatIf:$false
    }

    process {
        $params = @{
            'UriFragment' = "ComponentService/GetWorkflow?Id=$WorkflowId"
            'Method'      = 'GET'
            'Description' = "Getting Workflow with Workflow Id: $WorkflowId"
        }

        if ($PSCmdlet.ShouldProcess("Getting workflow with Id: $([environment]::NewLine) $WorkflowId", $WorkflowId, 'Getting workflow with Id:')) {
            [string] $result = Invoke-LockpathRestMethod @params -Confirm:$false
            return $result
        } else {
            Write-LockpathLog -Message "$($PSCmdlet.CommandRuntime.ToString()) ShouldProcess confirmation was denied." -Level Verbose -Confirm:$false -WhatIf:$false
        }
    }

    end {
    }
}
