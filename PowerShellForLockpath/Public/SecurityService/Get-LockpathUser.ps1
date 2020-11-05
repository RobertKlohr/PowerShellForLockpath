function Get-LockpathUser {
    <#
    .SYNOPSIS
        Returns available fields for a given user.

    .DESCRIPTION
        Returns available fields for a given user. The user Id may be found by using Get-LockpathUsers.

        The Git repo for this module can be found here: https://github.com/RobertKlohr/PowerShellForLockpath

    .PARAMETER UserId
        Specifies the Id number of the user as a positive integer.

    .EXAMPLE
        Get-LockpathUser -UserId 6

    .EXAMPLE
        Get-LockpathUser 6

    .EXAMPLE
        6 | Get-LockpathUser

    .EXAMPLE
        6,12,15 | Get-LockpathUser

    .EXAMPLE
        $userObject | Get-LockpathUser
        If $userObject has an property called UserId that value is automatically passed as a parameter.

    .INPUTS
        System.Uint32

    .OUTPUTS
        String

    .NOTES
        Native API Request: https://[InstanceName]:[InstancePort]/SecurityService/GetUser?Id=$UserId

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
        [Int64] $UserId
    )

    begin {
        Write-LockpathInvocationLog -Confirm:$false -WhatIf:$false

    }

    process {
        $params = @{
            'UriFragment' = "SecurityService/GetUser?Id=$UserId"
            'Method'      = 'GET'
            'Description' = "Getting user record with Id: $UserId"
        }

        if ($PSCmdlet.ShouldProcess("Getting user with Id: $([environment]::NewLine) $UserId", $UserId, 'Getting user with Id:')) {
            [String] $result = Invoke-LockpathRestMethod @params -Confirm:$false
            return $result
        } else {
            Write-LockpathLog -Message "$($PSCmdlet.CommandRuntime.ToString()) ShouldProcess confirmation was denied." -Level Verbose -Confirm:$false -WhatIf:$false
        }
    }

    end {
    }
}
