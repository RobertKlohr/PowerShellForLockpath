#-------------------------------------------------------------------------
Set-Location -Path $PSScriptRoot
#-------------------------------------------------------------------------
$ModuleName = 'PowerShellForLockpath'
$PathToManifest = [System.IO.Path]::Combine('..', '..', $ModuleName, "$ModuleName.psd1")
$PathToModule = [System.IO.Path]::Combine('..', '..', $ModuleName, "$ModuleName.psm1")
#-------------------------------------------------------------------------
Describe 'Module Tests' -Tag Unit {
    Context "Module Tests" {
        It 'Passes Test-ModuleManifest' {
            Test-ModuleManifest -Path $PathToManifest | Should Not BeNullOrEmpty
            $? | Should Be $true
        }#manifestTest
        It 'root module PowerShellForLockpath.psm1 should exist' {
            $PathToModule | Should Exist
            $? | Should Be $true
        }#psm1Exists
        It 'manifest should contain PowerShellForLockpath.psm1' {
            $PathToManifest |
                Should -FileContentMatchExactly "PowerShellForLockpath.psm1"
        }#validPSM1
    }#context_ModuleTests
}#describe_ModuleTests
