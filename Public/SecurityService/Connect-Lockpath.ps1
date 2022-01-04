# Copyright (c) Robert Klohr. All rights reserved.
# Licensed under the MIT License.

function Connect-Lockpath {
    <#
    .SYNOPSIS
        Creates an active session.

    .DESCRIPTION
        Creates an active session.

        The Git repo for this module can be found here: https://git.io/powershellforlockpath

    .PARAMETER Credential
        Specifies the PSCredential object that contains a valid username and password.

    .EXAMPLE
        Send-LockpathLogin

    .EXAMPLE
        Send-LockpathLogin -Credential $credentials

    .EXAMPLE
        Get-Credential | Send-LockpathLogin

    .INPUTS
        PSCredential object.

    .OUTPUTS
        String

    .NOTES
        Native API Request: https://[InstanceName]:[InstancePort]/SecurityService/Login

        The authentication account must have access to the API.

    .LINK
        https://git.io/powershellforlockpathhelp
    #>

    [CmdletBinding(
        ConfirmImpact = 'Low',
        PositionalBinding = $true,
        SupportsShouldProcess = $true)]
    [OutputType('System.String')]

    param(
        [Parameter(
            Mandatory = $false,
            Position = 0,
            ValueFromPipeline = $true,
            ValueFromPipelineByPropertyName = $true)]
        [PSCredential] $Credential = $Script:LockpathConfig.credential
    )

    begin {
        $service = 'SecurityService'

        $logParameters = [ordered]@{
            'FunctionName' = ($PSCmdlet.CommandRuntime.ToString())
            'Level'        = 'Information'
            'Service'      = $service
        }
    }

    process {
        if ($Script:LockpathConfig.loggingLevel -eq 'Debug') {
            Write-LockpathInvocationLog -Confirm:$false -WhatIf:$false -FunctionName $functionName -Level $level -Service $service
        }

        $hashBody = [ordered]@{
            'username' = $credential.username
            'password' = $credential.GetNetworkCredential().Password
        }

        $restParameters = [ordered]@{
            'Body'        = (ConvertTo-Json -Depth $Script:LockpathConfig.jsonConversionDepth -Compress -InputObject $hashBody)
            'Description' = "Connecting to Lockpath with username $username and password <redacted>"
            'Method'      = 'POST'
            'Service'     = $service
            'UriFragment' = 'Login'
        }

        $shouldProcessTarget = $restParameters.Description

        if ($PSCmdlet.ShouldProcess($shouldProcessTarget)) {
            try {
                $result = Invoke-LockpathRestMethod @restParameters
            } catch {
                if ($null -eq $_.ErrorDetails) {
                    $result = $_.Exception.Message
                } else {
                    $result = ($_.ErrorDetails.Message | ConvertFrom-Json).Message
                }
                $logParameters.Message = $result
                $logParameters.Level = 'Warning'
            } finally {
                if ($Script:LockpathConfig.loggingLevel -in 'Debug', 'Verbose') {
                    Write-LockpathLog @logParameters
                }
            }
            return $result
        }
    }

    end {
    }
}
