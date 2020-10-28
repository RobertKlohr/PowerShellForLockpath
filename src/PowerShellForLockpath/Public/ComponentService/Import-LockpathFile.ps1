function Import-LockpathFile {
    #TODO need to test
    <#
    .SYNOPSIS
        Queues a job to import a file for a defined import template.

    .DESCRIPTION
        Queues a job to import a file for a defined import template.

    .PARAMETER ComponentAlias
        Specifies the system alias of the component as a string. The component alias may be found by using
        Get-LockpathComponentList.

    .EXAMPLE
        Import-LockpathFile -ComponentAlias 'Vendors' -ImportTemplateName 'Load Vendor from API' -FilePath 'c:\temp\test.txt' -RunAsSystem

    .INPUTS
        System.IO.FileInfo, System.String

    .OUTPUTS
        System.String

    .NOTES
        The authentication account must have Read, Create, Update, and Import/Bulk General Access permissions to
        the defined table.

        To enable the Run As System option, the authentication account must have also have Read,
        Create, and Update Administrative Access permissions to the defined table.

    .LINK
        https://github.com/RobertKlohr/PowerShellForLockpath
    #>

    [CmdletBinding(
        ConfirmImpact = 'Medium',
        PositionalBinding = $false,
        SupportsShouldProcess = $true)]
    [OutputType('System.String')]

    param(
        [Parameter(
            Mandatory = $true,
            Position = 0,
            ValueFromPipeline = $true,
            ValueFromPipelineByPropertyName = $true)]
        [Alias("Alias")]
        [ValidateLength(1, 128)]
        [string] $ComponentAlias,

        [Parameter(
            Mandatory = $true,
            Position = 0,
            ValueFromPipeline = $true,
            ValueFromPipelineByPropertyName = $true)]
        [Alias("Template")]
        [ValidateLength(1, 128)]
        [string] $ImportTemplateName,

        [Parameter(
            Mandatory = $true,
            ValueFromPipeline = $true,
            ValueFromPipelineByPropertyName = $true)]
        [Alias("File")]
        [System.IO.FileInfo] $FilePath,

        [Parameter(
            ValueFromPipeline = $true,
            ValueFromPipelineByPropertyName = $true)]
        [Alias("System")]
        [switch] $RunAsSystem
    )

    begin {
        Write-LockpathInvocationLog -Confirm:$false -WhatIf:$false
    }

    process {
        $fileData = [Convert]::ToBase64String([IO.File]::ReadAllBytes($FilePath))

        $Body = [ordered]@{
            'tableAlias'         = $ComponentAlias
            'importTemplateName' = $ImportTemplateName
            'fileName'           = $FilePath.Name
            'fileData'           = $fileData
            'runAsSystem'        = $RunAsSystem
        }

        $params = @{
            'UriFragment' = 'ComponentService/ImportFile'
            'Method'      = 'POST'
            'Description' = "Importing file: $($FilePath.Name) to component alias: $ComponentAlias, using import template: $ImportTemplateName"
            'Body'        = $Body | ConvertTo-Json -Depth 10
        }

        if ($PSCmdlet.ShouldProcess("Importing: $([environment]::NewLine) file: $($FilePath.Name) to component alias: $ComponentAlias, using import template: $ImportTemplateName", "file: $($FilePath.Name) to component alias: $ComponentAlias, using import template: $ImportTemplateName", 'Importing:')) {
            [string] $result = Invoke-LockpathRestMethod @params -Confirm:$false
            return $result
        } else {
            Write-LockpathLog -Message "$($PSCmdlet.CommandRuntime.ToString()) ShouldProcess confirmation was denied." -Level Verbose -Confirm:$false -WhatIf:$false
        }
    }

    end {
    }
}
