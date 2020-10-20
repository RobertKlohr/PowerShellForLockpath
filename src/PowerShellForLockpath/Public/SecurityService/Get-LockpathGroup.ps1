function Get-LockpathGroup {
    <#
.SYNOPSIS
    Returns all fields for a given group.
.DESCRIPTION
    Returns all fields for a given group.
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
    System.Uint32.
.OUTPUTS
    System.String.
    Get-LockpathGroup returns a user record formatted as a JSON string.
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
            ValueFromPipeline = $true)]
        [Alias("Id")]
        [ValidateRange("NonNegative")]
        [int] $GroupId
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
        if ($PSCmdlet.ShouldProcess($GroupId)) {
            $result = Invoke-LockpathRestMethod @params -Confirm:$false
            return $result
        } else {
            Write-LockpathLog -Message "$($PSCmdlet.CommandRuntime.ToString()) ShouldProcess confirmation was denied." -Level Verbose -Confirm:$false -WhatIf:$false
        }
    }

    end {
    }
}
