function Resolve-LockpathConfigurationPropertyValue {
    #TODO Create Help Section
    #TODO Update to new coding standards
    [CmdletBinding(
        ConfirmImpact = 'Low',
        PositionalBinding = $false,
        SupportsShouldProcess = $true)]

    [Diagnostics.CodeAnalysis.SuppressMessageAttribute("PSShouldProcess", "", Justification = "Methods called within here make use of PSShouldProcess, and the switch is passed on to them inherently.")]

    param(
        [PSCustomObject] $InputObject,

        [Parameter(Mandatory)]
        [string] $Name,

        [Parameter(Mandatory)]
        # [ValidateSet('Array', 'Boolean', 'Int32', 'Int64', 'String')]
        [String] $Type,

        $DefaultValue
    )

    if ($null -eq $InputObject) {
        return $DefaultValue
    }

    $typeType = [String]
    if ($Type -eq 'String[]') {
        $typeType = [String[]]
    }
    if ($Type -eq 'Boolean') {
        $typeType = [Boolean]
    }
    if ($Type -eq 'Int32') {
        $typeType = [Int32]
    }
    #TODO check to see if int64 is needed
    # if ($Type -eq 'Int64') {
    #     $typeType = [Int64]
    # }

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
