function Test-LockpathConfigurationPropertyExists {
    [CmdletBinding(SupportsShouldProcess)]

    [Diagnostics.CodeAnalysis.SuppressMessageAttribute("PSShouldProcess", "", Justification = "Methods called within here make use of PSShouldProcess, and the switch is passed on to them inherently.")]

    param(
        [Parameter(Mandatory)]
        [AllowNull()]
        $InputObject,

        [Parameter(Mandatory)]
        [String] $Name
    )

    return (($null -ne $InputObject) -and
        ($null -ne (Get-Member -InputObject $InputObject -Name $Name -MemberType Properties)))
}
