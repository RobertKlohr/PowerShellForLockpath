function Import-LockpathUsers {

    # TODO loads locally saved copy of user database
    # TODO create function to refresh user database, run GetUsers and compare output to the versions loaded from
    # disk then run GetUser for any delta an add it to the locally stored user database. A secondary function
    # would be to prune users from the local database that are not returned from GetUsers


    <#
    .SYNOPSIS
        Loads in the default configuration values and returns the deserialized object.

    .DESCRIPTION
        Loads in the default configuration values and returns the deserialized object.

        The Git repo for this module can be found here: https://git.io/powershellforlockpath

    .PARAMETER FilePath
        The file that may or may not exist with a serialized version of the configuration values for this module.

    .OUTPUTS
        PSCustomObject

    .EXAMPLE
        Read-LockpathConfiguration -FilePath 'c:\Temp\PowerShellForLockpath.json'

    .INPUTS
        System.IO.FileInfo

    .OUTPUTS
        PSCustomObject

    .NOTES
        Private helper method.

    .LINK
        https://git.io/powershellforlockpathhelp
    #>

    [CmdletBinding(
        ConfirmImpact = 'Low',
        PositionalBinding = $false,
        SupportsShouldProcess = $true)]

    [Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSShouldProcess', '', Justification = 'Methods called within here make use of PSShouldProcess, and the switch is passed on to them inherently.')]

    param(
        [Parameter(Mandatory = $true)]
        [System.IO.FileInfo] $FilePath
    )

    $level = 'Information'
    $functionName = ($PSCmdlet.CommandRuntime.ToString())
    $service = 'SecurityService'

    Write-LockpathInvocationLog -Confirm:$false -WhatIf:$false -FunctionName $functionName -Level $level -Service $service

    try {
        $content = Import-Clixml -Path $FilePath
        Write-LockpathLog -Confirm:$false -WhatIf:$false -Message 'Restoring configuration settings from file.' -FunctionName $functionName -Level $level -Service $service
        return $content
    } catch {
        Write-LockpathLog -Confirm:$false -WhatIf:$false -Message 'The configuration file for this module is in an invalid state.  Use Reset-LockpathConfiguration to reset the file followed by Set-LockpathConfiguration -InstanceName <instancename>.' -FunctionName $functionName -Level $level -Service $service
    }

    # try {
    #     $content = Get-Content -Path $FilePath -Encoding UTF8 -ErrorAction Stop
    #     return ($content | ConvertFrom-Json -Depth $Script:LockpathConfig.jsonConversionDepth)
    # } catch {
    #     Write-LockpathLog -Confirm:$false -WhatIf:$false -Message 'The configuration file for this module is in an invalid state.  Use Reset-LockpathConfiguration to reset the file followed by Set-LockpathConfiguration -InstanceName <instancename>.' -Level $level
    # }
}
