if ($env:APPVEYOR_REPO_BRANCH -ne "master") {
	exit
}

$version = $env:APPVEYOR_BUILD_VERSION

if ($env:APPVEYOR_REPO_TAG_NAME -ne $null) {
  $splits = $env:APPVEYOR_REPO_TAG_NAME.Split('/');
  if ($splits.Length -eq 2) {
    $version = $splits[1]
  }
} else {
  $formattedBuildNumber = [convert]::ToInt32($env:APPVEYOR_BUILD_NUMBER, 10).ToString("000000")
  Get-ChildItem -Recurse -Filter "*.nuspec" | ForEach-Object {
    $nuspec = [xml](Get-Content $_.FullName)
    $nuspecVersion = $nuspec.package.metadata.version
    $version = "$nuspecVersion-pre$formattedBuildNumber"
  }
}

Write-Host Update appveyor build version: $version
Update-AppveyorBuild -Version $version