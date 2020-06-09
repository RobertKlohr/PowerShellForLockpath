# PowerShellForLockpath

#### Table of Contents

*   [Overview](#overview)
*   [Current API Support](#current-api-support)
*   [Installation](#installation)
*   [Configuration](#configuration)
*   [Usage](#usage)
*   [Logging](#logging)
*   [Developing and Contributing](#developing-and-contributing)
*   [Code of Conduct](#code-of-conduct)
*   [Maintainers](#maintainers)
*   [Legal and Licensing](#legal-and-licensing)

----------

## Overview

This is a [PowerShell](https://microsoft.com/powershell) [module](https://technet.microsoft.com/en-us/library/dd901839.aspx)
that provides command-line interaction and automation for the [Lockpath v5.3r API](https://www.lockpath.com/).

----------

## Current API Support

At present, this module can:
 * Query, create and update users
 * Query, update and remove records
 * Query and update fields

Development is ongoing, with the goal to add broad support for the entire API set.

For a comprehensive look at what work is remaining to be API Complete, refer to [Change Log](CHANGELOG.md).

Review [examples](USAGE.md#examples) to see how the module can be used to accomplish some of these tasks.

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
Set-LockpathConfiguration -PageSize 1000
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

## Code of Conduct

For more info, see [Code of Conduct](CODE_OF_CONDUCT.md)

----------

## Maintainers

- [Robert Klohr](https://github.com/robertklohr)

----------

## Legal and Licensing

PowerShellForLockpath is licensed under the [MIT license](LICENSE).
