

#TODO: check and update all Github references to Lockpath
#TODO: check and update all $Password references and functions and have the word password in them

# Copyright (c) Robert Klohr. All rights reserved.
# Licensed under the MIT License.

# The Lockpath API password is stored in the password field.
[PSCredential] $script:accessPasswordCredential = $null

# The location of the file that we'll store any settings that can/should roam with the user.
[string] $script:configurationFilePath = [System.IO.Path]::Combine(
    [Environment]::GetFolderPath('ApplicationData'),
    'Klohr',
    'PowerShellForLockpath',
    'config.json')

# The location of the file that we'll store the Password SecureString
# which cannot/should not roam with the user.
[string] $script:accessPasswordFilePath = [System.IO.Path]::Combine(
    [Environment]::GetFolderPath('LocalApplicationData'),
    'Klohr',
    'PowerShellForLockpath',
    'Password.txt')

# Only tell users about needing to configure an API password once per session.
$script:seenPasswordWarningThisSession = $false

# The session-cached copy of the module's configuration properties
[PSCustomObject] $script:configuration = $null

function Initialize-GitHubConfiguration {
    <#
    .SYNOPSIS
        Populates the configuration of the module for this session, loading in any values
        that may have been saved to disk.

    .DESCRIPTION
        Populates the configuration of the module for this session, loading in any values
        that may have been saved to disk.

        The Git repo for this module can be found here: http://aka.ms/PowerShellForGitHub

    .NOTES
        Internal helper method.  This is actually invoked at the END of this file.
#>
    [CmdletBinding(SupportsShouldProcess)]
    [Diagnostics.CodeAnalysis.SuppressMessageAttribute("PSShouldProcess", "", Justification = "Methods called within here make use of PSShouldProcess, and the switch is passed on to them inherently.")]
    param()

    $script:seenPasswordWarningThisSession = $false
    $script:configuration = Import-GitHubConfiguration -Path $script:configurationFilePath
}


function Set-LockpathConfiguration {
    <#
        .SYNOPSIS
            Change the value of a configuration property for the PowerShellForLockpath module,
            for the session and by defatult store the configuration values in a local file.

        .DESCRIPTION
            Change the value of a configuration property for the PowerShellForLockpath module,
            for the session and by defatult store the configuration values in a local file.

            A single call to this method can set any number or combination of properties.

            To change any of the boolean/switch properties to false, specify the switch,
            immediately followed by ":$false" with no space.

            The Git repo for this module can be found here: https://github.com/RjKGitHub/PowerShellForLockpath/

        .PARAMETER ApiHostName
            The hostname of the Lockpath instance to communicate with.  Do not include the HTTP/S prefix.

        .PARAMETER DisableLogging
            Specify this switch to stop the module from logging all activity to a log file located
            at the location specified by LogPath.

        .PARAMETER LogPath
            The location of the log file that all activity will be written to if DisableLogging remains $false.

        .PARAMETER SessionOnly
            By default, this method will store the configuration values in a local file so that changes
            persist across PowerShell sessions.  If this switch is provided, the file will not be
            created/updated and the specified configuration changes will only remain in memory/effect
            for the duration of this PowerShell session.

        .EXAMPLE
            Set-LockpathConfiguration

        .EXAMPLE
            Set-LockpathConfiguration -ApiHostName "lockpath.keylightrc.com" -DisableLogging -SessionOnly

            Sets all requests to connect to lockpath.keylightrc.com,
            disables the logging of any activity to the logfile specified in LogPath, but for this session only.

    #>
    [CmdletBinding()]

    param (
        [ValidatePattern('^(?!https?:)(?!api\.)(?!www\.).*')]
        [string] $ApiHostName,
        [switch] $DisableLogging,
        [string] $LogPath,
        [switch] $SessionOnly
    )

    $persistedConfig = $null
    if (-not $SessionOnly) {
        $persistedConfig = Read-LockpathConfiguration -Path $script:configurationFilePath
    }

    $properties = Get-Member -InputObject $script:configuration -MemberType NoteProperty | Select-Object -ExpandProperty Name
    foreach ($name in $properties) {
        if ($PSBoundParameters.ContainsKey($name)) {
            $value = $PSBoundParameters.$name
            if ($value -is [switch]) { $value = $value.ToBool() }
            $script:configuration.$name = $value

            if (-not $SessionOnly) {
                Add-Member -InputObject $persistedConfig -Name $name -Value $value -MemberType NoteProperty -Force
            }
        }
    }

    if (-not $SessionOnly) {
        Save-LockpathConfiguration -Configuration $persistedConfig -Path $script:configurationFilePath
    }

}



function Get-LockpathConfiguration {
    <#
    .SYNOPSIS
        Gets the currently configured value for the requested configuration setting.

    .DESCRIPTION
        Gets the currently configured value for the requested configuration setting.

        Always returns the value for this session, which may or may not be the persisted
        setting (that all depends on whether or not the setting was previously modified
        during this session using Set-LockpathConfiguration -SessionOnly).

        The Git repo for this module can be found here: http://aka.ms/PowerShellForGitHub

    .PARAMETER Name
        The name of the configuration whose value is desired.

    .EXAMPLE
        Get-LockpathConfiguration -Name WebRequestTimeoutSec

        Gets the currently configured value for WebRequestTimeoutSec for this PowerShell session
        (which may or may not be the same as the persisted configuration value, depending on
        whether this value was modified during this session with Set-LockpathConfiguration -SessionOnly).
#>
    [CmdletBinding()]
    param(
        [Parameter(Mandatory)]
        [ValidateSet(
            'ApiHostName',
            'LogPath')]
        [string] $Name
    )

    return $script:configuration.$Name
}

function Save-LockpathConfiguration {
    <#
    .SYNOPSIS
        Serializes the provided settings object to disk as a JSON file.

    .DESCRIPTION
        Serializes the provided settings object to disk as a JSON file.

        The Git repo for this module can be found here: http://aka.ms/PowerShellForGitHub

    .PARAMETER Configuration
        The configuration object to persist to disk.

    .PARAMETER Path
        The path to the file on disk that Configuration should be persisted to.

    .NOTES
        Internal helper method.

    .EXAMPLE
        Save-LockpathConfiguration -Configuration $config -Path 'c:\foo\config.json'

        Serializes $config as a JSON object to 'c:\foo\config.json'
#>
    [CmdletBinding()]
    [Diagnostics.CodeAnalysis.SuppressMessageAttribute("PSShouldProcess", "", Justification = "Methods called within here make use of PSShouldProcess, and the switch is passed on to them inherently.")]
    param(
        [Parameter(Mandatory)]
        [PSCustomObject] $Configuration,

        [Parameter(Mandatory)]
        [string] $Path
    )

    $null = New-Item -Path $Path -Force
    ConvertTo-Json -InputObject $Configuration |
    Set-Content -Path $Path -Force -ErrorAction SilentlyContinue -ErrorVariable ev

    if (($null -ne $ev) -and ($ev.Count -gt 0)) {
        Write-Log -Message "Failed to persist these updated settings to disk.  They will remain for this PowerShell session only." -Level Warning -Exception $ev[0]
    }
}

function Test-PropertyExists {
    <#
    .SYNOPSIS
        Determines if an object contains a property with a specified name.

    .DESCRIPTION
        Determines if an object contains a property with a specified name.

        This is essentially using Get-Member to verify that a property exists,
        but additionally adds a check to ensure that InputObject isn't null.

    .PARAMETER InputObject
        The object to check to see if it has a property named Name.

    .PARAMETER Name
        The name of the property on InputObject that is being tested for.

    .EXAMPLE
        Test-PropertyExists -InputObject $listing -Name 'title'

        Returns $true if $listing is non-null and has a property named 'title'.
        Returns $false otherwise.

    .NOTES
        Internal-only helper method.
#>
    [CmdletBinding()]
    [OutputType([bool])]
    [Diagnostics.CodeAnalysis.SuppressMessageAttribute("PSUseSingularNouns", "", Justification = "Exists isn't a noun and isn't violating the intention of this rule.")]
    param(
        [Parameter(Mandatory)]
        [AllowNull()]
        $InputObject,

        [Parameter(Mandatory)]
        [String] $Name
    )

    return (($null -ne $InputObject) -and
        ($null -ne (Get-Member -InputObject $InputObject -Name $Name -MemberType Properties)))
}

function Resolve-PropertyValue {
    <#
    .SYNOPSIS
        Returns the requested property from the provided object, if it exists and is a valid
        value.  Otherwise, returns the default value.

    .DESCRIPTION
        Returns the requested property from the provided object, if it exists and is a valid
        value.  Otherwise, returns the default value.

        The Git repo for this module can be found here: http://aka.ms/PowerShellForGitHub

    .PARAMETER InputObject
        The object to check the value of the requested property.

    .PARAMETER Name
        The name of the property on InputObject whose value is desired.

    .PARAMETER Type
        The type of the value stored in the Name property on InputObject.  Used to validate
        that the property has a valid value.

    .PARAMETER DefaultValue
        The value to return if Name doesn't exist on InputObject or is of an invalid type.

    .EXAMPLE
        Resolve-PropertyValue -InputObject $config -Name defaultOwnerName -Type String -DefaultValue $null

        Checks $config to see if it has a property named "defaultOwnerName".  If it does, and it's a
        string, returns that value, otherwise, returns $null (the DefaultValue).
#>
    [CmdletBinding()]
    param(
        [PSCustomObject] $InputObject,

        [Parameter(Mandatory)]
        [string] $Name,

        [Parameter(Mandatory)]
        [ValidateSet('String', 'Boolean', 'Int32', 'Int64')]
        [String] $Type,

        $DefaultValue
    )

    if ($null -eq $InputObject) {
        return $DefaultValue
    }

    $typeType = [String]
    if ($Type -eq 'Boolean') { $typeType = [Boolean] }
    if ($Type -eq 'Int32') { $typeType = [Int32] }
    if ($Type -eq 'Int64') { $typeType = [Int64] }

    if (Test-PropertyExists -InputObject $InputObject -Name $Name) {
        if ($InputObject.$Name -is $typeType) {
            return $InputObject.$Name
        } else {
            Write-Log "The locally cached $Name configuration was not of type $Type.  Reverting to default value." -Level Warning
            return $DefaultValue
        }
    } else {
        return $DefaultValue
    }
}

function Reset-LockpathConfiguration {
    <#
    .SYNOPSIS
        Clears out the user's configuration file and configures this session with all default
        configuration values.

    .DESCRIPTION
        Clears out the user's configuration file and configures this session with all default
        configuration values.

        This would be the functional equivalent of using this on a completely different computer.

        The Git repo for this module can be found here: http://aka.ms/PowerShellForGitHub

    .PARAMETER SessionOnly
        By default, this will delete the location configuration file so that all defaults are used
        again.  If this is specified, then only the configuration values that were made during
        this session will be discarded.

    .EXAMPLE
        Reset-LockpathConfiguration

        Deletes the local configuration file and loads in all default configration values.

    .NOTES
        This command will not clear your authentication Password.  Please use Clear-LockpathAuthentication to accomplish that.
#>
    [CmdletBinding(SupportsShouldProcess)]
    param(
        [switch] $SessionOnly
    )

    Set-TelemetryEvent -EventName Reset-LockpathConfiguration

    if (-not $SessionOnly) {
        if ($PSCmdlet.ShouldProcess($script:configurationFilePath, "Delete configuration file")) {
            $null = Remove-Item -Path $script:configurationFilePath -Force -ErrorAction SilentlyContinue -ErrorVariable ev
        }

        if (($null -ne $ev) -and ($ev.Count -gt 0) -and ($ev[0].FullyQualifiedErrorId -notlike 'PathNotFound*')) {
            Write-Log -Message "Reset was unsuccessful.  Experienced a problem trying to remove the file [$script:configurationFilePath]." -Level Warning -Exception $ev[0]
        }
    }

    Initialize-LockpathConfiguration

    Write-Log -Message "This has not cleared your authentication Password.  Call Clear-LockpathAuthentication to accomplish that." -Level Verbose
}

function Read-LockpathConfiguration {
    <#
    .SYNOPSIS
        Loads in the default configuration values and returns the deserialized object.

    .DESCRIPTION
        Loads in the default configuration values and returns the deserialized object.

        The Git repo for this module can be found here: http://aka.ms/PowerShellForGitHub

    .PARAMETER Path
        The file that may or may not exist with a serialized version of the configuration
        values for this module.

    .OUTPUTS
        PSCustomObject

    .NOTES
        Internal helper method.
        No side-effects.

    .EXAMPLE
        Read-LockpathConfiguration -Path 'c:\foo\config.json'

        Returns back an object with the deserialized object contained in the specified file,
        if it exists and is valid.
#>
    [CmdletBinding(SupportsShouldProcess)]
    [Diagnostics.CodeAnalysis.SuppressMessageAttribute("PSShouldProcess", "", Justification = "Methods called within here make use of PSShouldProcess, and the switch is passed on to them inherently.")]
    param(
        [string] $Path
    )

    $content = Get-Content -Path $Path -Encoding UTF8 -ErrorAction Ignore
    if (-not [String]::IsNullOrEmpty($content)) {
        try {
            return ($content | ConvertFrom-Json)
        } catch {
            Write-Log -Message 'The configuration file for this module is in an invalid state.  Use Reset-LockpathConfiguration to recover.' -Level Warning
        }
    }

    return [PSCustomObject]@{ }
}

function Import-LockpathConfiguration {
    <#
    .SYNOPSIS
        Loads in the default configuration values, and then updates the individual properties
        with values that may exist in a file.

    .DESCRIPTION
        Loads in the default configuration values, and then updates the individual properties
        with values that may exist in a file.

        The Git repo for this module can be found here: http://aka.ms/PowerShellForGitHub

    .PARAMETER Path
        The file that may or may not exist with a serialized version of the configuration
        values for this module.

    .OUTPUTS
        PSCustomObject

    .NOTES
        Internal helper method.
        No side-effects.

    .EXAMPLE
        Import-LockpathConfiguration -Path 'c:\foo\config.json'

        Creates a new default config object and updates its values with any that are found
        within a deserialized object from the content in $Path.  The configuration object
        is then returned.
#>
    [CmdletBinding(SupportsShouldProcess)]
    [Diagnostics.CodeAnalysis.SuppressMessageAttribute("PSShouldProcess", "", Justification = "Methods called within here make use of PSShouldProcess, and the switch is passed on to them inherently.")]
    param(
        [string] $Path
    )

    # Create a configuration object with all the default values.  We can then update the values
    # with any that we find on disk.
    $logPath = [String]::Empty
    $documentsFolder = [System.Environment]::GetFolderPath('MyDocuments')
    if (-not [System.String]::IsNullOrEmpty($documentsFolder)) {
        $logPath = Join-Path -Path $documentsFolder -ChildPath 'PowerShellForGitHub.log'
    }

    $config = [PSCustomObject]@{
        'apiHostName'               = 'github.com'
        'applicationInsightsKey'    = '66d83c52-3070-489b-886b-09860e05e78a'
        'assemblyPath'              = [String]::Empty
        'disableLogging'            = ([String]::IsNullOrEmpty($logPath))
        'disablePiiProtection'      = $false
        'disableSmarterObjects'     = $false
        'disableTelemetry'          = $false
        'defaultNoStatus'           = $false
        'defaultOwnerName'          = [String]::Empty
        'defaultRepositoryName'     = [String]::Empty
        'logPath'                   = $logPath
        'logProcessId'              = $false
        'logRequestBody'            = $false
        'logTimeAsUtc'              = $false
        'retryDelaySeconds'         = 30
        'suppressNoPasswordWarning' = $false
        'suppressTelemetryReminder' = $false
        'webRequestTimeoutSec'      = 0

        # This hash is generated by using Helper.ps1's Get-Sha512Hash in Tests/Config/Settings.ps1 like so:
        #    . ./Helpers.ps1; Get-Sha512Hash -PlainText (Get-Content -Path ./Tests/Config/Settings.ps1 -Raw -Encoding Utf8)
        # The hash is used to identify if the user has made changes to the config file prior to running the UT's locally.
        # It intentionally cannot be modified via Set-LockpathConfiguration and must be updated directly in the
        # source code here should the default Settings.ps1 file ever be changed.
        'testConfigSettingsHash'    = 'A76CA42A587D10247F887F9257DB7BF5F988E8714A7C0E29D7B100A20F5D35B8E3306AC5B9BBC8851EC19846A90BB3C80FC7C594D0347A772B2B10BADB1B3E68'
    }

    $jsonObject = Read-LockpathConfiguration -Path $Path
    Get-Member -InputObject $config -MemberType NoteProperty |
    ForEach-Object {
        $name = $_.Name
        $type = $config.$name.GetType().Name
        $config.$name = Resolve-PropertyValue -InputObject $jsonObject -Name $name -Type $type -DefaultValue $config.$name
    }

    return $config
}

function Backup-LockpathConfiguration {
    <#
    .SYNOPSIS
        Exports the user's current configuration file.

    .DESCRIPTION
        Exports the user's current configuration file.

        This is primarily used for unit testing scenarios.

        The Git repo for this module can be found here: http://aka.ms/PowerShellForGitHub

    .PARAMETER Path
        The path to store the user's current configuration file.

    .PARAMETER Force
        If specified, will overwrite the contents of any file with the same name at th
        location specified by Path.

    .EXAMPLE
        Backup-LockpathConfiguration -Path 'c:\foo\config.json'

        Writes the user's current configuration file to c:\foo\config.json.
#>
    [CmdletBinding(SupportsShouldProcess)]
    [Diagnostics.CodeAnalysis.SuppressMessageAttribute("PSShouldProcess", "", Justification = "Methods called within here make use of PSShouldProcess, and the switch is passed on to them inherently.")]
    param(
        [string] $Path,

        [switch] $Force
    )

    # Make sure that the path that we're going to be storing the file exists.
    $null = New-Item -Path (Split-Path -Path $Path -Parent) -ItemType Directory -Force

    if (Test-Path -Path $script:configurationFilePath -PathType Leaf) {
        $null = Copy-Item -Path $script:configurationFilePath -Destination $Path -Force:$Force
    } else {
        ConvertTo-Json -InputObject @{ } | Set-Content -Path $Path -Force:$Force
    }
}

function Restore-LockpathConfiguration {
    <#
    .SYNOPSIS
        Sets the specified file to be the user's configuration file.

    .DESCRIPTION
        Sets the specified file to be the user's configuration file.

        This is primarily used for unit testing scenarios.

        The Git repo for this module can be found here: http://aka.ms/PowerShellForGitHub

    .PARAMETER Path
        The path to store the user's current configuration file.

    .EXAMPLE
        Restore-LockpathConfiguration -Path 'c:\foo\config.json'

        Makes the contents of c:\foo\config.json be the user's configuration for the module.
#>
    [CmdletBinding(SupportsShouldProcess)]
    [Diagnostics.CodeAnalysis.SuppressMessageAttribute("PSShouldProcess", "", Justification = "Methods called within here make use of PSShouldProcess, and the switch is passed on to them inherently.")]
    param(
        [ValidateScript( { if (Test-Path -Path $_ -PathType Leaf) { $true } else { throw "$_ does not exist." } })]
        [string] $Path
    )

    # Make sure that the path that we're going to be storing the file exists.
    $null = New-Item -Path (Split-Path -Path $script:configurationFilePath -Parent) -ItemType Directory -Force

    $null = Copy-Item -Path $Path -Destination $script:configurationFilePath -Force

    Initialize-LockpathConfiguration
}

function Resolve-ParameterWithDefaultConfigurationValue {
    <#
    .SYNOPSIS
        Some of the configuration properties act as default values to be used for some functions.
        This will determine what the correct final value should be by inspecting the calling
        functions inbound parameters, along with the corresponding configuration value.

    .DESCRIPTION
        Some of the configuration properties act as default values to be used for some functions.
        This will determine what the correct final value should be by inspecting the calling
        functions inbound parameters, along with the corresponding configuration value.

        The Git repo for this module can be found here: http://aka.ms/PowerShellForGitHub

    .PARAMETER BoundParameters
        The inbound parameters from the calling method.
        No need to explicitly provide this if you're using the PSBoundParameters from the
        function that is calling this directly.

    .PARAMETER Name
        The name of the parameter in BoundParameters.

    .PARAMETER ConfigValueName
        The name of the cofiguration property that should be used as default if Name doesn't exist
        in BoundParameters.

    .PARAMETER NonEmptyStringRequired
        If specified, will throw an exception if the resolved value to be returned would end up
        being null or an empty string.

    .EXAMPLE
        Resolve-ParameterWithDefaultConfigurationValue -BoundParameters $PSBoundParameters -Name NoStatus -ConfigValueName DefaultNoStatus

        Checks to see if the NoStatus switch was provided by the user from the calling method.  If
        so, uses that value. otherwise uses the DefaultNoStatus value currently configured.
#>
    [CmdletBinding(SupportsShouldProcess)]
    [Diagnostics.CodeAnalysis.SuppressMessageAttribute("PSShouldProcess", "", Justification = "Methods called within here make use of PSShouldProcess, and the switch is passed on to them inherently.")]
    param(
        $BoundParameters = (Get-Variable -Name PSBoundParameters -Scope 1 -ValueOnly),

        [Parameter(Mandatory)]
        [string] $Name,

        [Parameter(Mandatory)]
        [String] $ConfigValueName,

        [switch] $NonEmptyStringRequired
    )

    $value = $null
    if ($BoundParameters.ContainsKey($Name)) {
        $value = $BoundParameters[$Name]
    } else {
        $value = (Get-LockpathConfiguration -Name $ConfigValueName)
    }

    if ($NonEmptyStringRequired -and [String]::IsNullOrEmpty($value)) {
        $message = "A value must be provided for $Name either as a parameter, or as a default configuration value ($ConfigValueName) via Set-LockpathConfiguration."
        Write-Log -Message $message -Level Error
        throw $message
    } else {
        return $value
    }
}

function Set-LockpathAuthentication {
    <#
    .SYNOPSIS
        Allows the user to configure the API Password that should be used for authentication
        with the GitHub API.

    .DESCRIPTION
        Allows the user to configure the API Password that should be used for authentication
        with the GitHub API.

        The Password will be stored on the machine as a SecureString and will automatically
        be read on future PowerShell sessions with this module.  If the user ever wishes
        to remove their authentication from the system, they simply need to call
        Clear-LockpathAuthentication.

        The Git repo for this module can be found here: http://aka.ms/PowerShellForGitHub

    .PARAMETER Credential
        If provided, instead of prompting the user for their API Password, it will be extracted
        from the password field of this credential object.

    .PARAMETER SessionOnly
        By default, this method will store the provided API Password as a SecureString in a local
        file so that it can be restored automatically in future PowerShell sessions.  If this
        switch is provided, the file will not be created/updated and the authentication information
        will only remain in memory for the duration of this PowerShell session.

    .EXAMPLE
        Set-LockpathAuthentication

        Prompts the user for their GitHub API Password and stores it in a file on the machine as a
        SecureString for use in future PowerShell sessions.

    .EXAMPLE
        $secureString = ("<Your Access Password>" | ConvertTo-SecureString)
        $cred = New-Object System.Management.Automation.PSCredential "username is ignored", $secureString
        Set-LockpathAuthentication -Credential $cred

        Uses the API Password stored in the password field of the provided credential object for
        authentication, and stores it in a file on the machine as a SecureString for use in
        future PowerShell sessions.

    .EXAMPLE
        Set-LockpathAuthentication -SessionOnly

        Prompts the user for their GitHub API Password, but keeps it in memory only for the duration
        of this PowerShell session.

    .EXAMPLE
        Set-LockpathAuthentication -Credential $cred -SessionOnly

        Uses the API Password stored in the password field of the provided credential object for
        authentication, but keeps it in memory only for the duration of this PowerShell session..
#>
    [CmdletBinding(SupportsShouldProcess)]
    [Diagnostics.CodeAnalysis.SuppressMessageAttribute("PSShouldProcess", "", Justification = "Methods called within here make use of PSShouldProcess, and the switch is passed on to them inherently.")]
    [Diagnostics.CodeAnalysis.SuppressMessageAttribute("PSUsePSCredentialType", "", Justification = "The System.Management.Automation.Credential() attribute does not appear to work in PowerShell v4 which we need to support.")]
    param(
        [PSCredential] $Credential,

        [switch] $SessionOnly
    )

    Write-InvocationLog

    if (-not $PSBoundParameters.ContainsKey('Credential')) {
        $message = 'Please provide your API Password in the Password field.  You can enter anything in the username field (it will be ignored).'
        if (-not $SessionOnly) {
            $message = $message + '  ***The Password is being cached across PowerShell sessions.  To clear caching, call Clear-LockpathAuthentication.***'
        }

        Write-Log -Message $message
        $Credential = Get-Credential -Message $message
    }

    if ([String]::IsNullOrWhiteSpace($Credential.GetNetworkCredential().Password)) {
        $message = "The API Password was not provided in the password field.  Nothing to do."
        Write-Log -Message $message -Level Error
        throw $message
    }

    $script:accessPasswordCredential = $Credential
    if (-not $SessionOnly) {
        if ($PSCmdlet.ShouldProcess("Store API Password as a SecureString in a local file")) {
            $null = New-Item -Path $script:accessPasswordFilePath -Force
            $script:accessPasswordCredential.Password |
            ConvertFrom-SecureString |
            Set-Content -Path $script:accessPasswordFilePath -Force
        }
    }
}

function Clear-LockpathAuthentication {
    <#
    .SYNOPSIS
        Clears out any GitHub API Password from memory, as well as from local file storage.

    .DESCRIPTION
        Clears out any GitHub API Password from memory, as well as from local file storage.

        The Git repo for this module can be found here: http://aka.ms/PowerShellForGitHub

    .PARAMETER SessionOnly
        By default, this will clear out the cache in memory, as well as in the local
        configuration file.  If this switch is specified, authentication will be cleared out
        in this session only -- the local configuration file cache will remain
        (and thus still be available in a new PowerShell session).

    .EXAMPLE
        Clear-LockpathAuthentication

        Clears out any GitHub API Password from memory, as well as from local file storage.

    .NOTES
        This command will not clear your configuration settings.  Please use Reset-LockpathConfiguration to accomplish that.
#>
    [CmdletBinding(SupportsShouldProcess)]
    param(
        [switch] $SessionOnly
    )

    Write-InvocationLog

    Set-TelemetryEvent -EventName Clear-LockpathAuthentication

    if ($PSCmdlet.ShouldProcess("Clear memory cache")) {
        $script:accessPasswordCredential = $null
    }

    if (-not $SessionOnly) {
        if ($PSCmdlet.ShouldProcess("Clear file-based cache")) {
            Remove-Item -Path $script:accessPasswordFilePath -Force -ErrorAction SilentlyContinue -ErrorVariable ev

            if (($null -ne $ev) -and ($ev.Count -gt 0) -and ($ev[0].FullyQualifiedErrorId -notlike 'PathNotFound*')) {
                Write-Log -Message "Experienced a problem trying to remove the file that persists the API Password [$script:accessPasswordFilePath]." -Level Warning -Exception $ev[0]
            }
        }
    }

    Write-Log -Message "This has not cleared your configuration settings.  Call Reset-LockpathConfiguration to accomplish that." -Level Verbose
}

function Get-AccessPassword {
    <#
    .SYNOPSIS
        Retrieves the API Password for use in the rest of the module.

    .DESCRIPTION
        Retrieves the API Password for use in the rest of the module.

        First will try to use the one that may have been provided as a parameter.
        If not provided, then will try to use the one already cached in memory.
        If still not found, will look to see if there is a file with the API Password stored
        as a SecureString.
        Finally, if there is still no available Password, none will be used.  The user will then be
        subjected to tighter hourly query restrictions.

        The Git repo for this module can be found here: http://aka.ms/PowershellForGitHub

    .PARAMETER AccessPassword
        If provided, this will be returned instead of using the cached/configured value

    .OUTPUTS
        System.String
#>
    [CmdletBinding(SupportsShouldProcess)]
    [Diagnostics.CodeAnalysis.SuppressMessageAttribute("PSAvoidGlobalVars", "", Justification = "For back-compat with v0.1.0, this still supports the deprecated method of using a global variable for storing the API Password.")]
    [Diagnostics.CodeAnalysis.SuppressMessageAttribute("PSShouldProcess", "", Justification = "Methods called within here make use of PSShouldProcess, and the switch is passed on to them inherently.")]
    [OutputType([String])]
    param(
        [string] $AccessPassword
    )

    if (-not [String]::IsNullOrEmpty($AccessPassword)) {
        return $AccessPassword
    }

    if ($null -ne $script:accessPasswordCredential) {
        $Password = $script:accessPasswordCredential.GetNetworkCredential().Password

        if (-not [String]::IsNullOrEmpty($Password)) {
            return $Password
        }
    }

    $content = Get-Content -Path $script:accessPasswordFilePath -ErrorAction Ignore
    if (-not [String]::IsNullOrEmpty($content)) {
        try {
            $secureString = $content | ConvertTo-SecureString

            Write-Log -Message "Restoring API Password from file.  This value can be cleared in the future by calling Clear-LockpathAuthentication." -Level Verbose
            $script:accessPasswordCredential = New-Object System.Management.Automation.PSCredential "<username is ignored>", $secureString
            return $script:accessPasswordCredential.GetNetworkCredential().Password
        } catch {
            Write-Log -Message 'The API Password file for this module contains an invalid SecureString (files can''t be shared by users or computers).  Use Set-LockpathAuthentication to update it.' -Level Warning
        }
    }

    if (-not [String]::IsNullOrEmpty($global:lockpathApiPassword)) {
        Write-Log -Message 'Storing the Access Password in `$global:lockpathApiPassword` is insecure and is no longer recommended.  To cache your API Password for use across future PowerShell sessions, please use Set-LockpathAuthentication instead.' -Level Warning
        return $global:gitHubApiPassword
    }

    if ((-not (Get-LockpathConfiguration -Name SuppressNoPasswordWarning)) -and
        (-not $script:seenPasswordWarningThisSession)) {
        $script:seenPasswordWarningThisSession = $true
        Write-Log -Message 'This module has not yet been configured with a personal GitHub API Password.  The module can still be used, but GitHub will limit your usage to 60 queries per hour.  You can get a GitHub API Password from https://github.com/settings/Passwords/new (provide a description and check any appropriate scopes).' -Level Warning
    }

    return $null
}

function Test-LockpathAuthenticationConfigured {
    <#
    .SYNOPSIS
        Indicates if a GitHub API Password has been configured for this module via Set-LockpathAuthentication.

    .DESCRIPTION
        Indicates if a GitHub API Password has been configured for this module via Set-LockpathAuthentication.

        The Git repo for this module can be found here: http://aka.ms/PowershellForGitHub

    .OUTPUTS
        Boolean

    .EXAMPLE
        Test-LockpathAuthenticationConfigured

        Returns $true if the session is authenticated; $false otherwise
#>
    [CmdletBinding(SupportsShouldProcess)]
    [Diagnostics.CodeAnalysis.SuppressMessageAttribute("PSShouldProcess", "", Justification = "Methods called within here make use of PSShouldProcess, and the switch is passed on to them inherently.")]
    [OutputType([Boolean])]
    param()

    return (-not [String]::IsNullOrWhiteSpace((Get-AccessPassword)))
}

Initialize-LockpathConfiguration
