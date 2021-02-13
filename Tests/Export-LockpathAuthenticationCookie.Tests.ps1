BeforeAll {
    Set-Location -Path $PSScriptRoot
    $script:ModuleName = 'PowerShellForLockpath'
}

InModuleScope $script:ModuleName {
    Describe 'PowerShellForLockpath Export-LockpathAuthenticationCookie Private Function' -Tag Unit {
        Context 'Export-LockpathAuthenticationCookie' {
            <#
            It 'should ...' {

            }#it
            #>
        }
    }
}
