Set-StrictMode -Version Latest

Set-Location -Path $PSScriptRoot
$script:ModuleName = 'PowerShellForLockpath'
$script:PathToManifest = [System.IO.Path]::Combine('..', "$ModuleName.psd1")
$script:PathToModule = [System.IO.Path]::Combine('..', "$ModuleName.psm1")

if (Get-Module -Name $ModuleName -ErrorAction 'SilentlyContinue') {
    #if the module is already in memory, remove it
    Remove-Module -Name $ModuleName -Force
}
Import-Module $PathToManifest -Force

# The effective values for this parameter are:

# 1.0
# Prohibits references to uninitialized variables, except for uninitialized variables in strings.
# 2.0
# Prohibits references to uninitialized variables. This includes uninitialized variables in strings.
# Prohibits references to non-existent properties of an object.
# Prohibits function calls that use the syntax for calling methods.
# 3.0
# Prohibits references to uninitialized variables. This includes uninitialized variables in strings.
# Prohibits references to non-existent properties of an object.
# Prohibits function calls that use the syntax for calling methods.
# Prohibit out of bounds or unresolvable array indexes.
