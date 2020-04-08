#TODO update name to Set-DeepCopyObject
function DeepCopy-Object {
    [CmdletBinding()]
    [Diagnostics.CodeAnalysis.SuppressMessageAttribute("PSUseApprovedVerbs", "", Justification = "Intentional.  This isn't exported, and needed to be explicit relative to Copy-Object.")]
    param(
        [Parameter(Mandatory)]
        [PSCustomObject] $InputObject
    )

    Write-InvocationLog

    $memoryStream = New-Object System.IO.MemoryStream
    $binaryFormatter = New-Object System.Runtime.Serialization.Formatters.Binary.BinaryFormatter
    $binaryFormatter.Serialize($memoryStream, $InputObject)
    $memoryStream.Position = 0
    $DeepCopiedObject = $binaryFormatter.Deserialize($memoryStream)
    $memoryStream.Close()

    return $DeepCopiedObject
}
