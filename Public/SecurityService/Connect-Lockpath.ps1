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
        Connect-LockpathLogin

    .EXAMPLE
        Connect-LockpathLogin -Credential $credentials

    .EXAMPLE
        Get-Credential | Connect-LockpathLogin

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
        SupportsShouldProcess = $true
    )]

    [OutputType([System.String])]

    param(
        [Parameter(
            Mandatory = $false,
            Position = 0,
            ValueFromPipeline = $true,
            ValueFromPipelineByPropertyName = $true
        )]
        [PSCredential] $Credential = $Script:LockpathConfig.credential
    )

    begin {
        $level = 'Information'
        $functionName = ($PSCmdlet.CommandRuntime.ToString())
        $service = 'SecurityService'

        $logParameters = [ordered]@{
            'Confirm'      = $false
            'FunctionName' = $functionName
            'Level'        = $level
            'Message'      = "Executing cmdlet: $functionName"
            'Service'      = $service
            'Result'       = "Executing cmdlet: $functionName"
            'WhatIf'       = $false
        }
    }

    process {
        Write-LockpathInvocationLog @logParameters

        $hashBody = [ordered]@{
            'username' = $credential.username
            'password' = $credential.GetNetworkCredential().Password
        }

        $restParameters = [ordered]@{
            'Body'        = (ConvertTo-Json -Compress -Depth $Script:LockpathConfig.conversionDepth -InputObject $hashBody)
            'Description' = "Connecting to API with username $username and password <redacted>"
            'Method'      = 'POST'
            'Service'     = $service
            'UriFragment' = 'Login'
        }

        $shouldProcessTarget = $restParameters.Description

        if ($PSCmdlet.ShouldProcess($shouldProcessTarget)) {
            try {
                [string] $result = Invoke-LockpathRestMethod @restParameters
                # the following extra check is needed as the API returns HTTP 200 regardless of
                # authentication success
                if ($result -eq 'true') {
                    $logParameters.message = 'success: ' + $shouldProcessTarget
                } else {
                    $logParameters.message = 'failed: ' + $shouldProcessTarget
                    $logParameters.Level = 'Error'
                }
                if ($Script:LockpathConfig.logRequestBody) {
                    try {
                        $logParameters.result = (ConvertFrom-Json -InputObject $result) | ConvertTo-Json -Compress
                    } catch {
                        $logParameters.result = 'Unable to convert API response.'
                    }
                } else {
                    $logParameters.result = 'Response includes a body: <message body logging disabled>'
                }
            } catch {
                $logParameters.Level = 'Error'
                $logParameters.Message = 'failed: ' + $shouldProcessTarget
                $logParameters.result = $_.Exception.Message
            } finally {
                Write-LockpathLog @logParameters
            }
            return $result
        }
    }

    end {
    }
}
