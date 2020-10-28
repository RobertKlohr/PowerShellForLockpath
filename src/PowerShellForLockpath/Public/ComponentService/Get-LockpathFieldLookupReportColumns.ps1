function Get-LockpathFieldLookupReportColumns {
    <#
    .SYNOPSIS
        Gets the field information of each field in a field path that corresponds to a lookup report column.

    .DESCRIPTION
        Gets the field information of each field in a field path that corresponds to a lookup report column. The
        lookupFieldId corresponds to a lookup field with a report definition on it and the fieldPathId corresponds
        to the field path to retrieve fields from, which is obtained from Get-LockpathRecordDetail.
        Get-LockpathFieldLookupReportColumns compliments Get-LockpathRecordDetail by adding additional details
        about the lookup report columns returned from Get-LockpathRecordDetail.

        The Git repo for this module can be found here: https://github.com/RobertKlohr/PowerShellForLockpath

    .PARAMETER FieldId
        Specifies the Id number of the field as a positive integer.

    .PARAMETER FieldPathId
        Specifies the Id number of the field path as a positive integer.

    .EXAMPLE
        Get-LockpathFieldLookupReportColumns -FieldId 2 -FieldPathId 3

    .EXAMPLE
        $fieldLookupObject | Get-LockpathFieldLookupReportColumns
        If $fieldLookupObject has an property called FieldId and FieldPathId the values are automatically passed
        as a parameter.

    .INPUTS
        System.Uint32

    .OUTPUTS
        System.String

    .NOTES
        The authentication account must have Read General Access permissions for the specific component.

    .LINK
        https://github.com/RobertKlohr/PowerShellForLockpath/wiki
    #>

    [CmdletBinding(
        ConfirmImpact = 'Low',
        PositionalBinding = $false,
        SupportsShouldProcess = $true)]
    [OutputType('System.String')]

    param(
        [Parameter(
            Mandatory = $true,
            Position = 0,
            ValueFromPipeline = $true,
            ValueFromPipelineByPropertyName = $true)]
        [Alias('Id')]
        [ValidateRange('Positive')]
        [uint] $FieldId,

        [Parameter(
            Mandatory = $true,
            Position = 0,
            ValueFromPipeline = $true,
            ValueFromPipelineByPropertyName = $true)]
        [Alias('FieldPath')]
        [ValidateRange('Positive')]
        [uint] $FieldPathId
    )

    begin {
        Write-LockpathInvocationLog -Confirm:$false -WhatIf:$false
    }

    process {
        $params = @{
            'UriFragment' = "ComponentService/GetLookupReportColumnFields?lookupFieldId=$FieldId&fieldPathId=$FieldPathId"
            'Method'      = 'GET'
            'Description' = "Getting fields from field Id: $FieldId & field path Id: $FieldPathId"
        }

        if ($PSCmdlet.ShouldProcess("Getting fields from lookupfield with: $([environment]::NewLine) field Id: $FieldId & field path Id: $FieldPathId", "field Id: $FieldId & field path Id: $FieldPathId", 'Getting fields from lookupfield with:')) {
            [string] $result = Invoke-LockpathRestMethod @params -Confirm:$false
            return $result
        } else {
            Write-LockpathLog -Message "$($PSCmdlet.CommandRuntime.ToString()) ShouldProcess confirmation was denied." -Level Verbose -Confirm:$false -WhatIf:$false
        }
    }

    end {
    }
}
