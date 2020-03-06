function Set-LpConfiguration {
    <#
        .SYNOPSIS
            Setup configuration file for establishing a Lockpath session.

        .DESCRIPTION
            Takes parameters and creates a configuration file used by the other commands in the #Requires -Module

        .EXAMPLE
            Set-LpConfiguration

        .INPUTS
            None

        .OUTPUTS
            Text file holding session configuration information

        .NOTES
            Additional information about the function or script.

        .LINK
         Online Version: https://github.com/RjKGitHub/PowerShellForLockpath/

        .COMPONENT
            Lockpath

        .ROLE
            Administrator

        .FUNCTIONALITY
            Initialize, Setup, Configuration
    #>
    [CmdletBinding()]
    [OutputType()]

    param(
        # Absolute path to configuration file.
        [Parameter(Mandatory = $false, ValueFromPipeline = $true)]
        [string]
        $Path = "$env:USERPROFILE\PowerShellForLockpath.config",
        # Flag to bypass loading configuration file
        [Parameter(Mandatory = $false, ValueFromPipeline = $true)]
        [switch]
        $SkipConfigFileLoad = $false
    )

    begin {
        if (!$SkipConfigFileLoad) {
            Write-Verbose -Message "Found configuration file: $Path"
            # $LpConfig = Get-Content -Path $Path | Out-String | ConvertFrom-Json
            Write-Verbose -Message "Configuration file loaded from: $Path"
        }
        $BypassProxy = $LpConfig.BypassProxy
        $ServerName = $LpConfig.ServerName
        $ServerPort = $LpConfig.ServerPort
        $Username = $LpConfig.Username
        $Password = $LpConfig.Password
    }

    Process {
        # proxy Setting
        do {
            $BypassProxy = Read-Host -Prompt "Bypass Proxy Settings [$BypassProxy]? (Yes|No)"
        } until ((!$BypassProxy) -or ($BypassProxy -In ("yes", "y", "No", "n")))
        if ($BypassProxy) {
            $LpConfig.BypassProxy = $BypassProxy
        }

        # server port setting
        do {
            [int]$ServerPort = Read-Host -Prompt "Enter Server Port [$ServerPort]"
        } until ((!$ServerPort) -or (($ServerPort -ge 1) -and ($ServerPort -le 65535)))
        if ($ServerPort) {
            $LpConfig.ServerPort = $ServerPort
        }

        # server host and domain
        do {
            $ServerName = Read-Host -Prompt "Enter the Lockpath Server [$ServerName]"
        } until (($ServerName) -or ($LpConfig.ServerName))
        if ($ServerName) {
            $LpConfig.ServerName = $ServerName
        }
        $
        # API account username
        do {
            $Username = Read-Host -Prompt "Enter Lockpath API Account Username [$Username]"
        } until (($Username) -or ($LpConfig.Username))
        if ($Username) {
            $LpConfig.Username = $Username
        }
        # API account password
        do {
            $Password = Read-Host -Prompt "Enter Lockpath API Account Password [$Password]"
        } until ($Password)
        if ($Password) {
            $LpConfig.Password = ConvertTo-SecureString -String $password -AsPlainText -Force | ConvertFrom-SecureString
        }

        $LpConfig.Uri += $ServerName + ":" + $ServerPort
        $LpConfig | ConvertTo-Json | Out-File -FilePath $Path
    }
    end {
        # Nothing
    }
}
