function Get-LockpathFieldList {
    <#
    .SYNOPSIS
        Returns detail field listing for a given component.

    .DESCRIPTION
        Returns detail field listing for a given component. A component is a user-defined data object such as a
        custom content table. The component Id may be found by using Get-LockpathComponentList. Assessments field
        type are not visible in this list.

        The Git repo for this module can be found here: https://git.io/powershellforlockpath

    .PARAMETER ComponentId
        Specifies the Id number of the component.

    .EXAMPLE
        Get-LockpathFieldList -ComponentId 2

    .EXAMPLE
        Get-LockpathFieldList 2

    .EXAMPLE
        2 | Get-LockpathFieldList

    .EXAMPLE
        2,3,6 | Get-LockpathFieldList

    .EXAMPLE
        $componentObject | Get-LockpathFieldList
        If $componentObject has an property called ComponentId that value is automatically passed as a parameter.

    .INPUTS
        System.UInt32

    .OUTPUTS
        String

    .NOTES
        Native API Request: https://[InstanceName]:[InstancePort]/ComponentService/GetFieldList?componentId=$ComponentId

        The authentication account must have Read General Access permissions for the specific component.

    .LINK
        https://git.io/powershellforlockpathhelp
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
        [Int64] $ComponentId
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

        $restParameters = [ordered]@{
            'Description' = 'Getting Field List By Component Id'
            'Method'      = 'GET'
            'Query'       = "?ComponentId=$ComponentId"
            'Service'     = $service
            'UriFragment' = 'GetFieldList'
        }

        $logParameters = [ordered]@{
            'Confirm'      = $false
            'WhatIf'       = $false
            'Message'      = $message
            'FunctionName' = $functionName
            'Level'        = $level
            'Service'      = $service
        }

        $shouldProcessTarget = "ComponentId=$ComponentId"

        if ($PSCmdlet.ShouldProcess($shouldProcessTarget)) {
            try {
                $result = Invoke-LockpathRestMethod @restParameters
                $logParameters.message = 'success'
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
