include(ExternalProject)

#######################################################
### SET UP PACKAGE DATA                             ###
#######################################################

set(package_name Boost)
# TODO: List Boost library files here according to the COMPONENTS option
#set(library_files "${PROJECT_BINARY_DIR}/3rdparty/${package_name}/lib/libbenchmark.a")
set(include_directories "${CMAKE_BINARY_DIR}/3rdparty/${package_name}/include")

if( ${WIN32} )
    set( Boost_url https://dl.bintray.com/boostorg/release/1.65.1/source/boost_1_65_1.zip )
    set( Boost_SHA256_Hash 9807a5d16566c57fd74fb522764e0b134a8bbe6b6e8967b83afefd30dcd3be81 )
    set( Boost_Bootstrap_Command bootstrap.bat )
    set( Boost_b2_Command b2.exe )
else()
    set( Boost_url https://dl.bintray.com/boostorg/release/1.65.1/source/boost_1_65_1.tar.bz2 )
    set( Boost_SHA256_Hash d1775aef807bd6a14077b450cce2950d8eacd86aaf51015f79e712917f8cc3c2 )
    set( Boost_Bootstrap_Command ./bootstrap.sh )
    set( Boost_b2_Command ./b2 )
endif()

#######################################################
### ADD IT AS AN EXTERNAL PROJECT                   ###
#######################################################

ExternalProject_Add(boost
                    # Directory Options
                    PREFIX ${CMAKE_BINARY_DIR}/third_party/Boost
                    INSTALL_DIR ${CMAKE_BINARY_DIR}/third_party/Boost/INSTALL
                    # Download Step Options
                    URL ${Boost_url}
                    URL_HASH SHA256=${Boost_SHA256_Hash}
                    # Update/Patch Step Options:
                    UPDATE_COMMAND ""
                    PATCH_COMMAND ""
                    # Configure Step Options
                    CONFIGURE_COMMAND ${Boost_Bootstrap_Command}
                    # Build Step Options
                    BUILD_IN_SOURCE 1
                    BUILD_COMMAND  ${Boost_b2_Command} install
                    --without-python
                    --disable-icu
                    --prefix=${CMAKE_BINARY_DIR}/third_party/Boost/INSTALL
                    --threading=single,multi
                    --link=shared
                    --variant=release
                    -j8
                    # Install Step Options
                    INSTALL_COMMAND ""
                    )

if( NOT WIN32 )
    set(Boost_LIBRARY_DIR ${CMAKE_BINARY_DIR}/third_party/Boost/INSTALL/lib/boost/ )
    set(Boost_INCLUDE_DIR ${CMAKE_BINARY_DIR}/third_party/Boost/INSTALL/include/ )
else()
    set(Boost_LIBRARY_DIR ${CMAKE_BINARY_DIR}/third_party/Boost/INSTALL/lib/ )
    set(Boost_INCLUDE_DIR ${CMAKE_BINARY_DIR}/third_party/Boost/INSTALL/include/boost-1_49/ )
endif()

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
