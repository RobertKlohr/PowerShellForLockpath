function Find-LpField {
    [CmdletBinding()]
    [OutputType([int])]

    param(
        # Name of field attribute
        [Parameter(Mandatory = $true, ValueFromPipeline = $true)]
        [string]
        $FieldAttributeName,
        # Value to match against the field attribute
        [Parameter(Mandatory = $true, ValueFromPipeline = $true)]
        [string]
        $FieldAttributeValue
    )

    begin {
        $Return = @()
    }

    process {
        $Components = Get-LpComponentList
        foreach ($Component in $Components) {
            $Fields = Get-LpFieldList -ComponentId $Component.Id
            foreach ($Field in $Fields) {
                if ($Field.$FieldAttributeName -eq $FieldAttributeValue) {
                    $Table = [ordered]@{
                        ComponentName      = $Component.Name
                        ComponentShortname = $Component.Shortname
                        ComponentId        = $Component.Id
                        FieldName          = $Field.Name
                        FieldShortName     = $Field.ShortName
                        FieldId            = $Field.Id
                        FieldType          = $Field.FieldType
                        FieldReadOnly      = $Field.ReadOnly
                        FieldRequired      = $Field.Required
                        FieldOneToMany     = $Field.OneToMany
                        FieldMatrixRows    = $Field.MatrixRows
                    }
                    $Return += $Table
                }
            }
        }
    }
    end {
        Return $Return
    }
}
