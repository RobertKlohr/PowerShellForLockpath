function Remove-LockpathUser {
    <#
    .SYNOPSIS
        Deletes a user account.

    .DESCRIPTION
        Deletes a user account. To inactive a user account use Set-LockpathUser. To undelete an account you must
        use the platform interface.

        The Git repo for this module can be found here: https://git.io/powershellforlockpath

    .PARAMETER UserId
        Specifies the Id number of the user.

    .EXAMPLE
        Remove-LockpathUser -UserId 6

    .EXAMPLE
        Remove-LockpathUser 6

    .EXAMPLE
        6 | Remove-LockpathUser

    .EXAMPLE
        6,12,15 | Remove-LockpathUser

    .EXAMPLE
        $userObject | Remove-LockpathUser

        If $userObject has an property called UserId that value is automatically passed as a parameter.

    .INPUTS
        System.UInt32

    .OUTPUTS
        String

    .NOTES
        Native API Request: https://[InstanceName]:[InstancePort]/SecurityService/DeleteUser

        The authentication account must have Read and Delete Administrative Access permissions to administer users.
        For vendor contacts, the authentication account can alternatively have Read and Delete General Access to
        Vendor Profiles.

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
        [ValidateRange('Positive')]
        [Int64] $UserId
    )

    begin {
        $level = 'Information'
        $functionName = ($PSCmdlet.CommandRuntime.ToString())
        $service = 'SecurityService'
    }

    process {
        if ($Script:LockpathConfig.loggingLevel -eq 'Debug') {
            Write-LockpathInvocationLog -Confirm:$false -WhatIf:$false -FunctionName $functionName -Level $level -Service $service
        }

        $restParameters = [ordered]@{
            'Body'        = $UserId | ConvertTo-Json -Depth $Script:LockpathConfig.jsonConversionDepth -Compress
            'Description' = 'Deleting User By Id'
            'Method'      = 'DELETE'
            'Service'     = $service
            'UriFragment' = 'DeleteUser'
        }

        $logParameters = [ordered]@{
            'Confirm'      = $false
            'WhatIf'       = $false
            'Message'      = $message
            'FunctionName' = $functionName
            'Level'        = $level
            'Service'      = $service
        }

        $shouldProcessTarget = "Id=$UserId"

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
