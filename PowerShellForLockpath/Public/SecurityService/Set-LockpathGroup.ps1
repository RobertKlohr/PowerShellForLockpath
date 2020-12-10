function Set-LockpathGroup {
    <#
    .SYNOPSIS
        Updates a group.

    .DESCRIPTION
        Updates a group.  All attributes that are updated are overwritten with the new value.

        The Git repo for this module can be found here: https://git.io/powershellforlockpath

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
        https://git.io/powershellforlockpathhelp
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

        $restParameters = [ordered]@{
            'Body'        = $Attributes | ConvertTo-Json -Depth $Script:LockpathConfig.jsonConversionDepth
            'Description' = 'Updating Group'
            'Method'      = 'POST'
            'Service'     = $service
            'UriFragment' = 'UpdateGroup'
        }

        $logParameters = [ordered]@{
            'Confirm'      = $false
            'WhatIf'       = $false
            'Message'      = $message
            'FunctionName' = $functionName
            'Level'        = $level
            'Service'      = $service
        }

        $shouldProcessTarget = "Properties=$($restParameters.Body)"

        if ($PSCmdlet.ShouldProcess($shouldProcessTarget)) {
            try {
                $result = Invoke-LockpathRestMethod @restParameters
                $message = 'success'
            } catch {
                $result = $_.ErrorDetails.Message.Split('"')[3]
                $logParameters.message = 'failed'
                $logParameters.level = 'Warning'
            } finally {
                Write-LockpathLog @logParameters
            }
            return $result
        }
    }

    end {
    }
}
