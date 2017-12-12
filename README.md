# The Easiest CMake Package Manager Ever

This is the simplest CMake package manager ever, so you don't ever have  problems again when sharing your projects with your team members. 

You can integrate the package manager by inserting the following code anywhere on your script:

```cmake
file(DOWNLOAD https://raw.githubusercontent.com/alandefreitas/find_package_online/master/FindPackageOnline ./FindPackageOnline)
include(FindPackageOnline)
```

Whenever you need a package, you can just do:

```
# ...
find_package_online(Gtest)
find_package_online(Boost)
find_package_online(SQLITE3)
# and so on
```

The command `find_package_online` will look for the package just like `find_package` would. However, if the proper `find_package` module is not available, it will download it to your modules folder and use it instead. 

If there is a valid `find_package` module but the library is not found, it will download a script to add a `ExternalProject` to your project.

## Writing your own modules

If neither `find_package` nor `find_package_online` can find your package, you might need to write a new `FindPackage.cmake` file. 

Writing new modules is very simples. You can use one of the files in the folder [`Modules`](https://github.com/alandefreitas/find_package_online/Modules/) as reference.

If you need to write a new module, please consider sharing so we can keep this community growing and someone else doesn't have to go thought that again. 

### Find module 

Writing a `FindPackage.cmake` module takes a few lines of code:

* A `find_path` command that finds where the header files are:

```cmake
find_path(MYLIBRARY_INCLUDE_DIR
            # possible names for the file in a directory
            NAMES mylib.h
            # Directories to search in addition to the default locations
            PATHS  ${MYLIBRARY_POSSIBLE_ROOT_DIRECTORIES} "$ENV{LIB_DIR}/include"
            # additional subdirectories to check below each directory location
            PATH_SUFFIXES include 
            )
```

* A `find_library` command that finds the library file.

```cmake
find_library( MYLIBRARY_LIBRARY
              # possible names for the file in a directory
              NAMES mylib libmylib libmylibdll 
              # Directories to search in addition to the default locations
              PATHS ${MYLIBRARY_POSSIBLE_ROOT_DIRECTORIES}
              # additional subdirectories to check below each directory location 
              PATH_SUFFIXES lib 
              )
```

* A `find_package_handle_standard_args`

```cmake
find_package_handle_standard_args(MYLIBRARY DEFAULT_MSG MYLIBRARY_LIBRARY MYLIBRARY_INCLUDE_DIR)
```
 
* A `mark_as_advanced` command to mark the named cached variables as advanced.

```cmake
mark_as_advanced(MYLIBRARY_INCLUDE_DIR MYLIBRARY_LIBRARY )
```

* Set the library variables

```cmake
set(MYLIBRARY_LIBRARIES ${MYLIBRARY_LIBRARY} )
set(MYLIBRARY_INCLUDE_DIRS ${MYLIBRARY_INCLUDE_DIR} )
```

### External Project module

If the script that find the package is found but the package itself is not found, write a `ExternalProjectMyLibrary.cmake` script that adds the library with the `ExternalProject_Add` command. 

In most cases, it only takes one command. There are many [![simple examples]](https://cmake.org/cmake/help/git-stage/module/ExternalProject.html?highlight=externalproject#examples) on CMake's website.

## Issues
If you have issues, you can:

* [Create a new issue](https://github.com/alandefreitas/find_package_online/issues/new).
* [Look at closed issues](https://github.com/alandefreitas/find_package_online/issues?q=is%3Aissue+is%3Aclosed)

Thank you for trying this library. [Send me an email](mailto:alandefreitas@gmail.com) for any special considerations.
