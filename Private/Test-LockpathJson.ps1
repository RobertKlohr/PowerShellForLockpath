# Copyright (c) Robert Klohr. All rights reserved.
# Licensed under the MIT License.

function Test-LockpathJson {
    <#
    .SYNOPSIS
        Tests if value passed into the function is valid JSON.

    .DESCRIPTION
        Tests if value passed into the function is valid JSON. If so it returns the compressed JSON otherwise it returns $false.

        This function is needed until issues https://github.com/PowerShell/PowerShell/issues/11384 and/or https://github.com/PowerShell/PowerShell/pull/11397 are corrected in the Test-Json cmdlet.

        The Git repo for this module can be found here: https://git.io/powershellforlockpath

    .PARAMETER InputObject
        The object to check the value of the requested property.

    .PARAMETER InputObject
        The object to check the value of the requested property.

    .EXAMPLE
        Test-LockpathJson -Input '{"valid":"json"}'

    .EXAMPLE
        Test-LockpathJson -Input '{invalid key:"json"}'

    .EXAMPLE
        Test-LockpathJson -Input '{"valid":2}'

    .EXAMPLE
        Test-LockpathJson -Compress -Input '{
            "valid":"json",
            "line1":"value",
            "line2":"value"
        }'

    .INPUTS
        String

    .OUTPUTS
        String, Boolean

    .NOTES
        # Public helper method.

    .LINK
        https://git.io/powershellforlockpathhelp
    #>

    [CmdletBinding(
        ConfirmImpact = 'Low',
        PositionalBinding = $false
    )]
    [OutputType('System.String')]


    param(
        [Parameter(
            Mandatory = $true,
            Position = 0,
            ValueFromPipeline = $true,
            ValueFromPipelineByPropertyName = $true
        )]
        [String] $Input,

        [Switch] $Compress
    )

    begin {
    }

    process {
        $Input
        $Compress
    }

    end {}
}
