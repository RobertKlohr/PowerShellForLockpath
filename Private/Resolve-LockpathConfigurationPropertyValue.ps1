# Copyright (c) Robert Klohr. All rights reserved.
# Licensed under the MIT License.

function Resolve-LockpathConfigurationPropertyValue {
    <#
    .SYNOPSIS
        Returns the requested property from the provided object, if it exists and is a valid
        value.  Otherwise, returns the default value.

    .DESCRIPTION
        Returns the requested property from the provided object, if it exists and is a valid
        value.  Otherwise, returns the default value.

        The Git repo for this module can be found here: https://git.io/powershellforlockpath

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
        https://git.io/powershellforlockpathhelp
    #>

    [CmdletBinding(
        ConfirmImpact = 'Low',
        PositionalBinding = $false
    )]

    [OutputType([System.Boolean])]

    param(
        [Parameter(
            Mandatory = $true
        )]
        [PSCustomObject] $InputObject,

        [Parameter(
            Mandatory = $true
        )]
        [String] $Name,

        [Parameter(
            Mandatory = $true
        )]
        [ValidateSet('ArrayList', 'Boolean', 'Hashtable', 'Int16', 'Int32', 'PSCredential', 'PSObject', 'String', 'String[]', 'UInt16', 'UInt32')]
        [String] $Type,

        [Parameter(
            Mandatory = $true
        )]
        $DefaultValue
    )

    $level = 'Debug'
    $functionName = ($PSCmdlet.CommandRuntime.ToString())
    $service = 'PrivateHelper'

    $logParameters = [ordered]@{
        'Confirm'      = $false
        'FunctionName' = $functionName
        'Level'        = $level
        'Message'      = "Executing cmdlet: $functionName"
        'Service'      = $service
        'Result'       = "Executing cmdlet: $functionName"
        'WhatIf'       = $false
    }

    Write-LockpathInvocationLog @logParameters

    if ($null -eq $InputObject) {
        return $DefaultValue
    }
    try {
        switch ($Type) {
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
            'UInt16' {
                $typeType = [UInt16]
                break
            }
            'UInt32' {
                $typeType = [UInt32]
                break
            }
            Default {}
        }
        if (
            ($null -ne $InputObject) -and
            ($null -ne (Get-Member -InputObject $InputObject -Name $Name -MemberType Properties))
        ) {
            if ($InputObject.$Name -is $typeType) {
                $logParameters.Message = "Success: The stored $Name configuration setting of '$($InputObject.$Name)' was of type $Type."
                $logParameters.Result = 'Validated the configuration setting object type.'
                # Write-LockpathLog @logParameters
                return $true
            } else {
                $logParameters.Level = 'Error'
                $logParameters.Message = "Failed: The stored $Name configuration setting of '$($InputObject.$Name)' was not of type $Type. Reverting to default value of $DefaultValue."
                $logParameters.Result = 'Failed to validate configuration setting object type.'
                # Write-LockpathLog @logParameters
                return $false
            }
        } else {
            $logParameters.Level = 'Error'
            $logParameters.Message = "Failed: The stored $Name configuration setting of '$($InputObject.$Name)' was not of type $Type. Reverting to default value of $DefaultValue."
            $logParameters.Result = 'Failed to validate configuration setting object type.'
            # Write-LockpathLog @logParameters
            return $false
        }
    } catch {
        $logParameters.Level = 'Error'
        $logParameters.Message = "Failed: The stored $Name configuration setting of '$($InputObject.$Name)' was not of type $Type. Reverting to default value of $DefaultValue."
        $logParameters.Result = $_.Exception.Message
    } finally {
        Write-LockpathLog @logParameters
    }
    return $false
}
