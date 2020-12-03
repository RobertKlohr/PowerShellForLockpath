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

    Write-LockpathInvocationLog -Confirm:$false -WhatIf:$false

    $Body = @{
        'componentId' = $ComponentId
        'filters'     = $Filter
    }

    $params = @{
        'UriFragment' = 'ComponentService/GetRecordCount'
        'Method'      = 'POST'
        'Description' = "Getting record count with filter: $($Filter | ConvertTo-Json -Depth $Script:LockpathConfig.jsonConversionDepth -Compress)"
        'Body'        = $Body | ConvertTo-Json -Depth $Script:LockpathConfig.jsonConversionDepth
    }

    if ($PSCmdlet.ShouldProcess("Getting record count for: $([environment]::NewLine) component Id: $ComponentId, record Id: $RecordId & filter $($params.Body)", "component Id: $ComponentId, record Id: $RecordId & filter $($params.Body)", 'Getting record count for:')) {
        [String] $result = Invoke-LockpathRestMethod @params -Confirm:$false
        return $result
    } else {
        Write-LockpathLog -Message "$($PSCmdlet.CommandRuntime.ToString()) ShouldProcess confirmation was denied." -Level Verbose -Confirm:$false -WhatIf:$false
    }
}
