# Registry Read/Write Utility

# [powershell - Test if registry value exists - Stack Overflow](https://stackoverflow.com/questions/5648931/)
function Test-RegistryKeyValue {
  <#
    .SYNOPSIS
    Tests if a registry value exists.

    .DESCRIPTION
    The usual ways for checking if a registry value exists don't handle when a value simply has an empty or null value.  This function actually checks if a key has a value with a given name.

    .EXAMPLE
    Test-RegistryKeyValue -Path 'hklm:\Software\Carbon\Test' -Name 'Title'

    Returns `True` if `hklm:\Software\Carbon\Test` contains a value named 'Title'.  `False` otherwise.
    #>
  [CmdletBinding()]
  param(
    [Parameter(Mandatory = $true)]
    [string]
    # The path to the registry key where the value should be set.  Will be created if it doesn't exist.
    $Path,

    [Parameter(Mandatory = $true)]
    [string]
    # The name of the value being set.
    $Name
  )

  if ( -not (Test-Path -Path $Path -PathType Container) ) {
    return $false
  }

  $properties = Get-ItemProperty -Path $Path 
  if ( -not $properties ) {
    return $false
  }

  $member = Get-Member -InputObject $properties -Name $Name
  if ( $member ) {
    return $true
  }
  else {
    return $false
  }
}

function Write-RegistryValue {
  [CmdletBinding()]
  param(
    [Parameter(Mandatory = $true)]
    [string]
    $registryPath,
    [Parameter(Mandatory = $true)]
    [string]
    $propertyName,
    [double]
    $rate
  )

  if (Test-RegistryKeyValue $registryPath $propertyName) {
    $value = (Get-ItemProperty -LiteralPath $registryPath).$propertyName
    if ($rate) {
      $value = $value / $rate
    }
    Write-Output "${propertyName}: ${value}"
  }
  else {
    Write-Output "Not exist: ${propertyName}"
  }
}

function Set-RegistryValue {
  [CmdletBinding()]
  param(
    [Parameter(Mandatory = $true)]
    [string]
    $registryPath,
    [Parameter(Mandatory = $true)]
    [string]
    $propertyName,
    $value,
    [string]
    $propertyType
  )

  if (Test-RegistryKeyValue $registryPath $propertyName) {
    Set-ItemProperty -LiteralPath $registryPath -Name $propertyName -Value $value
  }
  else {
    New-ItemProperty -LiteralPath $registryPath -Name $propertyName -PropertyType $propertyType -Value $value |
      out-null
  }
}
