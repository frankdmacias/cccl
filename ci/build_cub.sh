#!/bin/bash

source "$(dirname "$0")/build_common.sh"

# CUB benchmarks require at least CUDA nvcc 11.5 for int128
# Returns "true" if the first version is greater than or equal to the second
version_compare() {
    if [[ "$(printf '%s\n' "$1" "$2" | sort -V | head -n1)" == "$2" ]]; then
        echo "true"
    else
        echo "false"
    fi
}

ENABLE_CUB_BENCHMARKS="false"
ENABLE_CUB_RDC="false"
if [[ "$CUDA_COMPILER" == *nvcc* ]]; then
    ENABLE_CUB_RDC="true"
    NVCC_VERSION=$($CUDA_COMPILER --version | grep release | awk '{print $6}' | cut -c2-)
    if [[ $(version_compare $NVCC_VERSION 11.5) == "true" ]]; then
        ENABLE_CUB_BENCHMARKS="true"
        echo "nvcc version is $NVCC_VERSION. Building CUB benchmarks."
    else
        echo "nvcc version is $NVCC_VERSION. Not building CUB benchmarks because nvcc version is less than 11.5."
    fi
else
    echo "nvcc version is not determined (likely using a non-NVCC compiler). Not building CUB benchmarks."
fi

PRESET="cub-cpp$CXX_STANDARD"

CMAKE_OPTIONS="
    -DCUB_ENABLE_BENCHMARKS="$ENABLE_CUB_BENCHMARKS"\
    -DCUB_ENABLE_RDC_TESTS="$ENABLE_CUB_RDC" \
"

configure_and_build_preset "CUB" "$PRESET" "$CMAKE_OPTIONS"
