function Set-LockpathRecordVote {
    <#
    .SYNOPSIS
        Casts a vote for a record in a workflow stage.

    .DESCRIPTION
        Casts a vote for a record in a workflow stage. The vote is automatically attributed to the account used to authenticate the API call.

        The Git repo for this module can be found here: https://github.com/RobertKlohr/PowerShellForLockpath

    .PARAMETER ComponentAlias
        Specifies the system alias of the component.

    .PARAMETER RecordId
        Specifies the Id number of the record.

        The record Id may be found by using Get-LockpathRecords.

    .PARAMETER TransitionId
        Specifies the Id number of the workflow stage transition.

        The field Id may be found by using Get-LockpathWorkflow.

    .PARAMETER VotingComments
        Specifies the voting comments.

    .EXAMPLE
        Set-LockpathRecordVote -ComponentAlias 'Vendors' -RecordId 301 -TransitionId 61 -VotingComments 'voting comment'
    .INPUTS
        String, System.UInt32

    .OUTPUTS
        String

    .NOTES
        Native API Request: https://[InstanceName]:[InstancePort]/ComponentService/VoteRecord

        The authentication account must have Read and Update General Access permissions for the specific component,
        and record as well as View and Vote workflow stage permissions.

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
        [Int64] $TransitionId,

        [Parameter(
            # Mandatory = $true,
            Position = 0,
            ValueFromPipeline = $true,
            ValueFromPipelineByPropertyName = $true)]
        [ValidateLength(1, 2048)]
        [String] $VotingComments
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
            'Body'        = $Body | ConvertTo-Json -Depth $Script:configuration.jsonConversionDepth
        }

        if ($PSCmdlet.ShouldProcess("Voting on record with: $([environment]::NewLine) component alias $ComponentAlias, record Id: $RecordId using transition Id: $TransitionId and voting comments: $VotingComments", "component alias $ComponentAlias, record Id: $RecordId using transition Id: $TransitionId and voting comments: $VotingComments", 'Voting on record with:')) {
            [String] $result = Invoke-LockpathRestMethod @params -Confirm:$false
            return $result
        } else {
            Write-LockpathLog -Message "$($PSCmdlet.CommandRuntime.ToString()) ShouldProcess confirmation was denied." -Level Verbose -Confirm:$false -WhatIf:$false
        }
    }

    end {
    }
}
