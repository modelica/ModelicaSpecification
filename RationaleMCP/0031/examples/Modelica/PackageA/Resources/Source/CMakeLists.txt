cmake_minimum_required(VERSION 3.15)
project(PackageA C)

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

# ── ExternalLib1 (static) ────────────────────────────────────────────────────

add_library(ExternalLib1 STATIC Func1.c)
target_include_directories(ExternalLib1 PRIVATE ../Include)

set_target_properties(ExternalLib1 PROPERTIES
    ARCHIVE_OUTPUT_DIRECTORY "${LIBRARY_OUTPUT_DIR}"
)

# ── ExternalLib2 (shared / dynamic) ─────────────────────────────────────────

add_library(ExternalLib2 SHARED Func2.c HelperFunc.c)
target_include_directories(ExternalLib2 PRIVATE ../Include)
target_compile_definitions(ExternalLib2 PRIVATE EXTERNAL_FUNCTION_EXPORT)

# Emit position-independent code for shared libraries on Linux
if(CMAKE_SYSTEM_NAME STREQUAL "Linux")
    target_compile_options(ExternalLib2 PRIVATE -fPIC)
endif()

set_target_properties(ExternalLib2 PROPERTIES
    LIBRARY_OUTPUT_DIRECTORY  "${LIBRARY_OUTPUT_DIR}"  # .so
    RUNTIME_OUTPUT_DIRECTORY  "${LIBRARY_OUTPUT_DIR}"  # .dll
    ARCHIVE_OUTPUT_DIRECTORY  "${LIBRARY_OUTPUT_DIR}"  # import .lib (MSVC/MinGW)
)

# On Windows via MinGW, also generate the import library alongside the DLL
if(MINGW)
    target_link_options(ExternalLib2 PRIVATE
        "-Wl,--out-implib,${LIBRARY_OUTPUT_DIR}/ExternalLib2.lib"
    )
endif()
