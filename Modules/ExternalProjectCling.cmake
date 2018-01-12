include(ExternalProject)

#######################################################
### SET UP PACKAGE DATA                             ###
#######################################################

set(package_name Cling)

set(library_files
    "${PROJECT_BINARY_DIR}/3rdparty/${package_name}/build/lib/libcling${CMAKE_SHARED_LIBRARY_SUFFIX}"
    "${PROJECT_BINARY_DIR}/3rdparty/${package_name}/build/lib/libclingInterpreter.a"
    "${PROJECT_BINARY_DIR}/3rdparty/${package_name}/build/lib/libclingMetaProcessor.a"
    "${PROJECT_BINARY_DIR}/3rdparty/${package_name}/build/lib/libclingUtils.a"
    )

set(include_directories "${CMAKE_BINARY_DIR}/3rdparty/${package_name}/build/include")

#######################################################
### TRY TO IDENTIFY OPERATING SYSTEM FOR THE BINARY ###
#######################################################

find_program(LSB_RELEASE lsb_release)
execute_process(COMMAND ${LSB_RELEASE} -is
        OUTPUT_VARIABLE LSB_RELEASE_ID_SHORT
        OUTPUT_STRIP_TRAILING_WHITESPACE
        )

execute_process(COMMAND ${LSB_RELEASE} -cs
        OUTPUT_VARIABLE LSB_RELEASE_CODENAME
        OUTPUT_STRIP_TRAILING_WHITESPACE
        )

#message("-- CMAKE_SYSTEM_INFO_FILE: ${CMAKE_SYSTEM_INFO_FILE}")
#message("-- CMAKE_SYSTEM_NAME:      ${CMAKE_SYSTEM_NAME}")
#message("-- CMAKE_SYSTEM_PROCESSOR: ${CMAKE_SYSTEM_PROCESSOR}")
#message("-- CMAKE_SYSTEM:           ${CMAKE_SYSTEM}")
#message("-- CMAKE_SYSTEM_VERSION:   ${CMAKE_SYSTEM_VERSION}")
#message("-- CMAKE_HOST_SYSTEM_NAME: ${CMAKE_HOST_SYSTEM_NAME}")
#message("-- LSB_RELEASE_ID_SHORT:   ${LSB_RELEASE_ID_SHORT}")
#message("-- LSB_RELEASE_CODENAME:   ${LSB_RELEASE_CODENAME}")

if (LSB_RELEASE_ID_SHORT STREQUAL "Ubuntu")
    if (LSB_RELEASE_CODENAME STREQUAL "xenial")
        set(cling_binary_download_url "https://root.cern.ch/download/cling//cling_2018-01-11_ubuntu16.tar.bz2")
    elseif(LSB_RELEASE_CODENAME STREQUAL "trusty")
        set(cling_binary_download_url "https://root.cern.ch/download/cling//cling_2018-01-11_ubuntu14.tar.bz2")
    elseif(LSB_RELEASE_CODENAME STREQUAL "artful")
        set(cling_binary_download_url "https://root.cern.ch/download/cling//cling_2018-01-11_ubuntu17.10.tar.bz2")
    elseif(LSB_RELEASE_CODENAME STREQUAL "Zesty")
        set(cling_binary_download_url "https://root.cern.ch/download/cling//cling_2018-01-11_ubuntu17.10.tar.bz2")
    endif()
endif()

if (DEFINED cling_binary_download_url)
    message("-- cling_binary_download_url:   ${cling_binary_download_url}")
endif()

#######################################################
### ADD IT AS AN EXTERNAL PROJECT                   ###
#######################################################

# Download the source and compile
cmake_policy(SET CMP0068 OLD)

# Download Cling LLVM source
ExternalProject_Add(
        Cling-LLVM
        GIT_REPOSITORY "http://root.cern.ch/git/llvm.git"
        GIT_TAG "cling-patches"
        SOURCE_DIR "${CMAKE_BINARY_DIR}/3rdparty/${package_name}"
        PREFIX "${CMAKE_BINARY_DIR}/3rdparty/prefix/${package_name}/cling_llvm"
        GIT_PROGRESS ON
        BUILD_COMMAND ""
        UPDATE_COMMAND ""
        CONFIGURE_COMMAND ""
        INSTALL_COMMAND ""
)

# Download Cling/Clang/LLVM source
ExternalProject_Add(
        Cling-Clang
        GIT_REPOSITORY "http://root.cern.ch/git/clang.git"
        GIT_TAG "cling-patches"
        SOURCE_DIR "${CMAKE_BINARY_DIR}/3rdparty/${package_name}/tools/clang"
        PREFIX "${CMAKE_BINARY_DIR}/3rdparty/prefix/${package_name}/cling_clang"
        BUILD_COMMAND ""
        UPDATE_COMMAND ""
        CONFIGURE_COMMAND ""
        INSTALL_COMMAND ""
        GIT_PROGRESS ON
)
add_dependencies(Cling-Clang Cling-LLVM)


if (DEFINED cling_binary_download_url)
    # Download Cling sources but don't install
    ExternalProject_Add(
            Cling-Sources
            GIT_REPOSITORY http://root.cern.ch/git/cling.git
            GIT_TAG "master"
            SOURCE_DIR "${CMAKE_BINARY_DIR}/3rdparty/${package_name}/tools/cling"
            PREFIX "${CMAKE_BINARY_DIR}/3rdparty/prefix/${package_name}/cling_sources"
            BUILD_COMMAND ""
            UPDATE_COMMAND ""
            CONFIGURE_COMMAND ""
            INSTALL_COMMAND ""
            GIT_PROGRESS ON
    )
    add_dependencies(Cling-Sources Cling-Clang)

    # Download the binaries from their website and put them in the build folder
    ExternalProject_Add(Cling
            URL               ${cling_binary_download_url}
            PREFIX            "${CMAKE_BINARY_DIR}/3rdparty/prefix/${package_name}/cling_binaries"
            BUILD_COMMAND ""
            UPDATE_COMMAND ""
            CONFIGURE_COMMAND ""
            INSTALL_COMMAND ""
            SOURCE_DIR        ${PROJECT_BINARY_DIR}/3rdparty/${package_name}/build
            )
    add_dependencies(Cling Cling-Sources)
else()
    # Download Cling sources and install from source
    ExternalProject_Add(
            Cling
            GIT_REPOSITORY http://root.cern.ch/git/cling.git
            GIT_TAG "master"
            SOURCE_DIR "${CMAKE_BINARY_DIR}/3rdparty/${package_name}/tools/cling"
            PREFIX "${CMAKE_BINARY_DIR}/3rdparty/prefix/${package_name}/cling"
            UPDATE_COMMAND ""
            SOURCE_SUBDIR "../.."
            CMAKE_ARGS "-DCMAKE_INSTALL_PREFIX=${PROJECT_BINARY_DIR}/3rdparty/${package_name}/build -DCMAKE_BUILD_TYPE=${CMAKE_BUILD_TYPE}"
            GIT_PROGRESS ON
    )
    add_dependencies(Cling Cling-Clang)
endif()

#######################################################
### CREATE AN INTERFACE LIBRARY                     ###
#######################################################

# Create an interface library
add_library(${package_name}-interface INTERFACE)
add_dependencies(${package_name}-interface Cling)

# List of libraries, including the interface library we just created
set(${package_name}_LIBRARIES ${package_name}-interface ${library_files})

# Include directories
set(${package_name}_INCLUDE_DIRS ${include_directories})

set(${package_name}_FOUND TRUE)
