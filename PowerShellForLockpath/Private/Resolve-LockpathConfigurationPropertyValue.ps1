function Resolve-LockpathConfigurationPropertyValue {
    <#
    .SYNOPSIS
        Returns the requested property from the provided object, if it exists and is a valid
        value.  Otherwise, returns the default value.

    .DESCRIPTION
        Returns the requested property from the provided object, if it exists and is a valid
        value.  Otherwise, returns the default value.

        The Git repo for this module can be found here: https://github.com/RobertKlohr/PowerShellForLockpath

    .PARAMETER InputObject
        The object to check the value of the requested property.

    .PARAMETER Name
        The name of the property on InputObject whose value is desired.

    .PARAMETER Type
        The type of the value stored in the Name property on InputObject.  Used to validate that the property has a
        valid value.

    .PARAMETER DefaultValue
        The value to return if Name doesn't exist on InputObject or is of an invalid type.

    .EXAMPLE
        Resolve-function Resolve-LockpathConfigurationPropertyValue -InputObject $config -Name instancePort -Type unit -DefaultValue 4443

        Checks $config to see if it has a property named "instancePort".  If it does, and it's a unit, returns that Value, otherwise, returns 4443 (the DefaultValue).

    .INPUTS
        String

    .OUTPUTS
        String

    .NOTES
        Private helper method.

    .LINK
        https://github.com/RobertKlohr/PowerShellForLockpath/wiki
    #>

    [CmdletBinding(
        ConfirmImpact = 'Low',
        PositionalBinding = $false,
        SupportsShouldProcess = $true)]

    [Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSShouldProcess', '', Justification = 'Methods called within here make use of PSShouldProcess, and the switch is passed on to them inherently.')]

    param(
        [Parameter(Mandatory = $true)]
        [PSCustomObject] $InputObject,

        [Parameter(Mandatory = $true)]
        [String] $Name,

        [Parameter(Mandatory = $true)]
        [ValidateSet('Boolean', 'CookieCollection', 'Int16', 'Int32', 'Int64', 'PSCredential', 'String', 'String[]', 'WebRequestSession')]
        [String] $Type,

        [Parameter(Mandatory = $true)]
        $DefaultValue
    )

    #Write-LockpathInvocationLog -Confirm:$false -WhatIf:$false

    # Need to adjust the datatypes for some settings since we are storing the configuration in JSON. If the
    # conversion fails in the switch statement then we have type mismatch.
    if ($null -eq $InputObject) {
        return $DefaultValue
    }
    try {
        switch (${Type}) {
            'Boolean' {
                $typeType = [Boolean]
                break
            }
            'CookieCollection' {
                $InputObject.$name = [System.Net.CookieCollection] $InputObject.$name
                break
            }
            'Int16' {
                $typeType = [Int16]
                # ConvertFrom-JSON returns all integers as type [Int64] need to type them back to [Int16]
                $InputObject.$name = [Int16] $InputObject.$name
                break
            }
            'Int32' {
                $typeType = [Int32]
                # ConvertFrom-JSON returns all integers as type [Int64] need to type them back to [Int32]
                $InputObject.$name = [Int32] $InputObject.$name
                break
            }
            'Int64' {
                $typeType = [Int64]
                break
            }
            'PSCredential' {
                InputObject.$name = [PSCredential] $InputObject.$name
                break
            }
            'String' {
                $typeType = [String]
                break
            }
            'String[]' {
                $typeType = [String[]]
                # ConvertFrom-JSON returns String arrays as object arrays all need to type them back to [String[]]
                $InputObject.$name = [String[]] $InputObject.$name
                break
            }
            'WebRequestSession' {
                $InputObject.$name = [Microsoft.PowerShell.Commands.WebRequestSession] $InputObject.$name
                break
            }
            Default {}
        }
        if (
            ($null -ne $InputObject) -and
            ($null -ne (Get-Member -InputObject $InputObject -Name $Name -MemberType Properties))
        ) {
            if ($InputObject.$Name -is $typeType) {
                return $InputObject.$Name
            } else {
                Write-LockpathInvocationLog -Confirm:$false -WhatIf:$false
                Write-LockpathLog -Message "The stored $Name configuration setting of '$($InputObject.$Name)' was not of type $Type.  Reverting to default value of $DefaultValue." -Level Warning
                return $DefaultValue
            }
        } else {
            return $DefaultValue
        }
    } catch {
        Write-LockpathInvocationLog -Confirm:$false -WhatIf:$false
        Write-LockpathLog -Message "The stored $Name configuration setting of '$($InputObject.$Name)' was not of type $Type.  Reverting to default value of $DefaultValue." -Level Warning
        return $DefaultValue
    }
}
