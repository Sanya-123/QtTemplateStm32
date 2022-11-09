# Now call generated cmake
# This will add script generated
# information to the project
#include("cmake/cmake_generated.cmake")

# Link directories setup
# Must be before executable is added
link_directories(${CMAKE_PROJECT_NAME} ${LINK_DIRS})

# Create an executable object type
add_executable(${CMAKE_PROJECT_NAME})

# Add sources to executable
target_sources(${CMAKE_PROJECT_NAME} PUBLIC ${SOURCE})

# Add include paths
target_include_directories(${CMAKE_PROJECT_NAME} PRIVATE
    $<$<COMPILE_LANGUAGE:C>: ${INCLUDE}>
    $<$<COMPILE_LANGUAGE:CXX>: ${INCLUDE}>
    $<$<COMPILE_LANGUAGE:ASM>: ${INCLUDE}>
)

# Add project symbols (macros)
target_compile_definitions(${CMAKE_PROJECT_NAME} PRIVATE
    $<$<COMPILE_LANGUAGE:C>: ${DEFINES}>
    $<$<COMPILE_LANGUAGE:CXX>: ${DEFINES}>
    $<$<COMPILE_LANGUAGE:ASM>: ${DEFINES}>

    # Configuration specific
    $<$<CONFIG:Debug>:DEBUG>
    $<$<CONFIG:Release>: >
)

# Add linked libraries
target_link_libraries(${CMAKE_PROJECT_NAME} ${LINK_LIBS})

# Compiler options
target_compile_options(${CMAKE_PROJECT_NAME} PRIVATE
    ${CPU_PARAMETERS}
    ${COMPILER_OPTS}
#    -Wall
#    -Wextra
#    -Wpedantic
#    -Wno-unused-parameter
    "-fno-strict-aliasing"
    "-fdata-sections"
    "-ffunction-sections"
    "-fshort-enums"
#    "-flto"
    "-finput-charset=UTF-8"
    "-fexec-charset=cp1251"
    "-std=gnu11"
    "-Wall"
    "-Wpedantic"
    "-Wno-main"
    "-Wno-unused-function"
#    "-Wno-unused-parameter"
    "-Wno-old-style-declaration"
    "-specs=nano.specs"
    $<$<COMPILE_LANGUAGE:C>: >
    $<$<COMPILE_LANGUAGE:CXX>:

    # -Wno-volatile
    # -Wold-style-cast
    # -Wuseless-cast
    # -Wsuggest-override
    >
    $<$<COMPILE_LANGUAGE:ASM>:-x assembler-with-cpp -MMD -MP>
#    $<$<CONFIG:Debug>:-Og -g3 -ggdb>
#    $<$<CONFIG:Release>:-Og -g0>
)

# Linker options
target_link_options(${CMAKE_PROJECT_NAME} PRIVATE
    "-Wl,--start-group"
    -T${LINKER_SCRIPT}
#    ${CPU_PARAMETERS}
    ${LINKER_OPTS}
#    "-Wl,-Map=${CMAKE_PROJECT_NAME}.map"
#    "-u _printf_float" # STDIO float formatting support (remove if not used)
#    "--specs=nosys.specs"
    "-Wl,--print-memory-usage"
    "-Wl,--gc-sections"
    "-lnosys"
    "-nostdlib"
#    "-lc"
#    "-lm"
#    "-lstdc++"
#    "-lsupc++"
#    "-Wl,-z,max-page-size=8" # Allow good software remapping across address space (with proper GCC section making)
    "-Wl,--end-group"
)

# Execute post-build to print size
add_custom_command(TARGET ${CMAKE_PROJECT_NAME} POST_BUILD
    COMMAND ${CMAKE_SIZE} $<TARGET_FILE:${CMAKE_PROJECT_NAME}>
)

# Convert output to hex and binary
add_custom_command(TARGET ${CMAKE_PROJECT_NAME} POST_BUILD
    COMMAND ${CMAKE_OBJCOPY} -O ihex $<TARGET_FILE:${CMAKE_PROJECT_NAME}> ${CMAKE_PROJECT_NAME}.hex
)

# Convert to bin file -> add conditional check?
add_custom_command(TARGET ${CMAKE_PROJECT_NAME} POST_BUILD
    COMMAND ${CMAKE_OBJCOPY} -O binary $<TARGET_FILE:${CMAKE_PROJECT_NAME}> ${CMAKE_PROJECT_NAME}.bin
)

# get disasemmbler lst
add_custom_command(TARGET ${CMAKE_PROJECT_NAME} POST_BUILD
    COMMAND ${CMAKE_OBJCOPY} -D -S $<TARGET_FILE:${CMAKE_PROJECT_NAME}> ${CMAKE_PROJECT_NAME}.list
)

