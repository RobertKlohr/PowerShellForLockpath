﻿function Set-LockpathRecordVote {
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
        $level = 'Information'
        $functionName = ($PSCmdlet.CommandRuntime.ToString())
        $service = 'ComponentService'
    }

    process {
        Write-LockpathInvocationLog -Confirm:$false -WhatIf:$false -FunctionName $functionName -Level $level -Service $service

        $Body = [ordered]@{
            'tableAlias'     = $ComponentAlias # There is an inconsistency in the API that requires the the tableAlias (componentAlias) instead of the componentId.
            'recordId'       = $RecordId
            'transitionId'   = $TransitionId
            'votingComments' = $VotingComments
        }

        # TODO update so this can take the component ID as well as the alias see also Set-LockpathRecordTransitio

        $params = @{
            'Body'        = $Body | ConvertTo-Json -Depth $Script:LockpathConfig.jsonConversionDepth
            'Description' = 'Voting Record'
            'Method'      = 'POST'
            'Service'     = $service
            'UriFragment' = 'VoteRecord'
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
