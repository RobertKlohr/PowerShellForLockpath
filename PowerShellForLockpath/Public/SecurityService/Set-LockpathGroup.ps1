function Set-LockpathGroup {
    <#
    .SYNOPSIS
        Updates a group.

    .DESCRIPTION
        Updates a group.  All attributes that are updated are overwritten with the new value.

        The Git repo for this module can be found here: https://github.com/RobertKlohr/PowerShellForLockpath

    .PARAMETER Attributes
        The list of fields and values to change as an array.

        The list of attributes must include the Id field and the group Id as the value for the group being updated.

    .EXAMPLE
        Set-LockpathGroup -Attributes @{'Id' = '7'; 'Name' = 'API Update Group'}

    .EXAMPLE
        Set-LockpathGroup -Attributes @{'Id' = '7'; 'Name' = 'API Update Group'; 'Users' = @(@{'Id'= '6'},@{'Id'= '10'}}

    .INPUTS
        System.Array

    .OUTPUTS
        String

    .NOTES
        Native API Request: https://[InstanceName]:[InstancePort]/SecurityService/UpdateGroup

        The authentication account must have Read and Update Administrative Access permissions to administer groups.

    .LINK
        https://github.com/RobertKlohr/PowerShellForLockpath/wiki
    #>

    [CmdletBinding(
        ConfirmImpact = 'High',
        PositionalBinding = $false,
        SupportsShouldProcess = $true)]
    [OutputType('System.String')]

    param(
        [Parameter(
            Mandatory = $true,
            Position = 0,
            ValueFromPipeline = $true,
            ValueFromPipelineByPropertyName = $true)]
        [Array] $Attributes
    )

    begin {
        $level = 'Information'
        $functionName = ($PSCmdlet.CommandRuntime.ToString())
        $service = 'SecurityService'
    }

    process {
        Write-LockpathInvocationLog -Confirm:$false -WhatIf:$false -FunctionName $functionName -Level $level -Service $service

        $params = @{
            'Body'        = $Attributes | ConvertTo-Json -Depth $Script:LockpathConfig.jsonConversionDepth
            'Description' = 'Updating Group'
            'Method'      = 'POST'
            'Service'     = $service
            'UriFragment' = 'UpdateGroup'
        }

        $target = "Properties=$($params.Body)"

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
