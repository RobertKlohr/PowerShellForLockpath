function Set-LockpathRecord {
    <#
    .SYNOPSIS
        Update fields in a specified record.

    .DESCRIPTION
        Update fields in a specified record.

        The Git repo for this module can be found here: https://github.com/RobertKlohr/PowerShellForLockpath

    .PARAMETER ComponentId
        Specifies the Id number of the component.

    .PARAMETER RecordId
        Specifies the Id number of the record.

    .PARAMETER Attributes
        The list of fields and values to change as an array.

    .EXAMPLE
        Set-LockpathRecord -ComponentId 10066 -RecordId 3 -Attributes @{key = 1418; value = 'API Update to Description'}, @{key = 8159; value = 'true'}, @{key = 9396; value = '12/25/2018'}, @{key = 7950; value = '999'}

    .INPUTS
        String, System.UInt32

    .OUTPUTS
        String

    .NOTES
        Native API Request: https://[InstanceName]:[InstancePort]/ComponentService/UpdateRecord

        The authentication account must have Read and Update General Access permissions for the specific component,
        record and field.

    .LINK
        https://github.com/RobertKlohr/PowerShellForLockpath/wiki
    #>

    [CmdletBinding(
        ConfirmImpact = 'Medium',
        PositionalBinding = $false,
        SupportsShouldProcess = $true)]
    [OutputType('System.String')]

    param(
        [Parameter(Mandatory = $true,
            ValueFromPipeline = $true,
            ValueFromPipelineByPropertyName = $true)]
        [ValidateRange('Positive')]
        [Int64] $ComponentId,

        [Parameter(Mandatory = $true,
            ValueFromPipeline = $true,
            ValueFromPipelineByPropertyName = $true)]
        [ValidateRange('Positive')]
        [Int64] $RecordId,

        [Parameter(Mandatory = $true,
            ValueFromPipeline = $true,
            ValueFromPipelineByPropertyName = $true)]
        [Array] $Attributes
    )

    begin {
        $level = 'Information'
        $functionName = ($PSCmdlet.CommandRuntime.ToString())
        $service = 'ComponentService'
    }

    process {
        Write-LockpathInvocationLog -Confirm:$false -WhatIf:$false -FunctionName $functionName -Level $level -Service $service

        $Body = [ordered]@{
            'componentId'   = $ComponentId
            'dynamicRecord' = [ordered]@{'Id' = $RecordId
                'FieldValues'                 = $Attributes
            }
        }

        $params = @{
            'Body'        = $Body | ConvertTo-Json -Depth $Script:LockpathConfig.jsonConversionDepth
            'Description' = 'Updating Record'
            'Method'      = 'POST'
            'Service'     = $service
            'UriFragment' = 'UpdateRecord'
        }

        $target = "Filter=$($params.Body)"

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
