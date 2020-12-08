function Get-LockpathField {
    <#
    .SYNOPSIS
        Returns details for a fields specified by it's Id.

    .DESCRIPTION
        Returns available fields for a given component. The field Id may be found by using Get-LockpathFieldList.

        The Git repo for this module can be found here: https://github.com/RobertKlohr/PowerShellForLockpath

    .PARAMETER FieldId
        Specifies the Id number of the field.

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
        System.UInt32

    .OUTPUTS
        String

    .NOTES
        Native API Request: https://[InstanceName]:[InstancePort]/ComponentService/GetField?Id=$FieldId

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
        [ValidateRange('Positive')]
        [Int64] $FieldId
    )

    begin {
        Write-LockpathInvocationLog -Confirm:$false -WhatIf:$false -Service ComponentService
    }

    process {
        $params = @{
            'UriFragment' = "ComponentService/GetField?Id=$FieldId"
            'Method'      = 'GET'
            'Description' = "Getting Field with Field Id: $FieldId"
        }

        if ($PSCmdlet.ShouldProcess("Getting field with Id: $([environment]::NewLine) $FieldId", $FieldId, 'Getting field with Id:')) {
            [String] $result = Invoke-LockpathRestMethod @params -Confirm:$false
            return $result
        } else {
            Write-LockpathLog -Confirm:$false -WhatIf:$false -Message 'ShouldProcess confirmation was denied.' -Level Verbose -FunctionName ($PSCmdlet.CommandRuntime.ToString()) -Service ComponentService
        }
    }

    end {
    }
}
