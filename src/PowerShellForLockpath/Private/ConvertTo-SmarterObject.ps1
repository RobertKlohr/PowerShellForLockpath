function ConvertTo-SmarterObject {
    [CmdletBinding()]
    param(
        [Parameter(
            Mandatory,
            ValueFromPipeline,
            ValueFromPipelineByPropertyName)]
        [AllowNull()]
        [object] $InputObject
    )

    Write-InvocationLog

    if ($null -eq $InputObject) {
        return $null
    }

    if ($InputObject -is [System.Collections.IList]) {
        $InputObject |
        ConvertTo-SmarterObject |
        Write-Output
    } elseif ($InputObject -is [PSCustomObject]) {
        $clone = DeepCopy-Object -InputObject $InputObject
        $properties = $clone.PSObject.Properties | Where-Object { $null -ne $_.Value }
        foreach ($property in $properties) {
            # Convert known date properties from dates to real DateTime objects
            if (($property.Name -in $script:datePropertyNames) -and
                ($property.Value -is [String]) -and
                (-not [String]::IsNullOrWhiteSpace($property.Value))) {
                try {
                    $property.Value = Get-Date -Date $property.Value
                } catch {
                    Write-Log -Message "Unable to convert $($property.Name) value of $($property.Value) to a [DateTime] object.  Leaving as-is." -Level Verbose
                }
            }

            if ($property.Value -is [System.Collections.IList]) {
                $property.Value = @(ConvertTo-SmarterObject -InputObject $property.Value)
            } elseif ($property.Value -is [PSCustomObject]) {
                $property.Value = ConvertTo-SmarterObject -InputObject $property.Value
            }
        }

        Write-Output -InputObject $clone
    } else {
        Write-Output -InputObject $InputObject
    }
}
