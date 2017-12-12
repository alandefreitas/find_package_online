# - Find POSTGRES
# POSTGRES_INCLUDE_DIRS	- where to find headers.
# POSTGRES_LIBRARIES	- List of libraries.
# POSTGRES_FOUND	- True if found.

# Usual messages
set(POSTGRES_INCLUDE_PATH_DESCRIPTION "top-level directory containing the POSTGRES include directories. E.g /usr/local/include/postgres or C:/Program Files/postgres/include")
set(POSTGRES_INCLUDE_DIR_MESSAGE      "Set the POSTGRES_INCLUDE_DIR cmake cache entry to the ${POSTGRES_INCLUDE_PATH_DESCRIPTION}")
set(POSTGRES_LIBRARY_PATH_DESCRIPTION "top-level directory containing the POSTGRES libraries.")
set(POSTGRES_LIBRARY_DIR_MESSAGE      "Set the POSTGRES_LIBRARY_DIR cmake cache entry to the ${POSTGRES_LIBRARY_PATH_DESCRIPTION}")
set(POSTGRES_ROOT_DIR_MESSAGE         "Set the POSTGRES_ROOT system variable to where POSTGRES is found on the machine E.g C:/Program Files/postgres")

#######################################################
###                 SEARCH PATHS                    ###
#######################################################
set(POSTGRES_POSSIBLE_ROOT_DIRECTORIES
    ${POSTGRES_POSSIBLE_ROOT_DIRECTORIES}
    ${POSTGRES_ROOT}
    ${POSTGRES_ADDITIONAL_SEARCH_PATHS}
    $ENV{POSTGRES_ROOT}
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
find_path(POSTGRES_INCLUDE_DIR
          NAMES libpq-fe.h # possible names for the file in a directory
          PATHS  ${POSTGRES_POSSIBLE_ROOT_DIRECTORIES}
          "$ENV{LIB_DIR}/include" # Directories to search in addition to the default locations
          PATH_SUFFIXES include # additional subdirectories to check below each directory location
          DOC "The ${POSTGRES_LIBRARY_DIR_MESSAGE}" # the documentation string
          )

#######################################################
###               LOOK FOR LIBRARY                  ###
#######################################################
find_library( POSTGRES_LIBRARY
              NAMES pq libpq libpqdll # possible names for the file in a directory
              PATHS ${POSTGRES_POSSIBLE_ROOT_DIRECTORIES} # Directories to search in addition to the default locations
              PATH_SUFFIXES lib # additional subdirectories to check below each directory location
              )

#######################################################
###                 SETUP VARIABLES                 ###
#######################################################
include(FindPackageHandleStandardArgs)
find_package_handle_standard_args(POSTGRES DEFAULT_MSG POSTGRES_LIBRARY POSTGRES_INCLUDE_DIR)
mark_as_advanced(POSTGRES_INCLUDE_DIR POSTGRES_LIBRARY )
set(POSTGRES_LIBRARIES ${POSTGRES_LIBRARY} )
set(POSTGRES_INCLUDE_DIRS ${POSTGRES_INCLUDE_DIR} )
