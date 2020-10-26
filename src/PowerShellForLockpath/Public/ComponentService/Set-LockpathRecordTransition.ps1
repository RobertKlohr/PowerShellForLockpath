﻿function Set-LockpathRecordTransition {
    <#
    .SYNOPSIS
        Transitions a record in a workflow.

    .DESCRIPTION
        Transitions a record in a workflow.

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
        System.Uint32, System.String

    .OUTPUTS
        System.String

    .NOTES
        The authentication account must have Read and Update General Access permissions for the specific component,
        and record as well as View and Transition workflow stage permissions.

        There is an inconsistency in the API that requires the the tableAlias (componentAlias) instead of the componentId.

    .LINK
        https://github.com/RobertKlohr/PowerShellForLockpath
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
        # [uint] $ComponentId,

        [Parameter(
            Mandatory = $true,
            Position = 0,
            ValueFromPipeline = $true,
            ValueFromPipelineByPropertyName = $true)]
        [Alias("Alias")]
        [ValidateLength(1, 256)]
        [string] $ComponentAlias,

        [Parameter(
            Mandatory = $true,
            ValueFromPipeline = $true,
            ValueFromPipelineByPropertyName = $true)]
        [Alias("Record")]
        [ValidateRange("Positive")]
        [uint] $RecordId,

        [Parameter(
            Mandatory = $true,
            ValueFromPipeline = $true,
            ValueFromPipelineByPropertyName = $true)]
        [Alias("Transition")]
        [ValidateRange("Positive")]
        [uint] $TransitionId
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
            $result = Invoke-LockpathRestMethod @params -Confirm:$false
            return $result
        } else {
            Write-LockpathLog -Message "$($PSCmdlet.CommandRuntime.ToString()) ShouldProcess confirmation was denied." -Level Verbose -Confirm:$false -WhatIf:$false
        }
    }

    end {
    }
}
