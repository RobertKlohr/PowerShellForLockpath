# Assumes the build script has the same name basename as the module
$moduleName = ($myInvocation.MyCommand.Name).Split('.')[0]

# Get public functions based on file names under .\src\public
# $publicFunctions = Get-ChildItem -Path .\src\public\ -Recurse | ForEach-Object -Process { if (!($_.PSIsContainer)) { [System.IO.Path]::GetFileNameWithoutExtension($_) } }

$publicFunctions = Get-ChildItem -Path .\src\ -Recurse | ForEach-Object -Process { if (!($_.PSIsContainer)) { [System.IO.Path]::GetFileNameWithoutExtension($_) } }

$version = '1.0.0'
# $prerelease = 'RC2'

if ($prerelease.Length -gt 0) {
    $buildPath = "$PSScriptRoot\output\$moduleName\$version-$prerelease"
} else {
    $buildPath = "$PSScriptRoot\output\$moduleName\$version"
}

$releaseNotes = "# V$version"

$manifestParameters = @{
    'Author'               = 'Robert Klohr'
    'CompanyName'          = 'Cambia Health Solutions'
    'CompatiblePSEditions' = @('Core')
    'Copyright'            = "(c) $(Get-Date -f yyyy) Cambia Health Solutions. All rights reserved."
    'Description'          = 'Adds a PowerShell wrapper to the Lockpath API along with some useful scripts.'
    'FileList'             = @("$moduleName.psm1")
    'FunctionsToExport'    = @($publicFunctions)
    'ModuleVersion'        = $version
    'Path'                 = "$buildPath\$moduleName.psd1"
    'PowerShellVersion'    = "$($PSVersionTable.PSVersion.Major).0.0"
    'ReleaseNotes'         = $releaseNotes
    'RequiredAssemblies'   = ''
    'RootModule'           = "$moduleName.psm1"
}

if ($prerelease.Length -gt 0) {
    $manifestParameters.Add('Prerelease', $prerelease)
}

if (Get-Module -Name $moduleName) {
    Remove-Module -Name $moduleName -Force
}

if ((Test-Path -Path $buildPath) -eq $False) {
    New-Item -Path $buildPath -ItemType directory -Force
}

Remove-Item "$buildPath\*.*" -Force

$itemSplat = @{
    Filter      = '*.ps1'
    Recurse     = $true
    ErrorAction = 'Stop'
}

# get all ps1 files under the src folder
$files = @(Get-ChildItem -Path '.\src\' @itemSplat)

New-ModuleManifest @manifestParameters

# combine all files into psm1
foreach ($file in $files) {
    $from = Get-Content $file.FullName
    Add-Content "$buildPath\$moduleName.psm1" -Value $from
}

Add-Content "$buildPath\$moduleName.psm1" -Value 'Initialize-LockpathConfiguration'
