# Changes Internet Explorer Timeout setting (ReceiveTimeout).
# Requires reboot after change.

Import-Module $PSScriptRoot/RegistryUtil.psm1

$registryPath = "HKCU:/SOFTWARE/Microsoft/Windows/CurrentVersion/Internet Settings"
$propertyName = "ReceiveTimeout"
$minToMilliSec = 60 * 1000

Write-RegistryValue $registryPath $propertyName $minToMilliSec
$in = Read-Host "New Timeout (min)"
$newTimeout = 0
if (
  -not [double]::TryParse($in, [ref]$newTimeout) -or
  $newTimeout -lt 0
) {
  Write-Host "Canceled."
  Exit
}
Set-RegistryValue $registryPath $propertyName ($newTimeout * $minToMilliSec) "DWord"
Write-RegistryValue $registryPath $propertyName $minToMilliSec
Write-Host "It works after reboot."
