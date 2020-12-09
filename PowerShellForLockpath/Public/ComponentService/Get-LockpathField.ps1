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
        $level = 'Information'
        $functionName = ($PSCmdlet.CommandRuntime.ToString())
        $service = 'ComponentService'
    }

    process {
        Write-LockpathInvocationLog -Confirm:$false -WhatIf:$false -FunctionName $functionName -Level $level -Service $service

        $params = @{
            'Description' = 'Getting Field By Id'
            'Method'      = 'GET'
            'Query'       = "?Id=$FieldId"
            'Service'     = $service
            'UriFragment' = 'GetField'
        }

        $target = "Id=$FieldId"

        if ($PSCmdlet.ShouldProcess($target)) {
            try {
                $result = Invoke-LockpathRestMethod @params
                $message = 'success'
            } catch {
                $message = 'failed'
                $level = 'Warning'
            }
            Write-LockpathLog -Confirm:$false -WhatIf:$false -Message $message -FunctionName $functionName -Level $level -Service $service
            If ($message -eq 'failed') {
                return $message
            } else {
                return $result
            }
        }
    }

    end {
    }
}
