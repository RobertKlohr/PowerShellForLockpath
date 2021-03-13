# Copyright (c) Robert Klohr. All rights reserved.
# Licensed under the MIT License.

#-------------------------------------------------------------------------
Set-Location -Path $PSScriptRoot
#-------------------------------------------------------------------------
$ModuleName = 'PowerShellForLockpath'
$PathToManifest = [System.IO.Path]::Combine('..', '..', $ModuleName, "$ModuleName.psd1")
#-------------------------------------------------------------------------
if (Get-Module -Name $ModuleName -ErrorAction 'SilentlyContinue') {
    #if the module is already in memory, remove it
    Remove-Module -Name $ModuleName -Force
}
Import-Module $PathToManifest -Force
#-------------------------------------------------------------------------
$WarningPreference = 'SilentlyContinue'
#-------------------------------------------------------------------------
#Import-Module $moduleNamePath -Force

InModuleScope 'PowerShellForLockpath' {
    #-------------------------------------------------------------------------
    $WarningPreference = 'SilentlyContinue'
    #-------------------------------------------------------------------------
    Describe 'PowerShellForLockpath Private Function Tests' -Tag Unit {
        Context 'FunctionName' {
            <#
            It 'should ...' {

            }#it
            #>
        }#context_FunctionName
    }#describe_PrivateFunctions
    Describe 'PowerShellForLockpath Public Function Tests' -Tag Unit {
        Context 'FunctionName' {
            <#
                It 'should ...' {

                }#it
                #>
        }#context_FunctionName
    }#describe_testFunctions
}#inModule
