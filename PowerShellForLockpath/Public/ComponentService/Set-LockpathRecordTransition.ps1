function Set-LockpathRecordTransition {
    <#
    .SYNOPSIS
        Transitions a record in a workflow.

    .DESCRIPTION
        Transitions a record in a workflow.

        The Git repo for this module can be found here: https://github.com/RobertKlohr/PowerShellForLockpath

    .PARAMETER ComponentAlias
        Specifies the system alias of the component as a string.

    .PARAMETER RecordId
        Specifies the Id number of the record as a positive integer. The record Id may be found by using
        Get-LockpathRecords.

    .PARAMETER TransitionId
        Specifies the Id number of the workflow stage transition as a positive integer. The field Id may be found
        by using Get-LockpathWorkflow.

    .EXAMPLE
        Set-LockpathRecordTransition -ComponentAlias 'Vendors' -RecordId 301 -TransitionId 61

    .INPUTS
        String, System.Uint32

    .OUTPUTS
        String

    .NOTES
        Native API Request: https://[InstanceName]:[InstancePort]/ComponentService/TransitionRecord

        The authentication account must have Read and Update General Access permissions for the specific component,
        and record as well as View and Transition workflow stage permissions.

        There is an inconsistency in the API that requires the the tableAlias (componentAlias) instead of the componentId.

    .LINK
        https://github.com/RobertKlohr/PowerShellForLockpath/wiki
    #>

    [CmdletBinding(
        ConfirmImpact = 'Medium',
        PositionalBinding = $false,
        SupportsShouldProcess = $true)]
    [OutputType('System.String')]

    param(
        #TODO Update the parameters and logic to support passing component Id in addition to component alias
        # .PARAMETER ComponentId
        #     Specifies the Id number of the component as a positive integer. The component Id may be found by using
        #     Get-LockpathComponents.

        # [Parameter(
        #     Mandatory = $true,
        #     ValueFromPipeline = $true,
        #     ValueFromPipelineByPropertyName = $true)]
        # [Alias("Component")]
        # [ValidateRange("Positive")]
        # [Int64] $ComponentId,

        [Parameter(
            Mandatory = $true,
            Position = 0,
            ValueFromPipeline = $true,
            ValueFromPipelineByPropertyName = $true)]
        [ValidateLength(1, 128)]
        [String] $ComponentAlias,

        [Parameter(Mandatory = $true,
            ValueFromPipeline = $true,
            ValueFromPipelineByPropertyName = $true)]
        [ValidateRange('Positive')]
        [Int64] $RecordId,

        [Parameter(Mandatory = $true,
            ValueFromPipeline = $true,
            ValueFromPipelineByPropertyName = $true)]
        [ValidateRange('Positive')]
        [Int64] $TransitionId
    )

    begin {
        Write-LockpathInvocationLog -Confirm:$false -WhatIf:$false
    }

    process {
        $Body = [ordered]@{
            'tableAlias'   = $ComponentAlias # There is an inconsistency in the API that requires the the tableAlias (componentAlias) instead of the componentId.
            'recordId'     = $RecordId
            'transitionId' = $TransitionId
        }

        $params = @{
            'UriFragment' = 'ComponentService/TransitionRecord'
            'Method'      = 'POST'
            'Description' = "Transitioning record with Id: $RecordId in component with alias: $ComponentAlias using transition Id: $TransitionId"
            'Body'        = $Body | ConvertTo-Json -Depth 10
        }

        if ($PSCmdlet.ShouldProcess("Transitioning record with: $([environment]::NewLine) component alias $ComponentAlias, record Id: $RecordId using transition Id: $TransitionId", "component alias $ComponentAlias, record Id: $RecordId using transition Id: $TransitionId", 'Transitioning record with:')) {
            [String] $result = Invoke-LockpathRestMethod @params -Confirm:$false
            return $result
        } else {
            Write-LockpathLog -Message "$($PSCmdlet.CommandRuntime.ToString()) ShouldProcess confirmation was denied." -Level Verbose -Confirm:$false -WhatIf:$false
        }
    }

    end {
    }
}
