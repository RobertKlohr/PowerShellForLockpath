﻿function New-LockpathGroup {
    <#
    .SYNOPSIS
        Creates a group.

    .DESCRIPTION
        Creates a group. The Name attribute is required when creating a group.

        The Git repo for this module can be found here: https://github.com/RobertKlohr/PowerShellForLockpath

    .PARAMETER Attributes
        The list of fields and values to change as an array.

    .EXAMPLE
        New-LockpathGroup -Attributes @{'Name' = 'API New Group'}

    .INPUTS
        System.Array

    .OUTPUTS
        String

    .NOTES
        Native API Request: https://[InstanceName]:[InstancePort]/SecurityService/CreateGroup

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
        Write-LockpathInvocationLog -Confirm:$false -WhatIf:$false -Service SecurityService
    }

    process {

        $params = @{
            'UriFragment' = 'SecurityService/CreateGroup'
            'Method'      = 'POST'
            'Description' = "Creating group with attributes $($Attributes | ConvertTo-Json -Depth $Script:LockpathConfig.jsonConversionDepth -Compress)"
            'Body'        = $Attributes | ConvertTo-Json -Depth $Script:LockpathConfig.jsonConversionDepth
        }

        if ($PSCmdlet.ShouldProcess("Creating group with attributes: $([environment]::NewLine) $($params.Body)", "$($params.Body)", 'Creating group with attributes:')) {
            [String] $result = Invoke-LockpathRestMethod @params -Confirm:$false
            return $result
        } else {
            Write-LockpathLog -Confirm:$false -WhatIf:$false -Message 'ShouldProcess confirmation was denied.' -Level Verbose -FunctionName ($PSCmdlet.CommandRuntime.ToString()) -Service ReportService
        }
    }

    end {
    }
}
