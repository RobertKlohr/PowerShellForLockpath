function Get-LockpathUser {
    <#
    .SYNOPSIS
        Returns available fields for a given user.

    .DESCRIPTION
        Returns available fields for a given user. The user Id may be found by using Get-LockpathUsers.

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
        [int] $UserId
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
            [string] $result = Invoke-LockpathRestMethod @params -Confirm:$false
            return $result
        } else {
            Write-LockpathLog -Message "$($PSCmdlet.CommandRuntime.ToString()) ShouldProcess confirmation was denied." -Level Verbose -Confirm:$false -WhatIf:$false
        }
    }

    end {
    }
}
