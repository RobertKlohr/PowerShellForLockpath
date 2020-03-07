function Import-LpFile {
    [CmdletBinding()]
    [OutputType([int])]

    #TODO: Work on making this more user friendly, and to only allow valid combinations (parameter sets)
    param(
        # Full URi to the Lockpath instance.
        [Parameter(Mandatory = $false, ValueFromPipeline = $true)]
        $Session,
        # Id of the component
        [Parameter(Mandatory = $true, ValueFromPipeline = $true)]
        [string]
        $TableAlias,
        # The index of the page of result to return. Must be >0.
        [Parameter(Mandatory = $true, ValueFromPipeline = $true)]
        [string]
        $ImportTemplateName,
        # The filter parameters the users must meet to be included.
        [Parameter(Mandatory = $true, ValueFromPipeline = $true)]
        [string]
        $FileName,
        # The filter parameters the users must meet to be included.
        [Parameter(Mandatory = $true, ValueFromPipeline = $true)]
        [string]
        $FileData,
        # The filter parameters the users must meet to be included.
        [Parameter(Mandatory = $false, ValueFromPipeline = $true)]
        [switch]
        $RunAsSystem = $false
    )

    begin {
        $ResourcePath = "/ComponentService/ImportFile"
        $Method = 'POST'

        $Body = [ordered]@{
            "tableAlias"         = $TableAlias
            "importTemplateName" = $ImportTemplateName
            "fileName"           = $FileName
            "fileData"           = $FileData
            "runAsSystem"        = $RunAsSystem.ToBool()
        } | ConvertTo-Json

        $Parameters = @{
            Uri        = $LpUrl + $ResourcePath
            WebSession = $LpSession
            Method     = $Method
            Body       = $Body
        }
    }

    process {
        try {
            $Response = Invoke-RestMethod @parameters -ErrorAction Stop
        } catch {
            # Get the message returned from the server which will be in JSON format
            #$ErrorMessage = $_.ErrorDetails.Message | ConvertFrom-Json | Select -ExpandProperty Message
            $ErrorRecord = New-Object System.Management.Automation.ErrorRecord(
                (New-Object Exception("Exception executing the Invoke-RestMethod cmdlet. $($_.ErrorDetails.Message)")),
                'Invoke-RestMethod',
                [System.Management.Automation.ErrorCategory]$_.CategoryInfo.Category,
                $parameters
            )
            $ErrorRecord.CategoryInfo.Reason = $_.CategoryInfo.Reason;
            $ErrorRecord.CategoryInfo.Activity = $_.InvocationInfo.InvocationName;
            $PSCmdlet.ThrowTerminatingError($ErrorRecord);
        }
    }

    end {
        Return $Response
    }
}
