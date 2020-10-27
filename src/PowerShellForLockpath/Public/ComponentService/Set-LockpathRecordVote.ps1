function Set-LockpathRecordVote {
    <#
    .SYNOPSIS
        Casts a vote for a record in a workflow stage.

    .DESCRIPTION
        Casts a vote for a record in a workflow stage. The vote is automatically attributed to the account used to authenticate the API call.

    .PARAMETER ComponentAlias
        Specifies the system alias of the component as a string.

    .PARAMETER RecordId
        Specifies the Id number of the record as a positive integer. The record Id may be found by using
        Get-LockpathRecords.

    .PARAMETER TransitionId
        Specifies the Id number of the workflow stage transition as a positive integer. The field Id may be found
        by using Get-LockpathWorkflow.

    .PARAMETER VotingComments
        Specifies the voting comments as a string.

    .EXAMPLE
        Set-LockpathRecordVote -ComponentAlias 'Vendors' -RecordId 301 -TransitionId 61 -VotingComments 'voting comment'
    .INPUTS
        System.String, System.Uint32

    .OUTPUTS
        System.String

    .NOTES
        The authentication account must have Read and Update General Access permissions for the specific component,
        and record as well as View and Vote workflow stage permissions.

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
        [uint] $TransitionId,

        [Parameter(
            # Mandatory = $true,
            Position = 0,
            ValueFromPipeline = $true,
            ValueFromPipelineByPropertyName = $true)]
        [Alias("Comments")]
        [ValidateLength(1, 4096)]
        [string] $VotingComments
    )

    begin {
        Write-LockpathInvocationLog -Confirm:$false -WhatIf:$false
    }

    process {
        $Body = [ordered]@{
            'tableAlias'     = $ComponentAlias # There is an inconsistency in the API that requires the the tableAlias (componentAlias) instead of the componentId.
            'recordId'       = $RecordId
            'transitionId'   = $TransitionId
            'votingComments' = $VotingComments
        }

        $params = @{
            'UriFragment' = 'ComponentService/VoteRecord'
            'Method'      = 'POST'
            'Description' = "Voting on record with Id: $RecordId in component with alias: $ComponentAlias using transition Id: $TransitionId and voting comments: $VotingComments"
            'Body'        = $Body | ConvertTo-Json -Depth 10
        }

        if ($PSCmdlet.ShouldProcess("Voting on record with: $([environment]::NewLine) component alias $ComponentAlias, record Id: $RecordId using transition Id: $TransitionId and voting comments: $VotingComments", "component alias $ComponentAlias, record Id: $RecordId using transition Id: $TransitionId and voting comments: $VotingComments", 'Voting on record with:')) {
            [string] $result = Invoke-LockpathRestMethod @params -Confirm:$false
            return $result
        } else {
            Write-LockpathLog -Message "$($PSCmdlet.CommandRuntime.ToString()) ShouldProcess confirmation was denied." -Level Verbose -Confirm:$false -WhatIf:$false
        }
    }

    end {
    }
}
