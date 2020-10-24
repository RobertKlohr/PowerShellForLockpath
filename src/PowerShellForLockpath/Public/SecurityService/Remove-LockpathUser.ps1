function Remove-LockpathUser {
    <#
    .SYNOPSIS
        Deletes a user account.

    .DESCRIPTION
        Deletes a user account. To inactive a user account use Set-LockpathUser. To undelete an account you must
        use the platform interface.

    .PARAMETER UserId
        Specifies the Id number of the user as a positive integer.

    .EXAMPLE
        Remove-LockpathUser -UserId 6

    .EXAMPLE
        Remove-LockpathUser 6

    .EXAMPLE
        6 | Remove-LockpathUser

    .EXAMPLE
        6,12,15 | Remove-LockpathUser

    .EXAMPLE
        $userObject | Remove-LockpathUser
        If $userObject has an property called UserId that value is automatically passed as a parameter.

    .INPUTS
        System.Uint32

    .OUTPUTS
        System.String

    .NOTES
        The authentication account must have Read and Delete Administrative Access permissions to administer users.
        For vendor contacts, the authentication account can alternatively have Read and Delete General Access to
        Vendor Profiles.

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
        [ValidateRange("NonNegative")]
        [int] $UserId
    )

    begin {
        Write-LockpathInvocationLog -Confirm:$false -WhatIf:$false
    }

    process {
        $params = @{
            'UriFragment' = 'SecurityService/DeleteUser'
            'Method'      = 'DELETE'
            'Description' = "Deleting User with User Id: $UserId"
            'Body'        = $UserId | ConvertTo-Json
        }
        if ($PSCmdlet.ShouldProcess("Deleting user with Id: $([environment]::NewLine) $UserId", $UserId, 'Deleting user with Id:')) {
            $result = Invoke-LockpathRestMethod @params -Confirm:$false
            return $result
        } else {
            Write-LockpathLog -Message "$($PSCmdlet.CommandRuntime.ToString()) ShouldProcess confirmation was denied." -Level Verbose -Confirm:$false -WhatIf:$false
        }
    }

    end {
    }
}
