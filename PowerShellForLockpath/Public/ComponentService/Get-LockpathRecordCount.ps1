function Get-LockpathRecordCount {
    <#
    .SYNOPSIS
        Return the number of records in a given component.

    .DESCRIPTION
        Return the number of records in a given component. A filter may be applied to return the count of records
        meeting a given criteria. This function may be used to help determine the amount of records before
        retrieving the records themselves.

        The Git repo for this module can be found here: https://github.com/RobertKlohr/PowerShellForLockpath

    .PARAMETER ComponentId
        Specifies the Id number of the component.

    .PARAMETER Filter
        The filter parameters the groups must meet to be included.

        Remove the filter to return a list of all groups.

    .EXAMPLE
        Get-LockpathRecordCount -ComponentId 3

    .EXAMPLE
        Get-LockpathRecordCount 3

    .EXAMPLE
        Get-LockpathRecordCount -ComponentId 3 -Filter @{'FieldPath'= @(84); 'FilterType'='1'; 'Value'='Test'}

    .INPUTS
        System.Array

    .OUTPUTS
        System.Int64

    .NOTES
        Native API Request: https://[InstanceName]:[InstancePort]/ComponentService/GetRecordCount

        The authentication account must have Read Administrative Access permissions to administer users.

    .LINK
        https://github.com/RobertKlohr/PowerShellForLockpath/wiki
    #>

    [CmdletBinding(
        ConfirmImpact = 'Low',
        PositionalBinding = $false,
        SupportsShouldProcess = $true)]
    [OutputType('System.Int64')]

    param(
        [Parameter(
            Mandatory = $true,
            Position = 0)]
        [ValidateRange('Positive')]
        [Int64] $ComponentId,

        [Array] $Filter = @()
    )

    begin {
        $level = 'Information'
        $functionName = ($PSCmdlet.CommandRuntime.ToString())
        $service = 'ComponentService'
    }

    process {
        Write-LockpathInvocationLog -Confirm:$false -WhatIf:$false -FunctionName $functionName -Level $level -Service $service

        $Body = [ordered]@{
            'componentId' = $ComponentId
            'filters'     = $Filter
        }

        $params = @{
            'Body'        = $Body | ConvertTo-Json -Depth $Script:LockpathConfig.jsonConversionDepth
            'Description' = 'Getting Record County By Filter'
            'Method'      = 'POST'
            'Service'     = $service
            'UriFragment' = 'GetRecordCount'
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
