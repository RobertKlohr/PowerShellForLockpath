function Resolve-PropertyValue {
    [CmdletBinding()]
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
    if ($Type -eq 'Boolean') {
        $typeType = [Boolean]
    }
    if ($Type -eq 'Int32') {
        $typeType = [Int32]
    }
    if ($Type -eq 'Int64') {
        $typeType = [Int64]
    }

    if (Test-PropertyExists -InputObject $InputObject -Name $Name) {
        if ($InputObject.$Name -is $typeType) {
            return $InputObject.$Name
        } else {
            Write-Log "The locally cached $Name configuration was not of type $Type.  Reverting to default value." -Level Warning
            return $DefaultValue
        }
    } else {
        return $DefaultValue
    }
}
