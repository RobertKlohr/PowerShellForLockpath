# Copyright (c) Robert Klohr. All rights reserved.
# Licensed under the MIT License.

function Set-LockpathCredential {
    <#
    .SYNOPSIS
        Allows the user to configure the API credential used for authentication.

    .DESCRIPTION
        Allows the user to configure the API credential used for authentication.

        The credential will be stored on the machine as a SecureString and will automatically
        be read on future PowerShell sessions with this module.  If the user ever wishes
        to remove their authentication from the system, they simply need to call
        Remove-LockpathCredential.

        The Git repo for this module can be found here: https://git.io/powershellforlockpath

    .PARAMETER Credential
        If provided, instead of prompting the user for their API credential, it will be extracted
        from the credential object.

    .PARAMETER SessionOnly
        By default, this method will store the provided API credential as a SecureString in a local
        file so that it can be restored automatically in future PowerShell sessions.  If this
        switch is provided, the file will not be created/updated and the authentication information
        will only remain in memory for the duration of this PowerShell session.

    .EXAMPLE
        Set-LockpathCredential

        Prompts the user for their API credential and stores it in a file on the machine as a
        SecureString for use in future PowerShell sessions.

    .EXAMPLE
        Set-LockpathCredential -SessionOnly

        Prompts the user for their API credential, but keeps it in memory only for the duration
        of this PowerShell session.

    .EXAMPLE
        $secureString = ("<Your API Password>" | ConvertTo-SecureString -AsPlainText -Force)
        $cred = New-Object System.Management.Automation.PSCredential "UserName", $secureString
        Set-LockpathCredential -Credential $cred
        $secureString = $null # clear this out now that it's no longer needed
        $cred = $null # clear this out now that it's no longer needed

        Allows user to specify API credential as a plain-text string ("<Your API Password>")
        which will be securely stored on the machine for use in all future PowerShell sessions.

    .EXAMPLE
        Set-LockpathCredential -Credential $cred -SessionOnly

        Uses the API token stored in the password field of the provided credential object for
        authentication, but keeps it in memory only for the duration of this PowerShell session.

    .INPUTS
        System.Management.Automation.PSCredential

    .OUTPUTS
        String

    .NOTES
        Public helper method.

    .LINK
        https://git.io/powershellforlockpathhelp
    #>

    [CmdletBinding(
        ConfirmImpact = 'Low',
        PositionalBinding = $false,
        SupportsShouldProcess = $true
    )]

    [OutputType([System.String])]

    param(
        [PSCredential] $Credential,

        [Switch] $SessionOnly
    )

    $level = 'Verbose'
    $functionName = ($PSCmdlet.CommandRuntime.ToString())
    $service = 'PublicHelper'

    $logParameters = [ordered]@{
        'FunctionName' = $functionName
        'Level'        = $level
        'Message'      = $null
        'Service'      = $service
        'Result'       = $null
    }

    Write-LockpathInvocationLog @logParameters

    $shouldProcessTarget = 'Updating credential in current session.'

    if ($PSCmdlet.ShouldProcess($shouldProcessTarget)) {
        try {
            if (-not $PSBoundParameters.ContainsKey('Credential')) {
                do {
                    $Credential = Get-Credential -Message 'Please provide your API Username and Password.'
                }
                while ([String]::IsNullOrWhiteSpace($Credential.GetNetworkCredential().Password))
            }
            $Script:LockpathConfig.credential = $credential
            $logParameters.Message = 'Success: ' + $shouldProcessTarget
            if (-not $SessionOnly) {
                $shouldProcessTarget = 'Updating credential in current session and saving to file system.'
                Export-LockpathCredential -Credential $Credential
                $logParameters.Message = 'Success: ' + $shouldProcessTarget
            }
        } catch {
            $logParameters.Level = 'Error'
            $logParameters.Message = 'Failed: ' + $shouldProcessTarget
            $logParameters.Result = $_.Exception.Message
        } finally {
            Write-LockpathLog @logParameters
        }
        return $result
    }
}
