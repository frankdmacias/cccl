
Param(
    [Parameter(Mandatory = $true)]
    [Alias("cxx")]
    [ValidateNotNullOrEmpty()]
    [ValidateSet(11, 14, 17, 20)]
    [int]$CXX_STANDARD = 17
)

$CURRENT_PATH = Split-Path $pwd -leaf
If($CURRENT_PATH -ne "ci") {
    Write-Host "Moving to ci folder"
    pushd "$PSScriptRoot/.."
}

Remove-Module -Name build_common
Import-Module $PSScriptRoot/build_common.psm1 -ArgumentList $CXX_STANDARD

$PRESET = "cub-cpp$CXX_STANDARD"
$CMAKE_OPTIONS = ""

if ($CL_VERSION -lt [version]"19.20") {
    $CMAKE_OPTIONS += "-DCUB_IGNORE_DEPRECATED_COMPILER=ON "
}

configure_and_build_preset "CUB" "$PRESET" "$CMAKE_OPTIONS"

If($CURRENT_PATH -ne "ci") {
    popd
}
