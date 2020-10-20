function verb-noun {
    [CmdletBinding()]
    [OutputType('System.Int32')]

    param(
        [Parameter(Mandatory = $true)]
        [string]
        $Param1
    )

    begin {
    }

    process {

    }

    end {
        Return ${Return}
    }
}
