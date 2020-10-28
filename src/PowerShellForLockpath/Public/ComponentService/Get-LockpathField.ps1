function Get-LockpathField {
    <#
    .SYNOPSIS
        Returns details for a fields specified by it's Id.

    .DESCRIPTION
        Returns available fields for a given component. The field Id may be found by using Get-LockpathFieldList.

        The Git repo for this module can be found here: https://github.com/RobertKlohr/PowerShellForLockpath

    .PARAMETER FieldId
        Specifies the Id number of the field as a positive integer.

    .EXAMPLE
        Get-LockpathField -FieldId 7

    .EXAMPLE
        Get-LockpathField 7

    .EXAMPLE
        7 | Get-LockpathField

    .EXAMPLE
        7,8,9 | Get-LockpathField

    .EXAMPLE
        $fieldObject | Get-LockpathField
        If $fieldObject has an property called FieldId that value is automatically passed as a parameter.

    .INPUTS
        System.Uint32

    .OUTPUTS
        System.String

    .NOTES
        The authentication account must have Read General Access permissions for the specific component and field.

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
        [uint] $FieldId
    )

    begin {
        Write-LockpathInvocationLog -Confirm:$false -WhatIf:$false
    }

    process {
        $params = @{
            'UriFragment' = "ComponentService/GetField?Id=$FieldId"
            'Method'      = 'GET'
            'Description' = "Getting Field with Field Id: $FieldId"
        }

        if ($PSCmdlet.ShouldProcess("Getting field with Id: $([environment]::NewLine) $FieldId", $FieldId, 'Getting field with Id:')) {
            [string] $result = Invoke-LockpathRestMethod @params -Confirm:$false
            return $result
        } else {
            Write-LockpathLog -Message "$($PSCmdlet.CommandRuntime.ToString()) ShouldProcess confirmation was denied." -Level Verbose -Confirm:$false -WhatIf:$false
        }
    }

    end {
    }
}
