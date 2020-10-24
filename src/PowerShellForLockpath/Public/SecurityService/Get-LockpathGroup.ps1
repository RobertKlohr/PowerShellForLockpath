function Get-LockpathGroup {
    <#
    .SYNOPSIS
        Returns available fields for a given group.
    .DESCRIPTION
        Returns available fields for a given group. The group Id may be found by using Get-LockpathGroups.
    .PARAMETER GroupId
        Specifies the Id number of the group as a positive integer.
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
        System.String
    .NOTES
        The authentication account must have Read Administrative Access permissions to administer users.
    .LINK
        https://github.com/RobertKlohr/PowerShellForLockpath
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
        [Alias("Id")]
        [ValidateRange("NonNegative")]
        [uint]      $GroupId
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
            $result = Invoke-LockpathRestMethod @params -Confirm:$false
            return $result
        } else {
            Write-LockpathLog -Message "$($PSCmdlet.CommandRuntime.ToString()) ShouldProcess confirmation was denied." -Level Verbose -Confirm:$false -WhatIf:$false
        }
    }

    end {
    }
}
