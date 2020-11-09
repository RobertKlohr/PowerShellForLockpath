function New-LockpathRecord {
    <#
    .SYNOPSIS
        Create a new record within the specified component of the application.

    .DESCRIPTION
        Create a new record within the specified component of the application. The API does not check for or
        enforce mandatory fields in a record. It is possible to pass an empty array for the attribute parameter to
        create an empty record.

        The Git repo for this module can be found here: https://github.com/RobertKlohr/PowerShellForLockpath

    .PARAMETER ComponentId
        Specifies the Id number of the component.

    .PARAMETER Attributes
        The list of fields and values to add as an array.

    .EXAMPLE
        New-LockpathRecord -ComponentId 10066 -Attributes @{key = 1417; value = '_ API New Vendor'}, @{key = 8159; value = 'true'}, @{key = 9396; value = '12/25/2018'}

    .INPUTS
        String, System.Uint32

    .OUTPUTS
        String

    .NOTES
        Native API Request: https://[InstanceName]:[InstancePort]/ComponentService/CreateRecord

        The authentication account must have Read and Create General Access permissions for the specific component
        and record along with Update General Access to the fields.

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
        [Array] $Attributes
    )

    begin {
        Write-LockpathInvocationLog -Confirm:$false -WhatIf:$false
    }

    process {
        $params = @{
            'UriFragment' = 'ComponentService/CreateRecord'
            'Method'      = 'POST'
            'Description' = "Creating in component Id: $ComponentId with attributes $($Attributes | ConvertTo-Json -Depth 10 -Compress)"
            'Body'        = [ordered]@{
                'componentId'   = $ComponentId
                'dynamicRecord' = @{'FieldValues' = $Attributes
                }
            } | ConvertTo-Json -Depth 10 -Compress
        }

        if ($PSCmdlet.ShouldProcess("Creating record in: $([environment]::NewLine) component Id $ComponentId with attributes $($params.Body)", "component Id $ComponentId with attributes $($params.Body)", 'Creating record in:')) {
            [String] $result = Invoke-LockpathRestMethod @params -Confirm:$false
            return $result
        } else {
            Write-LockpathLog -Message "$($PSCmdlet.CommandRuntime.ToString()) ShouldProcess confirmation was denied." -Level Verbose -Confirm:$false -WhatIf:$false
        }
    }

    end {
    }
}
