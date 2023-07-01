# PowerShellForLockpath

[![Build status](https://ci.appveyor.com/api/projects/status/github/RobertKlohr/PowerShellForLockpath?branch=master&svg=true)](https://ci.appveyor.com/project/RobertKlohr/powershellforlockpath)

## Table of Contents

- [PowerShellForLockpath](#powershellforlockpath)
  - [Table of Contents](#table-of-contents)
  - [Overview](#overview)
  - [Current API Support](#current-api-support)
  - [Installation](#installation)
  - [Configuration](#configuration)
  - [Usage](#usage)
  - [Logging](#logging)
  - [Developing and Contributing](#developing-and-contributing)
  - [Creating a Release](#creating-a-release)
  - [Versioning](#versioning)
  - [Code of Conduct](#code-of-conduct)
  - [Maintainers](#maintainers)
  - [Legal and Licensing](#legal-and-licensing)
  - [Acknowledgements](#acknowledgements)

----------

## Overview

This is a [PowerShell](https://aka.ms/powershell) [module](https://technet.microsoft.com/en-us/library/dd901839.aspx)
that provides command-line interaction and automation for the [Lockpath API](https://www.lockpath.com/).

----------

## Current API Support

At present this module supports all API methods except IssueAssessments.

Development is ongoing, with the goal to add broad support for the entire API set.

For a comprehensive look at what work is remaining to be API Complete, refer to [Change Log](CHANGELOG.md).

Review [examples](USAGE.md#examples) to see how the module can be used to accomplish some of these tasks.

----------

## API Documentation

There is an [Insomnia](https://insomnia.rest/) v4 collection configuration
file in [docs/api/insomnia](/docs/api/insomnia/).

There is also an set of HTML files that provides an interactive version of the Insomnia collection that requires a web server to
view in [docs/api/wwww](/docs/api/www/).

----------

## Installation

You can get latest release of the PowerShellForLockpath on the [PowerShell Gallery](https://www.powershellgallery.com/packages/PowerShellForLockpath)

```PowerShell
Install-Module -Name PowerShellForLockpath
```

----------

## Configuration

A number of configuration options exist with this module and they can be configured with `Set-LockpathConfiguration`.
For a full explanation of all possible configurations, run the following:

 ```powershell
Get-Help Set-LockpathConfiguration -ShowWindow
```

For example you can save yourself a lot of typing by configuring the default PageIndex and/or PageSize
that you work with.  You can always override these values by explicitly providing a value for the parameter
in an individual command, but for the common scenario, you'd have less typing to do.

 ```powershell
Set-LockpathConfiguration -PageIndex 0
Set-LockpathConfiguration -PageSize 500
```

There are more great configuration options available.  Just review the help for that command for
the most up-to-date list!

----------

## Usage

Example command:

```powershell
$issues = Get-LockpathUser -id 6
```

For more example commands, please refer to [USAGE](USAGE.md#examples).

----------

## Logging

All commands and errors will log to the console, as well as to a log file.

For more example commands, please refer to [USAGE](USAGE.md#examples).

----------

## Developing and Contributing

Please see the [Contribution Guide](CONTRIBUTING.md) for information on how to develop and
contribute.

If you have any problems, please consult [GitHub Issues](https://github.com/RobertKlohr/PowerShellForLockpath/issues)
to see if has already been discussed.

If you do not see your problem captured, please file [feedback](CONTRIBUTING.md#feedback).

----------

## Creating a Release

================

- Update changelog (`changelog.md`) with the new version number based on  Semantic Versioning (SemVer) version 2.0.0 <https://semver.org/spec/v2.0.0.html>.

<!-- When updating the changelog please follow the same pattern as that of previous change sets
(otherwise this may break the next step).

- Import the ReleaseMaker module and execute `New-Release` cmdlet to perform the following actions.
  - Update module manifest (engine/PSScriptAnalyzer.psd1) with the new version number and change set

```powershell
    PS> Import-Module .\Utils\ReleaseMaker.psm1
    PS> New-Release
``` -->

- Sign the binaries and PowerShell files in the release build and publish the module to [PowerShell Gallery](www.powershellgallery.com).
- Draft a new release on github and tag `master` with the new version number.

## Versioning

This module uses Semantic Versioning (SemVer) version 2.0.0 <https://semver.org/spec/v2.0.0.html>.

----------

## Code of Conduct

For more info, see [Code of Conduct](CODE_OF_CONDUCT.md)

----------

## Maintainers

- [Robert Klohr](https://github.com/robertklohr)

----------

## Legal and Licensing

PowerShellForLockpath is licensed under the [MIT license](LICENSE).

## Acknowledgements

[Gregory Schier](https://schier.co/) - For creating the [Insomnia](https://insomnia.rest) [Open
Source](https://github.com/Kong/insomnia) API Client.\
[Oliver Lachlan](https://github.com/olivierlacan) - For creating the [Keep a
Changelog](https://github.com/olivierlacan/keep-a-changelog) format.\
[Tom Preston-Werner](https://github.com/mojombo) - For authoring the [Semantic Versioning
Specification](https://github.com/semver/semver).
