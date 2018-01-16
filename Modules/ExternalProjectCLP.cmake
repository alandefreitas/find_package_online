include(ExternalProject)

#######################################################
### SET UP PACKAGE DATA                             ###
#######################################################

set(package_name CLP)
set(library_files
    "${CMAKE_BINARY_DIR}/3rdparty/${package_name}/build/lib/libClp.a"
    "${CMAKE_BINARY_DIR}/3rdparty/${package_name}/build/lib/libCoinUtils.a"
    )

set(include_directories "${CMAKE_BINARY_DIR}/3rdparty/${package_name}/build/include/coin")

#######################################################
### ADD IT AS AN EXTERNAL PROJECT                   ###
#######################################################

ExternalProject_Add(
        ${package_name}
        GIT_REPOSITORY https://github.com/alandefreitas/Clp-1.16.11.git
        GIT_TAG "master"
        SOURCE_DIR "${CMAKE_BINARY_DIR}/3rdparty/${package_name}"
        PREFIX "${CMAKE_BINARY_DIR}/3rdparty/prefix/${package_name}"
        UPDATE_COMMAND ""
        CMAKE_ARGS
            -DCMAKE_BUILD_TYPE=${CMAKE_BUILD_TYPE}
            -DCMAKE_INSTALL_PREFIX=${CMAKE_BINARY_DIR}/3rdparty/${package_name}/build
            -DCMAKE_C_COMPILER=${CMAKE_C_COMPILER}
            -DCMAKE_CXX_COMPILER=${CMAKE_CXX_COMPILER}
        GIT_PROGRESS ON
)

#######################################################
### CREATE AN INTERFACE LIBRARY                     ###
#######################################################

# Create an interface library
add_library(${package_name}-interface INTERFACE)
add_dependencies(${package_name}-interface ${package_name})

# List of libraries, including the interface library we just created
set(${package_name}_LIBRARIES ${package_name}-interface ${library_files})

# Include directories
set(${package_name}_INCLUDE_DIRS ${include_directories})

set(${package_name}_FOUND TRUE)
