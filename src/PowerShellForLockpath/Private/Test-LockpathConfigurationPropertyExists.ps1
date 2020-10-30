function Test-LockpathConfigurationPropertyExists {
    <#
    .SYNOPSIS
        Determines if an object contains a property with a specified name.

    .DESCRIPTION
        Determines if an object contains a property with a specified name.

        This is essentially using Get-Member to verify that a property exists,
        but additionally adds a check to ensure that InputObject isn't null.

    .PARAMETER InputObject
        The object to check to see if it has a property named Name.

    .PARAMETER Name
        The name of the property on InputObject that is being tested for.

    .EXAMPLE
        Test-LockpathConfigurationPropertyExists -InputObject $InputObject -instancePort

        Returns $true if $listing is non-null and has a property named 'instancePort'.
        Returns $false otherwise.

    .NOTES
        Internal-only helper method.
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
        [AllowNull()]
        [PSCustomObject] $InputObject,

        [Parameter(
            Mandatory = $true,
            ValueFromPipeline = $true,
            ValueFromPipelineByPropertyName = $true)]
        [String] $Name
    )

    #FIXME the folllowing line can be made active once defaults are set in initialize-lockpathconfiguration
    # Write-LockpathInvocationLog -Confirm:$false -WhatIf:$false

    return (($null -ne $InputObject) -and
        ($null -ne (Get-Member -InputObject $InputObject -Name $Name -MemberType Properties)))
}
