function Set-LockpathConfiguration {
    #FIXME Update to new coding standards
    #FIXME move save-lockpathconfiguration into this function

    [CmdletBinding(
        ConfirmImpact = 'Low',
        PositionalBinding = $false,
        SupportsShouldProcess = $true)]
    [OutputType('System.String')]
    [Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSShouldProcess', '', Justification = 'Methods called within here make use of PSShouldProcess, and the switch is passed on to them inherently.')]

    param(

        [securestring] $Credential,

        [ValidatePattern('^(?!https?:).*')]
        [string] $InstanceName,

        [ValidateRange(0, 65535)]
        [uint] $InstancePort,

        [string] $InstancePortocol,

        [string] $LogPath,

        [switch] $LogRequestBody,

        [switch] $LogTimeAsUtc,

        [uint] $PageIndex,

        [uint] $PageSize,

        [uint] $RetryDelaySeconds,

        [boolean] $RunAsSystem,

        [switch] $SessionOnly,

        [string] $UserAgent,

        [ValidateRange(0, 3600)]
        [uint] $WebRequestTimeoutSec,

        [Microsoft.PowerShell.Commands.WebRequestSession] $WebSession
    )

    $persistedConfig = $null
    if (-not $SessionOnly) {
        $persistedConfig = Read-LockpathConfiguration -FilePath $script:configurationFilePath
    }

    $properties = Get-Member -InputObject $script:configuration -MemberType NoteProperty | Select-Object -ExpandProperty Name
    foreach ($name in $properties) {
        if ($PSBoundParameters.ContainsKey($name)) {
            $value = $PSBoundParameters.$name
            if ($value -is [switch]) {
                $value = $value.ToBool()
            }
            $script:configuration.$name = $value

            if (-not $SessionOnly) {
                Add-Member -InputObject $persistedConfig -Name $name -Value $value -MemberType NoteProperty -Force
            }
        }
    }

    if (-not $SessionOnly) {
        try {
            $null = New-Item -Path $FilePath -Force
            ConvertTo-Json -InputObject $Configuration | Set-Content -Path $FilePath -Force
            return ('Successfully saved configuration to disk.')
        } catch {
            Write-LockpathLog -Message 'Failed to save configuration to disk.  It will remain for this PowerShell session only.' -Level Warning
        }
    }
}
