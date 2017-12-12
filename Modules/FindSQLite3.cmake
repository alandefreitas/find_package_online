# - Find sqlite3
# SQLITE3_INCLUDE_DIRS	- where to find headers.
# SQLITE3_LIBRARIES	- List of libraries.
# SQLITE3_FOUND	- True if found.

# Usual messages
set(SQLITE3_INCLUDE_PATH_DESCRIPTION "top-level directory containing the SQLITE3 include directories. E.g /usr/local/include/sqlite3 or C:/Program Files/sqlite3/include")
set(SQLITE3_INCLUDE_DIR_MESSAGE      "Set the SQLITE3_INCLUDE_DIR cmake cache entry to the ${SQLITE3_INCLUDE_PATH_DESCRIPTION}")
set(SQLITE3_LIBRARY_PATH_DESCRIPTION "top-level directory containing the SQLITE3 libraries.")
set(SQLITE3_LIBRARY_DIR_MESSAGE      "Set the SQLITE3_LIBRARY_DIR cmake cache entry to the ${SQLITE3_LIBRARY_PATH_DESCRIPTION}")
set(SQLITE3_ROOT_DIR_MESSAGE         "Set the SQLITE3_ROOT system variable to where SQLITE3 is found on the machine E.g C:/Program Files/sqlite3")

#######################################################
###                 SEARCH PATHS                    ###
#######################################################
set(SEARCH_PATHS
    ${SEARCH_PATHS}
    ${SQLITE3_ROOT}
    ${SQLITE3_ADDITIONAL_SEARCH_PATHS}
    $ENV{SQLITE3_ROOT}
    /usr/lib
    /usr/include
    /usr/local/lib
    /usr/local/include
    c:/msys/local/lib
    c:/msys/local/include
    "$ENV{LIB_DIR}/lib"
    "$ENV{LIB_DIR}/include/postgresql"
    )

#######################################################
###               LOOK FOR HEADER FILE              ###
#######################################################
find_path(SQLITE3_INCLUDE_DIR
          NAMES sqlite3.h # possible names for the file in a directory
          PATHS  ${SEARCH_PATHS} # Directories to search in addition to the default locations
          PATH_SUFFIXES  sqlite sqlite3 include # additional subdirectories to check below each directory location
          DOC "The ${SQLITE3_LIBRARY_DIR_MESSAGE}" # the documentation string
          )

#######################################################
###               LOOK FOR LIBRARY                  ###
#######################################################
find_library( SQLITE3_LIBRARY
              NAMES sqlite sqlite3.0 libsqlite libsqlite3.0 # possible names for the file in a directory
              PATHS ${SEARCH_PATHS} # Directories to search in addition to the default locations
              PATH_SUFFIXES lib # additional subdirectories to check below each directory location
              )

#######################################################
###                 SETUP VARIABLES                 ###
#######################################################
include(FindPackageHandleStandardArgs)
find_package_handle_standard_args(SQLITE3 DEFAULT_MSG SQLITE3_LIBRARY SQLITE3_INCLUDE_DIR)
mark_as_advanced(SQLITE3_INCLUDE_DIR SQLITE3_LIBRARY )
set(SQLITE3_LIBRARIES ${SQLITE3_LIBRARY} )
set(SQLITE3_INCLUDE_DIRS ${SQLITE3_INCLUDE_DIR} )
