function verb-noun {
    [CmdletBinding()]
    [OutputType([int])]

    param(
        [Parameter(Mandatory = $true)]
        [string]
        $sParam1
    )

    begin {
    }

    process {

    }

    end {
        Return ${Return}
    }
}
