function Get-LockpathComponent {
    <#
    .SYNOPSIS
        Returns information about a component specified by its Id.

    .DESCRIPTION
        Returns information about a component specified by its Id.

        Returns the Id, Name, SystemName and ShortName for the component.

        The Git repo for this module can be found here: https://github.com/RobertKlohr/PowerShellForLockpath

    .PARAMETER ComponentId
        Specifies the Id number of the component.

        The component Id may be found by using Get-LockpathComponentList.

    .EXAMPLE
        Get-LockpathComponent -ComponentId 2

    .EXAMPLE
        Get-LockpathComponent 2

    .INPUTS
        System.UInt32

    .OUTPUTS
        {
            "Id": 10050, "Name": "Incident Reports",
            "SystemName": "LPIncidentReports",
            "ShortName": "LPIncidentReports"
        }

    .NOTES
        Native API Request: https://[InstanceName]:[InstancePort]/ComponentService/GetComponent?id=$ComponentId

        The authentication account must have Read General Access permissions for the specific component.

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
        [Int64] $ComponentId
    )

    begin {
        $level = 'Information'
        $functionName = ($PSCmdlet.CommandRuntime.ToString())
        $service = 'ComponentService'
    }

    process {
        Write-LockpathInvocationLog -Confirm:$false -WhatIf:$false -FunctionName $functionName -Level $level -Service $service

        $params = @{
            'Description' = 'Getting Component By Id'
            'Method'      = 'GET'
            'Query'       = "?Id=$ComponentId"
            'Service'     = $service
            'UriFragment' = 'GetComponent'
        }

        $target = "Id=$ComponentId"

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
