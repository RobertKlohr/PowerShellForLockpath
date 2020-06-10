#TODO Rework configuration settings.
#TODO All settings are written to file and assumed to be in the file to work.
#TODO remove all references to session only in comments and logging text.
#TODO Remove all "session-only" code.
#TODO Remove -disable logging code. Everything is logged.
#TODO Rework all API call functions to only pass UriFragment (strip starting and end "/") method and description.
#TODO add switch for each call for serialized vs. raw format for content returned json vs. PsCustomObject
#TODO background looping job for calling Lockpath Ping API call to keep session alive. Look at Keep Alive Script
#TODO add badges to readme.md file.  See examples from PowershellForGitHub below.
#TODO check quotes single (default) vs. double (only around variables)
#TODO check and set cmdlet binding output settings on each function
#TODO set $result variable in each function to an empty variable of the correct type at the beginning of the function

# [![[GitHub version]](https://badge.fury.io/gh/microsoft%2FPowerShellForGitHub.svg)](https://badge.fury.io/gh/microsoft%2FPowerShellForGitHub)
# [![Build status](https://dev.azure.com/ms/PowerShellForGitHub/_apis/build/status/PowerShellForGitHub-CI?branchName=master)](https://dev.azure.com/ms/PowerShellForGitHub/_build/latest?definitionId=109&branchName=master)

# this psm1 is for local testing and development use only

# dot source the parent import for local development variables
. $PSScriptRoot\Imports.ps1

# discover all ps1 file(s) in Public and Private paths

$itemSplat = @{
    Filter      = '*.ps1'
    Recurse     = $true
    ErrorAction = 'Stop'
}
try {
    $public = @(Get-ChildItem -Path "$PSScriptRoot\Public" @itemSplat)
    $private = @(Get-ChildItem -Path "$PSScriptRoot\Private" @itemSplat)
} catch {
    Write-Error $_
    throw "Unable to get get file information from Public & Private src."
}

# dot source all .ps1 file(s) found
foreach ($file in @($public + $private)) {
    try {
        . $file.FullName
    } catch {
        throw "Unable to dot source [$($file.FullName)]"

    }
}

function Get-PD {
    [CmdletBinding()]
    Param()
    $MyInvocation.MyCommand.Module.PrivateData
}

$MyPD = Get-PD
if ($MyPD.Count -eq 0) {
    Export-ModuleMember
}

# export all public functions
#Export-ModuleMember -Function $public.Basename


Initialize-LockpathConfiguration

# Export-ModuleMember -Variable 'configuration'
