function Add-LockpathUserToGroup {
    <#
    .SYNOPSIS
        Add a user to a group.

    .DESCRIPTION
        Add a user to a group.  Existing users in the group remain in the group.

        The Git repo for this module can be found here: https://git.io/powershellforlockpath

    .PARAMETER GroupId
        Specifies the Id number of the group.

    .PARAMETER UserId
        Specifies the Id number of the user.

    .EXAMPLE
        Set-LockpathGroup -Attributes @{'Id' = '7'; 'Name' = 'API Update Group'}

    .EXAMPLE
        Set-LockpathGroup -Attributes @{'Id' = '7'; 'Name' = 'API Update Group'; 'Users' = @(@{'Id'= '6'},@{'Id'= '10'}}

    .INPUTS
        System.Array

    .OUTPUTS
        String

    .NOTES
        Native API Request: https://[InstanceName]:[InstancePort]/SecurityService/UpdateGroup

        The authentication account must have Read and Update Administrative Access permissions to administer groups.

    .LINK
        https://git.io/powershellforlockpathhelp
    #>

    [CmdletBinding(
        ConfirmImpact = 'Medium',
        PositionalBinding = $false,
        SupportsShouldProcess = $true)]
    [OutputType('System.String')]

    param(
        [Parameter(
            Mandatory = $true,
            ValueFromPipeline = $true,
            ValueFromPipelineByPropertyName = $true)]
        [ValidateRange('NonNegative')]
        [Int64] $GroupId,

        [Parameter(
            Mandatory = $true,
            ValueFromPipeline = $true,
            ValueFromPipelineByPropertyName = $true)]
        [ValidateRange('NonNegative')]
        [Int64[]] $UserIds
    )

    begin {
        $level = 'Information'
        $functionName = ($PSCmdlet.CommandRuntime.ToString())
        $service = 'SecurityService'
        $users = @()
    }

    process {
        Write-LockpathInvocationLog -Confirm:$false -WhatIf:$false -FunctionName $functionName -Level $level -Service $service

        $logParameters = [ordered]@{
            'Confirm'      = $false
            'WhatIf'       = $false
            'Message'      = $message
            'FunctionName' = $functionName
            'Level'        = $level
            'Service'      = $service
        }

        $shouldProcessTarget = "Properties=$($restParameters.Body)"

        if ($PSCmdlet.ShouldProcess($shouldProcessTarget)) {
            try {
                $existingUsers = (Get-LockpathGroup -GroupId $GroupId | ConvertFrom-Json -Depth $Script:LockpathConfig.jsonConversionDepth).Users
                foreach ($user in $existingUsers) {
                    $users += $user.Id
                }
                foreach ($Id in $UserIds) {
                    $users += $Id
                }
                Update-LockpathGroup -GroupId $GroupId -Users $users
                $message = 'success'
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
