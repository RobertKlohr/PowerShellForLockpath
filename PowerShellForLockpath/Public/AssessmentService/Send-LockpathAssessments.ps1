function Send-LockpathAssessments {
    <#
    .SYNOPSIS
        Issue an assessment.

    .DESCRIPTION
        Issue an assessment.

        Internal assessments can be issued with either immediate, onetime or recurring frequency.

        Vendor assessments can be issued with either immediate or recurring frequency.

        The Git repo for this module can be found here: https://github.com/RobertKlohr/PowerShellForLockpath

    .PARAMETER Attributes
        The list of fields and values to configure the assessment.

    .EXAMPLE
        Send-LockpathAssessments

    .INPUTS
        String

    .OUTPUTS
        String

    .NOTES
        Native API Request: https://[InstanceName]:[InstancePort]/AssessmentService/IssueAssessment

        The authentication account must have Read and Update General Access permissions for the specific component,
        record and field.

    .LINK
        https://github.com/RobertKlohr/PowerShellForLockpath/wiki
    #>

    <# TODO The current (5.7) API guide only has XML examples for the request body and none of the body attribute are defined.  Until this is documented this function is not exported in the module.
    #>

    [CmdletBinding(
        ConfirmImpact = 'Medium',
        PositionalBinding = $false,
        SupportsShouldProcess = $true)]
    [OutputType('System.String')]

    param(
        [Parameter(Mandatory = $true,
            ValueFromPipeline = $true,
            ValueFromPipelineByPropertyName = $true)]
        [String] $AssessmentRequest
    )

    begin {
        Write-LockpathInvocationLog -Confirm:$false -WhatIf:$false
    }

    process {
        $params = @{
            'UriFragment' = 'AssessmentService/IssueAssessment'
            'Method'      = 'POST'
            'Description' = "Issuing Assessment with attributes $($AssessmentRequest | ConvertTo-Json -Depth $Script:configuration.jsonConversionDepth -Compress)"
            'Body'        = $AssessmentRequest
        }

        if ($PSCmdlet.ShouldProcess("Issuing Assessment with attributes: $([environment]::NewLine) $($params.Body)", "attributes $($params.Body)", 'Issuing Assessment with attributes:')) {
            [String] $result = Invoke-LockpathRestMethod @params -Confirm:$false
            return $result
        } else {
            Write-LockpathLog -Message "$($PSCmdlet.CommandRuntime.ToString()) ShouldProcess confirmation was denied." -Level Verbose -Confirm:$false -WhatIf:$false
        }
    }

    end {
    }
}
