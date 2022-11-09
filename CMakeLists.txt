cmake_minimum_required(VERSION 3.16)
#base on https://github.com/MaJerle/stm32-cube-cmake-vscode

#
# This file is generated only once,
# and is not re-generated if converter is called multiple times.
#
# User is free to modify the file as much as necessary
#

# Core project settings
# NOTE in Qt creator I need add set(CMAKE_TRY_COMPILE_TARGET_TYPE STATIC_LIBRARY) before project
# or in build env or in kit cmake options; so I add to kit env this strings:
# CMAKE_EXECUTABLE_SUFFIX_ASM:STRING=.elf
# CMAKE_EXECUTABLE_SUFFIX_C:STRING=.elf
# CMAKE_EXECUTABLE_SUFFIX_CXX:STRING=.elf
# CMAKE_SIZE:INTERNAL=arm-none-eabi-size
# CMAKE_SYSTEM_NAME:INTERNAL=Generic
# CMAKE_SYSTEM_PROCESSOR:INTERNAL=arm
# CMAKE_TRY_COMPILE_TARGET_TYPE:INTERNAL=STATIC_LIBRARY
# TOOLCHAIN_PREFIX:INTERNAL=arm-none-eabi-

project(%{ProjectName})
enable_language(C CXX ASM)
message("Build type: " ${CMAKE_BUILD_TYPE})
include("cmake/stm32_family.cmake")
# may use for select toolchain include("cmake/gcc-arm-none-eabi.cmake") or select when run cmake

# Setup compiler settings
set(CMAKE_C_STANDARD 11)
set(CMAKE_C_STANDARD_REQUIRED ON)
set(CMAKE_C_EXTENSIONS ON)
set(CMAKE_CXX_STANDARD 20)
set(CMAKE_CXX_STANDARD_REQUIRED ON)
set(CMAKE_CXX_EXTENSIONS ON)

# Core MCU flags, CPU type, instruction set and FPU setup
set(CPU_PARAMETERS
     "-mthumb"
     ${%{SerialController}_CPU_PAR}
)

# Sources
file(GLOB_RECURSE _SOURCE "")
set(SOURCE  ${_SOURCE})

# Include directories for each compiler
set(INCLUDE)

# Symbols definition for each compiler
set(DEFINES)

# Link directories and names of libraries
set(LINK_DIRS)
set(LINK_LIBS)

# Linker script
set(LINKER_SCRIPT "%{TypeDef}_FLASH.ld")

# Compiler options
set(COMPILER_OPTS "-Os" "-g0")

# Linker options
set(LINKER_OPTS)

# script for build
include("cmake/stm32_generate.cmake")
