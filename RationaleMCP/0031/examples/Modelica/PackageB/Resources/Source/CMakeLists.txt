cmake_minimum_required(VERSION 3.15)
project(PackageB C)

# Determine platform tag and output directory
# Supported targets (set via toolchain file or detected automatically):
#   linux64  – 64-bit Linux  (native or cross: -DCMAKE_TOOLCHAIN_FILE=toolchains/linux64.cmake)
#   win64    – 64-bit Windows (cross: -DCMAKE_TOOLCHAIN_FILE=toolchains/win64.cmake)
#
# Usage:
#   Native Linux 64-bit build:
#     cmake -B build-linux64 -DCMAKE_TOOLCHAIN_FILE=toolchains/linux64.cmake
#     cmake --build build-linux64
#
#   Cross-compile to win64 (requires mingw-w64):
#     cmake -B build-win64 -DCMAKE_TOOLCHAIN_FILE=toolchains/win64.cmake
#     cmake --build build-win64

if(NOT DEFINED MODELICA_PLATFORM)
    if(CMAKE_SYSTEM_NAME STREQUAL "Windows")
        set(MODELICA_PLATFORM "win64")
    elseif(CMAKE_SYSTEM_NAME STREQUAL "Linux")
        set(MODELICA_PLATFORM "linux64")
    else()
        set(MODELICA_PLATFORM "unknown")
    endif()
endif()

message(STATUS "Modelica platform tag: ${MODELICA_PLATFORM}")

set(LIBRARY_OUTPUT_DIR "${CMAKE_CURRENT_SOURCE_DIR}/../Library/${MODELICA_PLATFORM}")

# ── ExternalLib1 (static) ───────────────────────────────────────────────────
# Compiled from the inline C source that Modelica includes via annotation Include.
# Note: same name as PackageA's ExternalLib1 — intentional to demonstrate
# the naming conflict that requires separate LibraryDirectory paths in Base Modelica.

add_library(ExternalLib1 STATIC ../Include/ExternalFunc1.c)

set_target_properties(ExternalLib1 PROPERTIES
    ARCHIVE_OUTPUT_DIRECTORY "${LIBRARY_OUTPUT_DIR}"
)
