function Import-LockpathFile {
    <#
    .SYNOPSIS
        Queues a job to import a file for a defined import template.

    .DESCRIPTION
        Queues a job to import a file for a defined import template.

        The Git repo for this module can be found here: https://github.com/RobertKlohr/PowerShellForLockpath

    .PARAMETER ComponentAlias
        Specifies the system alias of the component as a string. The component alias may be found by using
        Get-LockpathComponentList.

    .PARAMETER ImportTemplateName
        Specifies the system name of the import template configured in the component.

    .PARAMETER FilePath
        Specifies the absolute path to the file being imported.

    .PARAMETER RunAsSystem
        Specifies if the records being imported or updated will show the created by and/or updated by attributes as
        the system. If set to false the creator and/or updated by attributes will be set to the account used to
        authenticate the API call.

        Defaults to the value in the configuration file if not supplied.

    .EXAMPLE
        Import-LockpathFile -ComponentAlias 'Vendors' -ImportTemplateName 'Load Vendor from API' -FilePath 'c:\temp\test.txt' -RunAsSystem

    .INPUTS
        IO.FileInfo, String

    .OUTPUTS
        String

    .NOTES
        Native API Request: https://[InstanceName]:[InstancePort]/ComponentService/ImportFile

        The authentication account must have Read, Create, Update, and Import/Bulk General Access permissions to
        the defined table.

        To enable the Run As System option, the authentication account must have also have Read,
        Create, and Update Administrative Access permissions to the defined table.

    .LINK
        https://github.com/RobertKlohr/PowerShellForLockpath/wiki
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
        [ValidateLength(1, 128)]
        [String] $ComponentAlias,

        [Parameter(
            Mandatory = $true,
            Position = 0,
            ValueFromPipeline = $true,
            ValueFromPipelineByPropertyName = $true)]
        [ValidateLength(1, 128)]
        [String] $ImportTemplateName,

        [Parameter(Mandatory = $true,
            ValueFromPipeline = $true,
            ValueFromPipelineByPropertyName = $true)]
        [IO.FileInfo] $FilePath,

        [Parameter(
            ValueFromPipeline = $true,
            ValueFromPipelineByPropertyName = $true)]
        [switch] $RunAsSystem = $(Get-LockpathConfiguration -Name 'runAsSystem')
    )

    begin {
        Write-LockpathInvocationLog -ExcludeParameter FilePath -Confirm:$false -WhatIf:$false
    }

    process {
        $fileData = [Convert]::ToBase64String([IO.File]::ReadAllBytes($FilePath))

        $Body = [ordered]@{
            'tableAlias'         = $ComponentAlias
            'importTemplateName' = $ImportTemplateName
            'fileName'           = $FilePath.Name
            'fileData'           = $fileData
            'runAsSystem'        = $RunAsSystem.IsPresent.ToString()
        }

        $params = @{
            'UriFragment' = 'ComponentService/ImportFile'
            'Method'      = 'POST'
            'Description' = "Importing file: $($FilePath.Name) to component alias: $ComponentAlias, using import template: $ImportTemplateName"
            'Body'        = $Body | ConvertTo-Json -Depth 10
        }

        if ($PSCmdlet.ShouldProcess("Importing: $([environment]::NewLine) file: $($FilePath.Name) to component alias: $ComponentAlias, using import template: $ImportTemplateName", "file: $($FilePath.Name) to component alias: $ComponentAlias, using import template: $ImportTemplateName", 'Importing:')) {
            [String] $result = Invoke-LockpathRestMethod @params -Confirm:$false
            return $result
        } else {
            Write-LockpathLog -Message "$($PSCmdlet.CommandRuntime.ToString()) ShouldProcess confirmation was denied." -Level Verbose -Confirm:$false -WhatIf:$false
        }
    }

    end {
    }
}
