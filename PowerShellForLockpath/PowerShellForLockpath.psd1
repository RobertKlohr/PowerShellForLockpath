#
# Module manifest for module 'PowerShellForLockpath'
#
# Generated by: Robert Klohr
#
# Generated on: 02/01/2020
#

@{

    # Script module or binary module file associated with this manifest.
    RootModule           = 'PowerShellForLockpath.psm1'

    # Version number of this module.
    ModuleVersion        = '0.0.1'

    # Supported PSEditions CompatiblePSEditions = @()

    # ID used to uniquely identify this module
    GUID                 = '8a816066-b698-489e-bcaa-b680bea36517'

    # Author of this module
    Author               = 'Robert Klohr'

    # Company or vendor of this module
    CompanyName          = 'Robert Klohr'

    # Copyright statement for this module
    Copyright            = '(c) 2020 Robert Klohr. All rights reserved.'

    # Description of the functionality provided by this module
    Description          = 'PowerShell wrapper for the Lockpath platform API.'

    # Minimum version of the Windows PowerShell engine required by this module
    PowerShellVersion    = '7.0'

    # Name of the Windows PowerShell host required by this module PowerShellHostName     = ''

    # Modules that must be imported into the global environment prior to importing this module from the repository
    # RequiredModules       = @()

    # Type files (.ps1xml) to be loaded when importing this module TypesToProcess = @()

    # Format files (.ps1xml) to be loaded when importing this module FormatsToProcess = @()

    # Modules to import as nested modules of the module specified in RootModule/ModuleToProcess
    NestedModules        = @(
        # Ideally this list would be kept completely alphabetical, but other scripts (like GitHubConfiguration.ps1)
        # depend on some of the code in Helpers being around at load time.
        # TODO: See if helpers needs to be loaded first and edit the comments and order as necessary.
    )

    # Functions to export from this module, for best performance, do not use wildcards and do not delete the entry,
    # use an empty array if there are no functions to export.
    FunctionsToExport    = @(
        'Find-LockpathField',
        'Get-LockpathApiUserDetails'
        'Get-LockpathComponent',
        'Get-LockpathComponentByAlias',
        'Get-LockpathComponentList',
        'Get-LockpathField',
        'Get-LockpathFieldList',
        'Get-LockpathFieldLookupReportColumns',
        'Get-LockpathGroup',
        'Get-LockpathGroups',
        'Get-LockpathGroupsDetails',
        'Get-LockpathRecord',
        'Get-LockpathRecordAttachment',
        'Get-LockpathRecordAttachments',
        'Get-LockpathRecordCount',
        'Get-LockpathRecordDetail',
        'Get-LockpathRecords',
        'Get-LockpathRecordsAvailableForLookup',
        'Get-LockpathRecordsDetails',
        'Get-LockpathReport',
        'Get-LockpathUser',
        'Get-LockpathUserCount',
        'Get-LockpathUsers',
        'Get-LockpathUsersDetails',
        'Get-LockpathWorkflow',
        'Get-LockpathWorkflows',
        'Import-LockpathConfiguration',
        'Import-LockpathFile',
        'New-LockpathGroup',
        'New-LockpathRecord',
        'New-LockpathUser',
        'Remove-LockpathCredential',
        'Remove-LockpathGroup',
        'Remove-LockpathRecord',
        'Remove-LockpathRecordAttachments',
        'Remove-LockpathUser',
        'Reset-LockpathConfiguration',
        # See todo comment in function file as to why this is not implemented
        # 'Send-LockpathAssessments',
        'Send-LockpathKeepAlive',
        'Send-LockpathLogin',
        'Send-LockpathLogout',
        'Send-LockpathPing',
        'Set-LockpathConfiguration',
        'Set-LockpathCredential',
        'Set-LockpathGroup',
        'Set-LockpathRecord',
        'Set-LockpathRecordAttachments',
        'Set-LockpathRecordTransition',
        'Set-LockpathRecordVote',
        'Set-LockpathUser',
        'Set-LockpathUsers',
        'Show-LockpathConfiguration',
        'Test-LockpathAuthentication',
        # FIXME The following private funcdtions are exported during development
        'Initialize-LockpathConfiguration',
        'Invoke-LockpathRestMethod',
        'Read-LockpathAuthenticationCookie',
        'Read-LockpathConfiguration',
        'Read-LockpathCredential',
        'Resolve-LockpathConfigurationPropertyValue',
        'Write-LockpathInvocationLog',
        'Write-LockpathLog'
    )

    # Cmdlets to export from this module, for best performance, do not use wildcards and do not delete the entry,
    # use an empty array if there are no cmdlets to export.
    CmdletsToExport      = @()

    # Variables to export from this module VariablesToExport     = '*'
    # Aliases to export from this module, for best performance, do not use wildcards and do not delete the entry,
    # use an empty array if there are no aliases to export.
    AliasesToExport      = @()

    # DSC resources to export from this module
    DscResourcesToExport = @()

    # List of all modules packaged with this module
    ModuleList           = @()

    # List of all files packaged with this module
    FileList             = @()

    # Private data to pass to the module specified in RootModule/ModuleToProcess. This may also contain a PSData
    # Hashtable with additional module metadata used by PowerShell.
    PrivateData          = @{

        FromPSD = $true

        PSData  = @{

            # Tags applied to this module. These help with module discovery in online galleries.
            Tags         = @('Lockpath', 'API', 'PowerShell')

            # A URL to the license for this module.
            LicenseUri   = 'https://github.com/RobertKlohr/PowerShellForLockpath/blob/master/LICENSE'

            # A URL to the main website for this project.
            ProjectUri   = 'https://github.com/RobertKlohr/PowerShellForLockpath'

            # A URL to an icon representing this module. IconUri = ''

            # ReleaseNotes of this module
            ReleaseNotes = 'Initial Release'

        } # End of PSData Hashtable

    } # End of PrivateData Hashtable

    # HelpInfo URI of this module HelpInfoURI = ''

    # Default prefix for commands exported from this module. Override the default prefix using Import-Module
    # -Prefix.
    #DefaultCommandPrefix = 'Lockpath'
}
