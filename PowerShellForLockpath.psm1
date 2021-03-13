# Copyright (c) Robert Klohr. All rights reserved.
# Licensed under the MIT License.

# FIXME this psm1 is for local testing and development use only
# FIXME check all functions with filters
# TODO create credential file for each instance

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
    throw 'Unable to get get file information from Public & Private src.'
}

# dot source all .ps1 file(s) found
foreach ($file in @($public + $private)) {
    try {
        . $file.FullName
    } catch {
        throw "Unable to dot source [$($file.FullName)]"

    }
}

# FIXME clean up before deployment
# function Get-PD {
#     [CmdletBinding()]
#     Param()
#     $MyInvocation.MyCommand.Module.PrivateData
# }

# $MyPD = Get-PD
# if ($MyPD.Count -eq 0) {
#     Export-ModuleMember
# }

# export all public functions
# Export-ModuleMember -Function $public.Basename

Initialize-LockpathConfiguration
Export-ModuleMember -Variable 'LockpathConfig'
