﻿function Find-LockpathField {
    <#
    .SYNOPSIS
        Returns all field details for selected fields based on the applied filter.

    .DESCRIPTION
        Returns all field details for selected fields based on the applied filter.

        Combines Get-LpComponentList, Get-LockpathComponent, Get-LpFieldList and Get-LockpathField.

        There is no filtering provided in this function (beyond limiting the list of components) as the API does
        not support filtering for retrieving any of the information used in this method meaning.  The impact of
        this is that there is no performance advantage to applying filtering to this method and instead using
        PowerShell to manipulate the response object provides both better performance and capabilities.

        The Git repo for this module can be found here: https://github.com/RobertKlohr/PowerShellForLockpath

    .PARAMETER ComponentIds
        Specifies an array of component Id numbers.

        This can be used to limit the components used in retrieving the field details thereby increaseing performance.

    .EXAMPLE
        Find-LockpathField

        Returns all field details from all fields in all components.

    .EXAMPLE
        Find-LockpathField -ComponentId @(10066,10031)

        Returns all field details from all fields in components with Id 10066 and 10013.

    .INPUTS
        System.Collections.Hashtable

    .OUTPUTS
        String

    .NOTES
        The authentication account must have Read Administrative Access permissions for the specific component.

    .LINK
        https://github.com/RobertKlohr/PowerShellForLockpath/wiki
    #>

    [CmdletBinding(
        ConfirmImpact = 'Low',
        PositionalBinding = $false,
        SupportsShouldProcess = $true)]
    [OutputType('System.String')]

    param(
        [Array] $ComponentIds
    )

    Write-LockpathInvocationLog -Confirm:$false -WhatIf:$false

    # If a list of component Ids was not provided we will get the entire list from the platform.
    if (!$ComponentIds) {
        $ComponentIds = Get-LockpathComponentList | ConvertFrom-Json -AsHashtable | Select-Object -ExpandProperty Id
    }

    $result = @()
    # TODO add progress bar here
    $componentCounter = 1
    foreach ($componentId in $ComponentIds) {
        # get the component details
        $componentDetails = Get-LockpathComponent -ComponentId $componentId | ConvertFrom-Json -Depth 10 -AsHashtable
        # get the list of field Ids in the component
        $fieldIds = Get-LockpathFieldList -ComponentId $componentId | ConvertFrom-Json -Depth 10 -AsHashtable | Select-Object -ExpandProperty Id
        Write-Progress -Id 0 -Activity "Getting fields for component $componentCounter of $($ComponentIds.Count)" -Status "Get fields for component: $($componentDetails.Name)" -PercentComplete ($componentCounter / $ComponentIds.Count * 100)
        $componentCounter += 1
        $fieldCounter = 1
        foreach ($fieldId in $fieldIds) {
            # get the field details
            $fieldDetails = Get-LockpathField -FieldId $fieldId | ConvertFrom-Json -Depth 10 -AsHashtable
            # combine field details and component details into a an ordered dictionary
            $fieldFullDetails = [ordered]@{
                'FieldId'             = $fieldDetails.Id
                'FiledName'           = $fieldDetails.Name
                'FieldShortName'      = $fieldDetails.ShortName
                'FieldSystemName'     = $fieldDetails.SystemName
                'FieldReadOnly'       = $fieldDetails.ReadOnly
                'FieldRequired'       = $fieldDetails.Required
                'FieldFieldType'      = $fieldDetails.FieldType
                'FieldOneToMany'      = $fieldDetails.OneToMany
                'FieldMatrixRows'     = $fieldDetails.MatrixRows.ForEach(
                    { Param($Id, $Name)
                        [ordered]@{Id = $_.$Id; Name = $_.$Name }
                    }, 'Id', 'Name')
                'ComponentId'         = $componentDetails.Id
                'ComponentName'       = $componentDetails.Name
                'ComponentShortName'  = $componentDetails.ShortName
                'ComponentSystemName' = $componentDetails.SystemName
            }
            # add all the details into an array object
            [Array] $result += $fieldFullDetails
            Write-Progress -Id 1 -ParentId 0 -Activity "Get field details for field $fieldCounter of $($fieldIds.Count)" -Status "Getting details for field: $($fieldDetails.Name)" -PercentComplete ($fieldCounter / $fieldIds.Count * 100)
            $fieldCounter += 1
        }
    }
    Write-Progress -Completed
    return $result
}
