# Copyright (c) Microsoft Corporation. All rights reserved.
# Licensed under the MIT License.

<#
.Synopsis
   Tests for GitHubCore.ps1 module
#>

# This is common test code setup logic for all Pester test files
$moduleRootPath = Split-Path -Path $PSScriptRoot -Parent
. (Join-Path -Path $moduleRootPath -ChildPath 'Tests\Common.ps1')

try
{
    Describe 'Testing ConvertTo-SmarterObject behavior' {
        InModuleScope PowerShellForGitHub {
            $jsonConversionDepth = 20

            Context 'When a property is a simple type' {
                $original = [PSCustomObject]@{
                    'prop1' = 'value1'
                    'prop2' = 3
                    'prop3' = $null
                }

                $converted = ConvertTo-SmarterObject -InputObject $original

                It 'Should return the same values' {
                    $originalJson = (ConvertTo-Json -InputObject $original -Depth $jsonConversionDepth)
                    $convertedJson = (ConvertTo-Json -InputObject $converted -Depth $jsonConversionDepth)
                    $originalJson -eq $convertedJson | Should be $true
                }
            }

            Context 'When a property is a PSCustomObject' {
                $original = [PSCustomObject]@{
                    'prop1' = [PSCustomObject]@{
                        'prop1' = 'value1'
                        'prop2' = 3
                        'prop3' = $null
                    }
                'prop2' = 3
                'prop3' = $null
            }

                $converted = ConvertTo-SmarterObject -InputObject $original

                It 'Should return the correct values' {
                    $originalJson = (ConvertTo-Json -InputObject $original -Depth $jsonConversionDepth)
                    $convertedJson = (ConvertTo-Json -InputObject $converted -Depth $jsonConversionDepth)
                    $originalJson -eq $convertedJson | Should be $true
                }
            }

            Context 'When a known date property has a date string' {
                $date = Get-Date
                $dateString = $date.ToUniversalTime().ToString('o')
                $original = [PSCustomObject]@{
                    'prop1' = $dateString
                    'closed_at' = $dateString
                    'committed_at' = $dateString
                    'completed_at' = $dateString
                    'created_at' = $dateString
                    'date' = $dateString
                    'due_on' = $dateString
                    'last_edited_at' = $dateString
                    'last_read_at' = $dateString
                    'merged_at' = $dateString
                    'published_at' = $dateString
                    'pushed_at' = $dateString
                    'starred_at' = $dateString
                    'started_at' = $dateString
                    'submitted_at' = $dateString
                    'timestamp' = $dateString
                    'updated_at' = $dateString
                }

                $converted = ConvertTo-SmarterObject -InputObject $original

                It 'Should convert the value to a [DateTime]' {
                    $converted.closed_at -is [DateTime] | Should be $true
                    $converted.committed_at -is [DateTime] | Should be $true
                    $converted.completed_at -is [DateTime] | Should be $true
                    $converted.created_at -is [DateTime] | Should be $true
                    $converted.date -is [DateTime] | Should be $true
                    $converted.due_on -is [DateTime] | Should be $true
                    $converted.last_edited_at -is [DateTime] | Should be $true
                    $converted.last_read_at -is [DateTime] | Should be $true
                    $converted.merged_at -is [DateTime] | Should be $true
                    $converted.published_at -is [DateTime] | Should be $true
                    $converted.pushed_at -is [DateTime] | Should be $true
                    $converted.starred_at -is [DateTime] | Should be $true
                    $converted.started_at -is [DateTime] | Should be $true
                    $converted.submitted_at -is [DateTime] | Should be $true
                    $converted.timestamp -is [DateTime] | Should be $true
                    $converted.updated_at -is [DateTime] | Should be $true
                }

                It 'Should NOT convert the value to a [DateTime] if it''s not a known property' {
                    $converted.prop1 -is [DateTime] | Should be $false
                }
            }

            Context 'When a known date property has a null, empty or invalid date string' {
                $original = [PSCustomObject]@{
                    'closed_at' = $null
                    'committed_at' = '123'
                    'completed_at' = ''
                    'created_at' = 123
                    'date' = $null
                    'due_on' = '123'
                    'last_edited_at' = ''
                    'last_read_at' = 123
                    'merged_at' = $null
                    'published_at' = '123'
                    'pushed_at' = ''
                    'starred_at' = 123
                    'started_at' = $null
                    'submitted_at' = '123'
                    'timestamp' = ''
                    'updated_at' = 123
                }

                $converted = ConvertTo-SmarterObject -InputObject $original

                It 'Should keep the existing value' {
                    $original.closed_at -eq $converted.closed_at | Should be $true
                    $original.committed_at -eq $converted.committed_at | Should be $true
                    $original.completed_at -eq $converted.completed_at | Should be $true
                    $original.created_at -eq $converted.created_at | Should be $true
                    $original.date -eq $converted.date | Should be $true
                    $original.due_on -eq $converted.due_on | Should be $true
                    $original.last_edited_at -eq $converted.last_edited_at | Should be $true
                    $original.last_read_at -eq $converted.last_read_at | Should be $true
                    $original.merged_at -eq $converted.merged_at | Should be $true
                    $original.published_at -eq $converted.published_at | Should be $true
                    $original.pushed_at -eq $converted.pushed_at | Should be $true
                    $original.starred_at -eq $converted.starred_at | Should be $true
                    $original.started_at -eq $converted.started_at | Should be $true
                    $original.submitted_at -eq $converted.submitted_at | Should be $true
                    $original.timestamp -eq $converted.timestamp | Should be $true
                    $original.updated_at -eq $converted.updated_at | Should be $true
                }
            }

            Context 'When an object has an empty array' {
                $original = [PSCustomObject]@{
                    'prop1' = 'value1'
                    'prop2' = 3
                    'prop3' = @()
                    'prop4' = $null
                }

                $converted = ConvertTo-SmarterObject -InputObject $original

                It 'Should still be an empty array after conversion' {
                    $originalJson = (ConvertTo-Json -InputObject $original -Depth $jsonConversionDepth)
                    $convertedJson = (ConvertTo-Json -InputObject $converted -Depth $jsonConversionDepth)
                    $originalJson -eq $convertedJson | Should be $true
                }
            }

            Context 'When an object has a single item array' {
                $original = [PSCustomObject]@{
                    'prop1' = 'value1'
                    'prop2' = 3
                    'prop3' = @(1)
                    'prop4' = $null
                }

                $converted = ConvertTo-SmarterObject -InputObject $original

                It 'Should still be a single item array after conversion' {
                    $originalJson = (ConvertTo-Json -InputObject $original -Depth $jsonConversionDepth)
                    $convertedJson = (ConvertTo-Json -InputObject $converted -Depth $jsonConversionDepth)
                    $originalJson -eq $convertedJson | Should be $true
                }
            }

            Context 'When an object has a multi-item array' {
                $original = [PSCustomObject]@{
                    'prop1' = 'value1'
                    'prop2' = 3
                    'prop3' = @(1, 2)
                    'prop4' = $null
                }

                $converted = ConvertTo-SmarterObject -InputObject $original

                It 'Should still be a multi item array after conversion' {
                    $originalJson = (ConvertTo-Json -InputObject $original -Depth $jsonConversionDepth)
                    $convertedJson = (ConvertTo-Json -InputObject $converted -Depth $jsonConversionDepth)
                    $originalJson -eq $convertedJson | Should be $true
                }
            }
        }
    }
}
finally
{
    if (Test-Path -Path $script:originalConfigFile -PathType Leaf)
    {
        # Restore the user's configuration to its pre-test state
        Restore-GitHubConfiguration -Path $script:originalConfigFile
        $script:originalConfigFile = $null
    }
}
