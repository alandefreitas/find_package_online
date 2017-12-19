include(ExternalProject)

#######################################################
### SET UP PACKAGE DATA                             ###
#######################################################

set(package_name Cling)
set(library_files
    "${PROJECT_BINARY_DIR}/3rdparty/${package_name}/lib/libcling.dylib"
    "${PROJECT_BINARY_DIR}/3rdparty/${package_name}/lib/libclingInterpreter.a"
    "${PROJECT_BINARY_DIR}/3rdparty/${package_name}/lib/libclingMetaProcessor.a"
    "${PROJECT_BINARY_DIR}/3rdparty/${package_name}/lib/libclingUtils.a"
    )

set(include_directories "${CMAKE_BINARY_DIR}/3rdparty/${package_name}/include")

#######################################################
### ADD IT AS AN EXTERNAL PROJECT                   ###
#######################################################

cmake_policy(SET CMP0068 OLD)

ExternalProject_Add(
        Cling-LLVM
        GIT_REPOSITORY "http://root.cern.ch/git/llvm.git"
        GIT_TAG "cling-patches"
        SOURCE_DIR "${CMAKE_BINARY_DIR}/3rdparty/${package_name}"
        PREFIX "${CMAKE_BINARY_DIR}/3rdparty/prefix/${package_name}"
        GIT_PROGRESS ON
        BUILD_COMMAND ""
        UPDATE_COMMAND ""
        CONFIGURE_COMMAND ""
        INSTALL_COMMAND ""
)

ExternalProject_Add(
        Cling-Clang
        GIT_REPOSITORY "http://root.cern.ch/git/clang.git"
        GIT_TAG "cling-patches"
        SOURCE_DIR "${CMAKE_BINARY_DIR}/3rdparty/${package_name}/tools/clang"
        PREFIX "${CMAKE_BINARY_DIR}/3rdparty/prefix/${package_name}/tools/clang"
        BUILD_COMMAND ""
        UPDATE_COMMAND ""
        CONFIGURE_COMMAND ""
        INSTALL_COMMAND ""
        GIT_PROGRESS ON
)
add_dependencies(Cling-Clang Cling-LLVM)

ExternalProject_Add(
        Cling
        GIT_REPOSITORY http://root.cern.ch/git/cling.git
        GIT_TAG "master"
        SOURCE_DIR "${CMAKE_BINARY_DIR}/3rdparty/${package_name}/tools/cling"
        PREFIX "${CMAKE_BINARY_DIR}/3rdparty/prefix/${package_name}/tools/cling"
        UPDATE_COMMAND ""
        CONFIGURE_COMMAND "" #
        BUILD_COMMAND ""     #
        INSTALL_COMMAND ""   #
        SOURCE_SUBDIR "../.."
        CMAKE_ARGS "-DCMAKE_INSTALL_PREFIX=${PROJECT_BINARY_DIR}/3rdparty/${package_name}"
        GIT_PROGRESS ON
)

add_dependencies(Cling Cling-Clang)


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
