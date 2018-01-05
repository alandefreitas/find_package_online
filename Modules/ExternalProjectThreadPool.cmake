include(ExternalProject)

#######################################################
### SET UP PACKAGE DATA                             ###
#######################################################

set(package_name ThreadPool)
set(repository "https://github.com/progschj/ThreadPool.git")
set(include_directories "${CMAKE_BINARY_DIR}/3rdparty/${package_name}")

#######################################################
### ADD IT AS AN EXTERNAL PROJECT                   ###
#######################################################

ExternalProject_Add(
        ${package_name}
        GIT_REPOSITORY ${repository}
        GIT_TAG "master"
        SOURCE_DIR "${CMAKE_BINARY_DIR}/3rdparty/${package_name}"
        PREFIX "${CMAKE_BINARY_DIR}/3rdparty/prefix/${package_name}"
        CONFIGURE_COMMAND ""
        BUILD_COMMAND ""
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
