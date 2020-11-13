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
        Resolve-function Resolve-LockpathConfigurationPropertyValue -InputObject $config -Name instancePort -Type UInt16 -DefaultValue 4443

        Checks $config to see if it has a property named "instancePort".  If it does, and it's a UInt16, returns that Value, otherwise, returns 4443 (the DefaultValue).

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
        [ValidateSet('ArrayList', 'Boolean', 'Hashtable', 'Int16', 'Int32', 'Int64', 'PSCredential', 'PSObject', 'String', 'String[]')]
        [String] $Type,

        [Parameter(Mandatory = $true)]
        $DefaultValue
    )

    #Write-LockpathInvocationLog -Confirm:$false -WhatIf:$false

    if ($null -eq $InputObject) {
        return $DefaultValue
    }
    try {
        switch (${Type}) {
            'ArrayList' {
                $typeType = [System.Collections.ArrayList]
                break
            }
            'Boolean' {
                $typeType = [Boolean]
                break
            }
            'Hashtable' {
                $typeType = [Hashtable]
                break
            }
            'Int16' {
                $typeType = [Int16]
                break
            }
            'Int32' {
                $typeType = [Int32]
                break
            }
            'Int64' {
                $typeType = [Int64]
                break
            }
            'PSCredential' {
                $typeType = [PSCredential]
                break
            }
            'PSObject' {
                $typeType = [PSObject]
                break
            }
            'String' {
                $typeType = [String]
                break
            }
            'String[]' {
                $typeType = [String[]]
                break
            }
            Default {}
        }
        if (
            ($null -ne $InputObject) -and
            ($null -ne (Get-Member -InputObject $InputObject -Name $Name -MemberType Properties))
        ) {
            if ($InputObject.$Name -is $typeType) {
                return $true
            } else {
                Write-LockpathInvocationLog -Confirm:$false -WhatIf:$false
                Write-LockpathLog -Message "The stored $Name configuration setting of '$($InputObject.$Name)' was not of type $Type.  Reverting to default value of $DefaultValue." -Level Warning
                return $false
            }
        } else {
            return $false
        }
    } catch {
        Write-LockpathInvocationLog -Confirm:$false -WhatIf:$false
        Write-LockpathLog -Message "The stored $Name configuration setting of '$($InputObject.$Name)' was not of type $Type.  Reverting to default value of $DefaultValue." -Level Warning
        return $false
    }
}
