# To Do List

Move this to feature requests in Github issues.

```powershell
Testing
TODO Create a unit test for each function using mocking
TODO Create an integration test for each function
TODO Create an acceptance test against the sandbox instance

Performance Improvements
TODO have log running functions (find-lockpathfields or get-lockpathusersdetails) run using Jobs

Logging
TODO create a CEF logging format configuration that matches the Ambassador CEF format
TODO configure which functions log at various logginglevel settings (private (debug), helper (verbose), public (information), etc.)
TODO update Write-LockpathLog to use a dynamic logging format that is set and saved in the configuration (https://github.com/EsOsO/Logging)
TODO write to windows event log
TODO send syslog
TODO Implement a stopwatch for each function and write the result to the log with a write-lockpathlog call at the end of the function.

Documentation
TODO Create release check list.  Include SemVer updating and changelog updating.
TODO Update inline comments to be Write-Verbose or Write Debug messages
TODO Update the descriptions on each function to highlight API calls to get each parameter. (see Get-LockpathRecordAttachment)
TODO Document in examples sectons having a filter with multiple criteria. ### (@{Shortname = "AccountType"; FilterType = 5; Value = 1 }, @{ Shortname = "Deleted"; FilterType = 5; Value ="true" })

Enhanced Functions
TODO create Find-LockpathUser to be able to search on any field returned by Get-LockpathUser (LDAP, non-LDAP, security roles, etc.)
TODO create Find-LockpathGroup to be able to search on any field returned by Get-LockpathGroup (LDAP, non-LDAP, security roles, etc.)
TODO create a function to find all records that have contain a field where a non-active (deleted or inactive) user is selected
TODO create a function to find field by there alias.
TODO create a function to query users that uses switches and simple parameters (Get-LockpathUesers with no filters and then filter PSObject)
TODO create a function to bulk update users Set-LockpathUsers
TODO create a function that turns specific items back on after a sandbox refresh Reset-LockpathSandbox
TODO create function to find all formula fields (They are field type 1, 2, 3 or 10 that are set readonly and are not system fields.)
TODO create an enhanced version of Get-LockpathRecord that resolves the field Id to the field name
TODO Remove any references to ShortName (keep SystemName)

Helper Functions
TODO create a module to build searchcriteria items (API guide chapter 4.)
TODO create functions to deal with log files extracted by the ambassador service

New Features
TODO Review API calls to see where we can simplify passing parameters.
TODO add switch for each call for serialized vs. raw format for content returned json vs. PsCustomObject

Research

Filter
TODO build filters using individual parameters

[Parameter(
    Mandatory = $false)]
    [ValidateSet('Awareness', 'Full', 'Vendor', 'NotAwareness', 'NotFull', 'NotVendor')]
$AccountType

Build Process
TODO create pester tests
TODO create build pipeline
TODO add badges to readme.md file.  See examples from PowershellForGitHub below

[![[GitHub version]](https://badge.fury.io/gh/microsoft%2FPowerShellForGitHub.svg)](https://badge.fury.io/gh/microsoft%2FPowerShellForGitHub)
[![Build
status](https://dev.azure.com/ms/PowerShellForGitHub/_apis/build/status/PowerShellForGitHub-CI?branchName=master)](https://dev.azure.com/ms/PowerShellForGitHub/_build/latest?definitionId=109&branchName=master)
```
