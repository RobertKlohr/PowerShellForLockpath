# Copyright (c) Robert Klohr. All rights reserved.
# Licensed under the MIT License.

function New-LockpathRecord {
    <#
    .SYNOPSIS
        Create a new record within the specified component of the application.

    .DESCRIPTION
        Create a new record within the specified component of the application. The API does not check for or
        enforce mandatory fields in a record. It is possible to pass an empty array for the attribute parameter to
        create an empty record.

        The Git repo for this module can be found here: https://git.io/powershellforlockpath

    .PARAMETER ComponentId
        Specifies the Id number of the component.

    .PARAMETER Attributes
        The list of fields and values to add as an array.

    .EXAMPLE
        New-LockpathRecord -ComponentId 10066 -Attributes @{key = 1417; value = '_ API New Vendor'}, @{key = 8159; value = 'true'}, @{key = 9396; value = '12/25/2018'}

    .INPUTS
        String, System.UInt32

    .OUTPUTS
        String

    .NOTES
        Native API Request: https://[InstanceName]:[InstancePort]/ComponentService/CreateRecord

        The authentication account must have Read and Create General Access permissions for the specific component
        and record along with Update General Access to the fields.

    .LINK
        https://git.io/powershellforlockpathhelp
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
        $level = 'Information'
        $functionName = ($PSCmdlet.CommandRuntime.ToString())
        $service = 'ComponentService'
    }

    process {
        if ($Script:LockpathConfig.loggingLevel -eq 'Debug') {
            Write-LockpathInvocationLog -Confirm:$false -WhatIf:$false -FunctionName $functionName -Level $level -Service $service
        }

        $Body = [ordered]@{
            'componentId'   = $ComponentId
            'dynamicRecord' = @{'FieldValues' = $Attributes
            }
        }

        $restParameters = [ordered]@{
            'Body'        = $Body | ConvertTo-Json -Depth $Script:LockpathConfig.jsonConversionDepth
            'Description' = 'Creating Record'
            'Method'      = 'POST'
            'Service'     = $service
            'UriFragment' = 'CreateRecord'
        }

        $logParameters = [ordered]@{
            'Confirm'      = $false
            'WhatIf'       = $false
            'Message'      = $message
            'FunctionName' = $functionName
            'Level'        = $level
            'Service'      = $service
        }

        $shouldProcessTarget = "Filter=$($restParameters.Body)"

        if ($PSCmdlet.ShouldProcess($shouldProcessTarget)) {
            try {
                [string] $result = Invoke-LockpathRestMethod @restParameters
                $logParameters.message = 'success'
            } catch {

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
