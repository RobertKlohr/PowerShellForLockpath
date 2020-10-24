﻿function Remove-LockpathGroup {
    <#
    .SYNOPSIS
        Deletes a group.

    .DESCRIPTION
        Deletes a group. This is a soft delete that hides the group from the user interface and API by changing the
        permissions on the group. It also does not remove members from the group. To undelete a group requires a support request.

    .PARAMETER GroupId
        Specifies the Id number of the group as a positive integer.

    .EXAMPLE
        Remove-LockpathGroup -GroupId 6

    .EXAMPLE
        Remove-LockpathGroup 6

    .EXAMPLE
        6 | Remove-LockpathGroup

    .EXAMPLE
        6,7,8 | Remove-LockpathGroup

    .EXAMPLE
        $groupObject | Remove-LockpathGroup
        If $groupObject has an property called GroupId that value is automatically passed as a parameter.

    .INPUTS
        System.Uint32

    .OUTPUTS
        System.String

    .NOTES
        The authentication account must have Read and Delete Administrative Access permissions to administer groups.

    .LINK
        https://github.com/RobertKlohr/PowerShellForLockpath
    #>

    [CmdletBinding(
        ConfirmImpact = 'High',
        PositionalBinding = $false,
        SupportsShouldProcess = $true)]
    [OutputType('System.String')]

    param(
        [Parameter(
            Mandatory = $true,
            Position = 0,
            ValueFromPipeline = $true,
            ValueFromPipelineByPropertyName = $true)]
        [Alias("Id")]
        [ValidateRange("Positive")]
        [int] $GroupId
    )

    begin {
        Write-LockpathInvocationLog -Confirm:$false -WhatIf:$false
    }

    process {
        $params = @{
            'UriFragment' = 'SecurityService/DeleteGroup'
            'Method'      = 'DELETE'
            'Description' = "Deleting group with Id: $GroupId"
            'Body'        = $GroupId | ConvertTo-Json
        }
        if ($PSCmdlet.ShouldProcess("Deleting group with Id: $([environment]::NewLine) $GroupId", $GroupId, 'Deleting group with Id:')) {
            $result = Invoke-LockpathRestMethod @params -Confirm:$false
            return $result
        } else {
            Write-LockpathLog -Message "$($PSCmdlet.CommandRuntime.ToString()) ShouldProcess confirmation was denied." -Level Verbose -Confirm:$false -WhatIf:$false
        }
    }

    end {
    }
}
