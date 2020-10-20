function Get-LockpathUser {
    <#
.SYNOPSIS
    Gets the user record from the Lockpath platform.
.DESCRIPTION
    Gets the user record based on the Id parameter and returns it as a JSON string.
.PARAMETER UserId
    Specifies the Id number of the user as a positive integer.
.EXAMPLE
    C:\PS>
    Get-LockpathUser -UserId 6
.EXAMPLE
    C:\PS>
    Get-LockpathUser 6
.EXAMPLE
    C:\PS>
    6 | Get-LockpathUser
.EXAMPLE
    C:\PS>
    6,12,15 | Get-LockpathUser
.EXAMPLE
    C:\PS>
    $userObject | Get-LockpathUser
    If $userObject has an property called userid that value is automatically passed as a parameter.
.INPUTS
    System.Uint32.
    Unsigned 32-bit integer.
    Object that has a property named UserId or Id that is an unsigned 32-bit integer.
.OUTPUTS
    System.String.
    Get-LockpathUser returns a user record formatted as a JSON string.
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
    # [Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSShouldProcess', '', Justification = 'Methods called within here make use of PSShouldProcess, and the switch is passed on to them inherently.')]

    param(
        [Parameter(
            Mandatory = $true,
            Position = 0,
            ValueFromPipeline = $true)]
        [Alias("id")]
        [ValidateRange("NonNegative")]
        [int] $UserId
    )

    begin {
        Write-LockpathInvocationLog -Confirm:$false -whatif:$false
    }

    process {
        $params = @{
            'UriFragment' = "SecurityService/GetUser?Id=$UserId"
            'Method'      = 'GET'
            'Description' = "Getting user record with Id: $UserId"
        }
        if ($PSCmdlet.ShouldProcess($UserId)) {
            $result = Invoke-LockpathRestMethod @params -Confirm:$false
            return $result
        } else {
            Write-LockpathLog -Message "ShouldProcess confirmation was denied." -Level Verbose -Confirm:$false -whatif:$false
        }
    }

    end {
    }
}
