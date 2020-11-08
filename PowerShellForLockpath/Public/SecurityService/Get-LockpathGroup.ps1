function Get-LockpathGroup {
    <#
    .SYNOPSIS
        Returns available fields for a given group.

    .DESCRIPTION
        Returns available fields for a given group. The group Id may be found by using Get-LockpathGroups.

        The Git repo for this module can be found here: https://github.com/RobertKlohr/PowerShellForLockpath

    .PARAMETER GroupId
        Specifies the Id number of the group.

    .EXAMPLE
        Get-LockpathGroup -GroupId 2

    .EXAMPLE
        Get-LockpathGroup 2

    .EXAMPLE
        2 | Get-LockpathGroup

    .EXAMPLE
        2,8,9 | Get-LockpathGroup

    .EXAMPLE
        $userObject | Get-LockpathGroup

        If $userObject has an property called GroupId that value is automatically passed as a parameter.

    .INPUTS
        System.Uint32

    .OUTPUTS
        String

    .NOTES
        Native API Request: https://[InstanceName]:[InstancePort]/SecurityService/GetGroup?Id=$GroupId

        The authentication account must have Read Administrative Access permissions to administer users.

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
        [ValidateRange('NonNegative')]
        [Int64] $GroupId
    )

    begin {
        Write-LockpathInvocationLog -Confirm:$false -WhatIf:$false
    }

    process {
        $params = @{
            'UriFragment' = "SecurityService/GetGroup?Id=$GroupId"
            'Method'      = 'GET'
            'Description' = "Getting group record with Id: $GroupId"
        }

        if ($PSCmdlet.ShouldProcess("Getting group with Id: $([environment]::NewLine) $GroupId", $GroupId, 'Getting group with Id:')) {
            [String] $result = Invoke-LockpathRestMethod @params -Confirm:$false
            return $result
        } else {
            Write-LockpathLog -Message "$($PSCmdlet.CommandRuntime.ToString()) ShouldProcess confirmation was denied." -Level Verbose -Confirm:$false -WhatIf:$false
        }
    }

    end {
    }
}
