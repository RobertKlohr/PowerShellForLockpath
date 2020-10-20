function Get-LockpathGroup {
    <#
.SYNOPSIS
    Gets the group record from the Lockpath platform.
.DESCRIPTION
    Gets the group record based on the Id parameter and returns it as a JSON string.
.PARAMETER GroupId
    Specifies the Id number of the group as a positive integer.
.EXAMPLE
    C:\PS>
    Get-LockpathGroup -GroupId 2
.EXAMPLE
    C:\PS>
    Get-LockpathGroup 2
.EXAMPLE
    C:\PS>
    2 | Get-LockpathGroup
.EXAMPLE
    C:\PS>
    2,8,9 | Get-LockpathGroup
.EXAMPLE
    C:\PS>
    $userObject | Get-LockpathGroup
    If $userObject has an property called GroupId that value is automatically passed as a parameter.
.INPUTS
    System.Uint32.
    Unsigned 32-bit integer.
    Object that has a property named GroupId or Id that is an unsigned 32-bit integer.
.OUTPUTS
    System.String.
    Get-LockpathGroup returns a user record formatted as a JSON string.
.NOTES
    General notes
.COMPONENT
    Lockpath
.ROLE
    Administrator
.FUNCTIONALITY
    The functionality that best describes this cmdlet
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
        [Alias("id")]
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
            Write-LockpathLog -Message "ShouldProcess confirmation was denied." -Level Verbose -Confirm:$false -WhatIf:$false
        }
    }

    end {
    }
}
