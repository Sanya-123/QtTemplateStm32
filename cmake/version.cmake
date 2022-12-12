cmake_minimum_required(VERSION 3.5)

if(NOT VERSION)
    set(VERSION "0.0")
endif()

execute_process(ERROR_QUIET
    COMMAND git rev-parse HEAD # can use with --short
    WORKING_DIRECTORY ${CMAKE_CURRENT_SOURCE_DIR}
    OUTPUT_VARIABLE GIT_COMMIT
    OUTPUT_STRIP_TRAILING_WHITESPACE
)

execute_process(ERROR_QUIET
    COMMAND git status --porcelain
    WORKING_DIRECTORY ${CMAKE_CURRENT_SOURCE_DIR}
    OUTPUT_VARIABLE GIT_DIRTY
    OUTPUT_STRIP_TRAILING_WHITESPACE
)

if("${GIT_DIRTY}" STREQUAL "")
else()
    string(APPEND GIT_COMMIT ".mod")
endif()

# macros for get avalues from string
MACRO( TIME_STR_TO_INTS hour minute time )

    STRING( REGEX REPLACE "([0-9]+):[0-9]+" "\\\\1" ${hour} ${time} )
    STRING( REGEX REPLACE "[0-9]+:([0-9]+)" "\\\\1" ${minute} ${time} )

ENDMACRO( TIME_STR_TO_INTS )

MACRO( DATE_STR_TO_INTS day month year date )

    STRING( REGEX REPLACE "([0-9]+).[0-9]+.[0-9]+" "\\\\1" ${day} ${date} )
    STRING( REGEX REPLACE "[0-9]+.([0-9]+).[0-9]+" "\\\\1" ${month} ${date} )
    STRING( REGEX REPLACE "[0-9]+.[0-9]+.([0-9]+)" "\\\\1" ${year} ${date} )

ENDMACRO( DATE_STR_TO_INTS )

MACRO( VERSION_STR_TO_INTS major minor version )

    STRING( REGEX REPLACE "([0-9]+).[0-9]+" "\\\\1" ${major} ${version} )
    STRING( REGEX REPLACE "[0-9]+.([0-9]+)" "\\\\1" ${minor} ${version} )

ENDMACRO( VERSION_STR_TO_INTS )
#

# get date and time
string(TIMESTAMP BUILD_DATE "%d.%m.%Y")
string(TIMESTAMP BUILD_TIME "%H:%M")

#convert fata to string
TIME_STR_TO_INTS( hour minute ${BUILD_TIME})
DATE_STR_TO_INTS( day month year ${BUILD_DATE})
VERSION_STR_TO_INTS (VERSION_MAJOR VERSION_MINOR ${VERSION})

#calc project name use md5
string(MD5 NAME_MD5 ${PROJECTNAME})
string(TOUPPER ${NAME_MD5} NAME_MD5)
string(SUBSTRING ${NAME_MD5} 0 16 NAME_MD5_HI)
string(SUBSTRING ${NAME_MD5} 16 16 NAME_MD5_LO)

#counter build
set(BUILD_COUNTER_PATH ".counter.user.build")

#git head path
set(GIT_COMIT_FILE "git_comit.txt")
#git head path
if(NOT PATH_LD)
    set(GIT_COMIT_PATH ${GIT_COMIT_FILE})
else()
    set(GIT_COMIT_PATH ${PATH_LD}/${GIT_COMIT_FILE})
endif()

if(NOT EXISTS "${BUILD_COUNTER_PATH}")
        file(WRITE "${BUILD_COUNTER_PATH}" "1")
        file(APPEND "${BUILD_COUNTER_PATH}" "\\n${VERSION}")
endif()

file(STRINGS "${BUILD_COUNTER_PATH}" READ_DATA)
list(GET READ_DATA 0 SOF_BUILD)

# check len list
list(LENGTH READ_DATA LEN)
if(${LEN} EQUAL 1)
    list(APPEND READ_DATA ${VERSION})
endif()
list(GET READ_DATA 1 OLD_VERSION)


if(NOT SOF_BUILD MATCHES "^[0-9]+$")
        message(WARNING "Invalid SOF_BUILD - setting to 1")
        set(SOF_BUILD 1)
endif()

# check old version if update so clean counter
if(NOT ${OLD_VERSION} EQUAL ${VERSION})
    message("UPDATE version")
    set(SOF_BUILD 1)
endif()

MATH(EXPR NEXT_SOF_BUILD "(${SOF_BUILD} + 1) % 65536")
file(WRITE "${BUILD_COUNTER_PATH}" ${NEXT_SOF_BUILD})
file(APPEND "${BUILD_COUNTER_PATH}" "\\n${VERSION}")
#


#calc and set data
MATH(EXPR DATE "(${day} << 24) | (${month} << 16) | ${year}")

MATH(EXPR TIME "(${hour} << 8) | (${minute} << 0) ")

set(SUBVERSION ${SOF_BUILD})

# if no git
if(NOT GIT_COMMIT)
    set(GIT_COMMIT_LEN 0)
#    set(GIT_COMMIT " ")
    set(GIT_COMMIT " ")
else()
    string(LENGTH ${GIT_COMMIT} GIT_COMMIT_LEN)
endif()

if(NOT PATH_LD)
    configure_file(in.version.ld version.ld @ONLY)
else()
    configure_file(in.version.ld ${PATH_LD}/version.ld @ONLY)
endif()

file(WRITE "${GIT_COMIT_PATH}" ${GIT_COMMIT})

#string(HEX ${DATE} HEX_DATE)
#string(HEX ${TIME} HEX_TIME)
message("Build on:${day}.${month}.${year} ${hour}:${minute}")
message("DATE: ${DATE}")
message("TIME: ${TIME}")
message("VERSION: ${VERSION_MAJOR}.${VERSION_MINOR}.${SUBVERSION}")
message("GIT_COMMIT: ${GIT_COMMIT}")
message("GIT_COMMIT_LEN: ${GIT_COMMIT_LEN}")
message("PROJECT_NAME: 0x${NAME_MD5_HI} 0x${NAME_MD5_LO}")
#message("GIT_DIRTY: ${GIT_DIRTY}")

