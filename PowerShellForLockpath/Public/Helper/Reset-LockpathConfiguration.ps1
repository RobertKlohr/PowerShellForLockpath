
function Reset-LockpathConfiguration {
    <#
    .SYNOPSIS
        Deletes the configuration file and creates a new file with all default configuration values.

    .DESCRIPTION
        Deletes the configuration file and creates a new file with all default configuration values.

        This function can be used to fix a configuration file that is missing or corrupt.

        The Git repo for this module can be found here: https://git.io/powershellforlockpath

    .PARAMETER SessionOnly
        If this is specified then only the configuration values that were made during this session will be discarded and the configuration file will be reloaded.

    .EXAMPLE
        Reset-LockpathConfiguration

        Deletes the local configuration file and calls Set-LockpathConfiguration to create a new configuration file.

    .EXAMPLE
        Reset-LockpathConfiguration -SessionOnly

        Initializes the current sessions with default configuration values and attempts to reload the configuration file.

    .INPUTS
        None.

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
        SupportsShouldProcess = $true)]
    [OutputType('System.String')]

    [Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSShouldProcess', '', Justification = 'Methods called within here make use of PSShouldProcess, and the switch is passed on to them inherently.')]

    param(
        [Switch] $SessionOnly
    )
    $level = 'Verbose'
    $functionName = ($PSCmdlet.CommandRuntime.ToString())
    $service = 'PublicHelper'

    if ($Script:LockpathConfig.loggingLevel -eq 'Debug') {
        Write-LockpathInvocationLog -Confirm:$false -WhatIf:$false -FunctionName $functionName -Level $level -Service $service
    }

    if (-not $SessionOnly) {
        if ($PSCmdlet.ShouldProcess("Reseting configuration file:  $GroupId", $GroupId, 'Deleting group with Id:')) {
            $null = Remove-Item -Path $Script:LockpathConfig.configurationFilePath -Force -ErrorAction SilentlyContinue -ErrorVariable ev
            $null = New-Item -Path $Script:LockpathConfig.configurationFilePath -Force
            $Script:LockpathConfig | Set-LockpathConfiguration
        }

        if (($null -ne $ev) -and ($ev.Count -gt 0) -and ($ev[0].FullyQualifiedErrorId -notlike 'PathNotFound*')) {
            Write-LockpathLog -Confirm:$false -WhatIf:$false -Message "Reset was unsuccessful.  Experienced a problem trying to remove the file [$Script:LockpathConfigFilePath]." -Level $level -ErrorRecord $ev[0]
        }
    } else {
        Initialize-LockpathConfiguration
    }

    Write-LockpathLog -Confirm:$false -WhatIf:$false -Message 'This has not cleared your API credential.  Call Remove-LockpathCredential to accomplish that.' -Level $level
}
