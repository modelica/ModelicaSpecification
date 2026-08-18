cmake_minimum_required(VERSION 3.15)
project(Multiplication C)

# Supported targets (set via toolchain file or detected automatically):
#   linux64  – 64-bit Linux  (native: -DCMAKE_TOOLCHAIN_FILE=toolchains/linux64.cmake)
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

# ── Multiplication (static) ──────────────────────────────────────────────────

add_library(Multiplication STATIC Multiplier.c)
target_include_directories(Multiplication PRIVATE ../Include)

set_target_properties(Multiplication PROPERTIES
    ARCHIVE_OUTPUT_DIRECTORY "${LIBRARY_OUTPUT_DIR}"
)
