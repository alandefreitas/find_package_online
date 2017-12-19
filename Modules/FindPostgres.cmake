# - Find ${package_name}
# ${package_name}_INCLUDE_DIRS	- where to find headers.
# ${package_name}_LIBRARIES	- List of libraries.
# ${package_name}_FOUND	- True if found.

set(package_name POSTGRES)
set(header_names libpq-fe.h)
set(library_names pq libpq libpqdll)

# Usual messages
set(${package_name}_INCLUDE_PATH_DESCRIPTION "top-level directory containing the ${package_name} include directories. E.g /usr/local/include/${package_name} or C:/Program Files/${package_name}/include")
set(${package_name}_INCLUDE_DIR_MESSAGE      "Set the ${package_name}_INCLUDE_DIR cmake cache entry to the ${${package_name}_INCLUDE_PATH_DESCRIPTION}")
set(${package_name}_LIBRARY_PATH_DESCRIPTION "top-level directory containing the ${package_name} libraries.")
set(${package_name}_LIBRARY_DIR_MESSAGE      "Set the ${package_name}_LIBRARY_DIR cmake cache entry to the ${${package_name}_LIBRARY_PATH_DESCRIPTION}")
set(${package_name}_ROOT_DIR_MESSAGE         "Set the ${package_name}_ROOT system variable to where ${package_name} is found on the machine E.g C:/Program Files/${package_name}")

#######################################################
###                 SEARCH PATHS                    ###
#######################################################
set(HEADER_SEARCH_PATHS
    # Set up by the user
    ${SEARCH_PATHS}
    ${${package_name}_ROOT}
    ${${package_name}_ADDITIONAL_SEARCH_PATHS}
    $ENV{${package_name}_ROOT}
    "$ENV{LIB_DIR}/include/${package_name}"
    # usual folder if it was installed by external project
    "${CMAKE_BINARY_DIR}/3rdparty/${package_name}/include"
    # usual unix folders
    /usr/include
    /usr/local/include
    # usual windows folders
    c:/msys/local/include
    )

if (library_names)
    set(LIBRARY_SEARCH_PATHS
        # Set up by the user
        ${SEARCH_PATHS}
        ${${package_name}_ROOT}
        ${${package_name}_ADDITIONAL_SEARCH_PATHS}
        $ENV{${package_name}_ROOT}
        "$ENV{LIB_DIR}/lib"
        "$ENV{LIB_DIR}/include/${package_name}"
        # usual folder if it was installed by external project
        ${CMAKE_BINARY_DIR}/3rdparty/${package_name}/lib
        # usual unix folders
        /usr/lib
        /usr/local/lib
        # usual windows folders
        c:/msys/local/include
        )
endif()

#######################################################
###               LOOK FOR HEADER FILE              ###
#######################################################

find_path(${package_name}_INCLUDE_DIR
          NAMES ${header_names} # possible names for the file in a directory
          PATHS  ${HEADER_SEARCH_PATHS} # Directories to search in addition to the default locations
          PATH_SUFFIXES include # additional subdirectories to check below each directory location
          DOC "The ${${package_name}_LIBRARY_DIR_MESSAGE}" # the documentation string
          )

message("${package_name}_INCLUDE_DIR = ${${package_name}_INCLUDE_DIR}")

#######################################################
###               LOOK FOR LIBRARY                  ###
#######################################################
if (library_names)
    find_library( ${package_name}_LIBRARY
                  NAMES ${library_names} # possible names for the file in a directory
                  PATHS ${LIBRARY_SEARCH_PATHS} # Directories to search in addition to the default locations
                  PATH_SUFFIXES lib # additional subdirectories to check below each directory location
                  )
else()
    set(${package_name}_LIBRARY "")
endif()

#######################################################
###                 SETUP VARIABLES                 ###
#######################################################
include(FindPackageHandleStandardArgs)
find_package_handle_standard_args(${package_name} DEFAULT_MSG ${package_name}_INCLUDE_DIR)
mark_as_advanced(${package_name}_INCLUDE_DIR)
set(${package_name}_LIBRARIES ${${package_name}_LIBRARY} )
set(${package_name}_INCLUDE_DIRS ${${package_name}_INCLUDE_DIR} )
