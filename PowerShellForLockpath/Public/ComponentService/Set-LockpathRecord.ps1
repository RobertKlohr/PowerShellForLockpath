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
        The list of fields and values to change as an array. The field names in the array are case sensitive.

    .EXAMPLE
        Set-LockpathRecord -ComponentId 10066 -RecordId 3 -Attributes @{key = 1418; value = 'API Update to Description'}, @{key = 8159; value = 'true'}, @{key = 9396; value = '12/25/2018'}, @{key = 7950; value = '999'}

    .INPUTS
        String, System.Uint32

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
        Write-LockpathInvocationLog -Confirm:$false -WhatIf:$false
    }

    process {
        $params = @{
            'UriFragment' = 'ComponentService/UpdateRecord'
            'Method'      = 'POST'
            'Description' = "Updating fields in record Id: $RecordId in component Id: $ComponentId with attributes $($Attributes | ConvertTo-Json -Depth 10 -Compress)"
            'Body'        = [ordered]@{
                'componentId'   = $ComponentId
                'dynamicRecord' = [ordered]@{'Id' = $RecordId
                    'FieldValues'                 = $Attributes
                }
            } | ConvertTo-Json -Depth 10 -Compress
        }

        if ($PSCmdlet.ShouldProcess("Updating fields with: $([environment]::NewLine) component Id $ComponentId & record Id: $RecordId & attributes $($params.Body)", "component Id $ComponentId, record Id: $RecordId & attributes $($params.Body)", 'Updating fields with:')) {
            [String] $result = Invoke-LockpathRestMethod @params -Confirm:$false
            return $result
        } else {
            Write-LockpathLog -Message "$($PSCmdlet.CommandRuntime.ToString()) ShouldProcess confirmation was denied." -Level Verbose -Confirm:$false -WhatIf:$false
        }
    }

    end {
    }
}
