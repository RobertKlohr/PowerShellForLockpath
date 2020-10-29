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
        The type of the value stored in the Name property on InputObject.  Used to validate
        that the property has a valid value.

    .PARAMETER DefaultValue
        The value to return if Name doesn't exist on InputObject or is of an invalid type.

    .EXAMPLE
        Resolve-function Resolve-LockpathConfigurationPropertyValue -InputObject $config -Name instancePort -Type unit -DefaultValue 4443

        Checks $config to see if it has a property named "instancePort".  If it does, and it's a
        unit, returns that value, otherwise, returns 4443 (the DefaultValue).

    .INPUTS
        System.String

    .OUTPUTS
        System.String

    .NOTES
        Internal-only helper method.

    .LINK
        https://github.com/RobertKlohr/PowerShellForLockpath/wiki
    #>

    [CmdletBinding(
        ConfirmImpact = 'Low',
        PositionalBinding = $false,
        SupportsShouldProcess = $true)]

    [Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSShouldProcess', '', Justification = 'Methods called within here make use of PSShouldProcess, and the switch is passed on to them inherently.')]

    param(
        [Parameter(
            Mandatory = $true,
            ValueFromPipeline = $true,
            ValueFromPipelineByPropertyName = $true)]
        [Alias('Object')]
        [PSCustomObject] $InputObject,

        [Parameter(
            Mandatory = $true,
            ValueFromPipeline = $true,
            ValueFromPipelineByPropertyName = $true)]
        [Alias('Property')]
        [string] $Name,

        [Parameter(
            Mandatory = $true,
            ValueFromPipeline = $true,
            ValueFromPipelineByPropertyName = $true)]
        [ValidateSet('Boolean', 'Int32', 'Int64', 'PSCredential', 'String', 'String[]', 'Uint32')]
        [String] $Type,

        [Parameter(
            Mandatory = $true,
            ValueFromPipeline = $true,
            ValueFromPipelineByPropertyName = $true)]
        $DefaultValue
    )

    if ($null -eq $InputObject) {
        return $DefaultValue
    }

    switch (${Type}) {
        'Boolean' {
            $typeType = [Boolean]; break
        }
        'Int32' {
            $typeType = [Int32]; break
        }
        'Int64' {
            $typeType = [Int64]; break
        }
        'PSCredential' {
            $typeType = [PSCredential]; break
        }
        'String' {
            $typeType = [String]; break
        }
        'String[]' {
            $typeType = [String[]]; break
        }
        'Uint32' {
            $typeType = [Uint32]; break
        }
        Default {}
    }

    if (Test-LockpathConfigurationPropertyExists -InputObject $InputObject -Name $Name) {
        if ($InputObject.$Name -is $typeType) {
            return $InputObject.$Name
        } else {
            Write-LockpathInvocationLog "The locally cached $Name configuration was not of type $Type.  Reverting to default value." -Level Warning
            return $DefaultValue
        }
    } else {
        return $DefaultValue
    }
}
