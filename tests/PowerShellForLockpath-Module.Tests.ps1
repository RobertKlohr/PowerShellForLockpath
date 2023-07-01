# Copyright (c) Robert Klohr. All rights reserved.
# Licensed under the MIT License.

BeforeAll {
    Set-Location -Path $PSScriptRoot

    $moduleRootPath = Split-Path -Path $PSScriptRoot -Parent
    . (Join-Path -Path $moduleRootPath -ChildPath 'Tests\Set-TestingConfiguration.ps1')

    $script:ModuleName = 'PowerShellForLockpath'
    $script:PathToManifest = [System.IO.Path]::Combine('..', "$ModuleName.psd1")
    $script:PathToModule = [System.IO.Path]::Combine('..', "$ModuleName.psm1")

    # check to see if the module is already in memory and if so remove it and then load it again
    if (Get-Module -Name $ModuleName -ErrorAction 'SilentlyContinue') {
        Remove-Module -Name $ModuleName -Force
    }
    Import-Module $PathToManifest -Force
    $WarningPreference = 'SilentlyContinue'
}

Describe 'Module Tests' -Tag Unit {
    Context 'Module Tests' {
        It 'Passes Test-ModuleManifest' {
            Test-ModuleManifest -Path $PathToManifest | Should -Not -BeNullOrEmpty
        }
        It 'root module PowerShellForLockpath.psm1 should exist' {
            $PathToModule | Should -Exist
            # $? | Should Be $true
        }
        It 'manifest should contain PowerShellForLockpath.psm1' {
            $PathToManifest |
            Should -FileContentMatchExactly 'PowerShellForLockpath.psm1'
        }
    }
}
