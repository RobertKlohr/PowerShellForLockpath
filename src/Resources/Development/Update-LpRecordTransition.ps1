function verb-noun {
    [CmdletBinding()]
    [OutputType([int])]

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
