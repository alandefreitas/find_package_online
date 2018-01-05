include(ExternalProject)

#######################################################
### SET UP PACKAGE DATA                             ###
#######################################################

set(package_name Gtest)
set(library_files "${PROJECT_BINARY_DIR}/3rdparty/${package_name}/lib/gtest.a")
set(include_directories "${CMAKE_BINARY_DIR}/3rdparty/${package_name}/include")

#######################################################
### ADD IT AS AN EXTERNAL PROJECT                   ###
#######################################################

ExternalProject_Add(
        Gtest
        URL http://googletest.googlecode.com/files/gtest-1.6.0.zip
        INSTALL_COMMAND ""
        LOG_DOWNLOAD ON
        LOG_CONFIGURE ON
        LOG_BUILD ON
        PREFIX "${CMAKE_BINARY_DIR}/3rdparty/prefix/${package_name}"
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
