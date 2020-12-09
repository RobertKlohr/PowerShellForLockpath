function Get-LockpathGroups {
    <#
    .SYNOPSIS
        Returns a list of groups and available fields.

    .DESCRIPTION
        Returns a list of groups and available fields.

        The Git repo for this module can be found here: https://github.com/RobertKlohr/PowerShellForLockpath

    .PARAMETER PageIndex
        The index of the page of result to return.

        If not set it defaults to the value set in the configuration.

    .PARAMETER PageSize
        The size of the page results to return.

        If not set it defaults to the value set in the configuration.

    .PARAMETER Filter
        The filter parameters the groups must meet to be included.

        Remove the filter to return a list of all groups.

    .EXAMPLE
        Get-LockpathGroups

    .EXAMPLE
        Get-LockpathGroups -PageIndex 0 -PageSize 100

    .EXAMPLE
        Get-LockpathGroups -Filter @{'Field'= @{'ShortName'='BusinessUnit'}; 'FilterType'='5'; 'Value'='False'}

    .EXAMPLE
        Get-LockpathGroups -PageIndex 0 -PageSize 100 -Filter @{'Field'= @{'ShortName'='BusinessUnit'}; FilterType'='5'; 'Value'='False'}

    .INPUTS
        System.Array, System.UInt32

    .OUTPUTS
        String

    .NOTES
        Native API Request: https://[InstanceName]:[InstancePort]/SecurityService/GetGroups

        The authentication account must have Read Administrative Access permissions to administer groups.

    .LINK
        https://github.com/RobertKlohr/PowerShellForLockpath/wiki
    #>

    [CmdletBinding(
        ConfirmImpact = 'Low',
        PositionalBinding = $false,
        SupportsShouldProcess = $true)]
    [OutputType('System.String')]


    [Parameter(
        Mandatory = $true,
        Position = 0,
        ValueFromPipeline = $true,
        ValueFromPipelineByPropertyName = $true)]


    param(
        [ValidateRange('NonNegative')]
        [Int32] $PageIndex = $Script:LockpathConfig.pageIndex,

        [ValidateRange('Positive')]
        [Int32] $PageSize = $Script:LockpathConfig.pageSize,

        [Parameter(
            Position = 0,
            ValueFromPipeline = $true,
            ValueFromPipelineByPropertyName = $true)]
        [Array] $Filter = @()
    )

    begin {
        $level = 'Information'
        $functionName = ($PSCmdlet.CommandRuntime.ToString())
        $service = 'SecurityService'
    }

    process {

        Write-LockpathInvocationLog -Confirm:$false -WhatIf:$false -FunctionName $functionName -Level $level -Service $service

        $Body = [ordered]@{
            'pageIndex' = $PageIndex
            'pageSize'  = $PageSize
        }

        If ($Filter.Count -gt 0) {
            $Body.Add('filters', $Filter)
        }

        $params = @{
            'Body'        = $Body | ConvertTo-Json -Depth $Script:LockpathConfig.jsonConversionDepth
            'Description' = 'Getting Groups By Filter'
            'Method'      = 'POST'
            'Service'     = $service
            'UriFragment' = 'GetGroups'
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
