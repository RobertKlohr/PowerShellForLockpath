function Find-LpField {
    <#
        .SYNOPSIS
            Query Lockpath field meta data.

        .DESCRIPTION
            Accepts a field attribute and values and searches all the accessible fields for a match to the query

        .EXAMPLE
            Find-LpField -FieldAttributeName "alias" -FieldAttributeValue "Title"

        .INPUTSget-
            The Microsoft .NET Framework types of objects that can be piped to the function or script.
            You can also include a description of the input objects.

        .OUTPUTS
            The .NET Framework type of the objects that the cmdlet returns.
            You can also include a description of the returned objects.

        .NOTES
            Additional information about the function or script.

        .LINK
            Online Version: https://github.com/RjKGitHub/PowerShellForLockpath/

        .COMPONENT
            SecurityServices
            Lockpath

        .ROLE
            The user role for the help topic.
            This content appears when the Get-Help command includes the Role parameter of Get-Help.

        .FUNCTIONALITY
            The intended use of the function.
            This content appears when the Get-Help command includes the Functionality parameter of Get-Help.
    #>

    #TODO: Complete Initial function setup
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
