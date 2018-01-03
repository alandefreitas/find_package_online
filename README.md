# The Easiest CMake Package Manager Ever

This is the simplest CMake package manager ever, so you don't ever have  problems again when sharing your projects with your team. You can integrate the package manager by inserting the following code anywhere on your script:

```cmake
file(DOWNLOAD https://raw.githubusercontent.com/alandefreitas/find_package_online/master/FindPackageOnline ${CMAKE_CURRENT_SOURCE_DIR}/FindPackageOnline)
include(FindPackageOnline)
```

If you want to make it faster:

```cmake
if (NOT EXISTS ${FindPackageOnline})
    file(DOWNLOAD https://raw.githubusercontent.com/alandefreitas/find_package_online/master/FindPackageOnline ${CMAKE_CURRENT_SOURCE_DIR}/FindPackageOnline)
endif()
include(FindPackageOnline)
```

Whenever you need a package, you can just do:

```
find_package_online(GoogleBenchmark)
find_package_online(Boost)
find_package_online(PEGTL)
find_package_online(SQLITE3)
```

and so on...

The command `find_package_online` will look for the package just like `find_package` would. However, if the proper `find_package` module is not available, it will download it to your modules folder and use it instead. 

If there is a valid `find_package` module but the library is not found, it will download a script to add a `ExternalProject` to your project.

- [Examples](#examples)
- [Writing your own modules](#writing-your-own-modules)
    - [Find module](#find-module)
    - [External Project module](#external-project-module)
- [Issues](#issues)

## Examples

Using [Google Benchmark](https://github.com/google/benchmark) on a project:

```cmake
cmake_minimum_required(VERSION 2.8.4)
project(myproject)

if (NOT EXISTS ${FindPackageOnline})
    file(DOWNLOAD https://raw.githubusercontent.com/alandefreitas/find_package_online/master/FindPackageOnline ${CMAKE_CURRENT_SOURCE_DIR}/FindPackageOnline)
endif()
include(FindPackageOnline)

find_package_online(GoogleBenchmark)
include_directories(${GoogleBenchmark_INCLUDE_DIRS})

add_executable(benchmark_executable benchmark.cpp)
target_link_libraries(benchmark_executable ${GoogleBenchmark_LIBRARIES})
```

Using [PEGTL](https://github.com/taocpp/PEGTL) on a project:

```cmake
cmake_minimum_required(VERSION 2.8.4)
project(myproject)

if (NOT EXISTS ${FindPackageOnline})
    file(DOWNLOAD https://raw.githubusercontent.com/alandefreitas/find_package_online/master/FindPackageOnline ${CMAKE_CURRENT_SOURCE_DIR}/FindPackageOnline)
endif()
include(FindPackageOnline)

find_package_online(PEGTL)
include_directories(${PEGTL_INCLUDE_DIRS})

add_executable(pegtl_executable pegtl.cpp)
target_link_libraries(pegtl_executable ${PEGTL_LIBRARIES})
```

## Writing your own modules

**You probably won't need to write your own modules** (that's the whole point), but if neither `find_package` nor `find_package_online` have a proper `find` module, you might need to write a new `FindPackage.cmake` file. Writing new modules is very simple. You can use one of the files in the folder [`Modules`](./Modules/) as reference.

* **If you do need to write a new module, please consider sharing so other people can find packages online so they have to go thought that again.** 

### Find module 

Writing a `FindPackage.cmake` module takes a few lines of code. You can use other modules as reference:

* Example 1: Finding a header only library ([`FindPEGTL.cmake`](./Modules/FindPEGTL.cmake`))
* Example 2: Finding a library ([`FindGoogleBenchmark.cmake`](./Modules/FindGoogleBenchmark.cmake`))

Anyway, there are only a few steps involved in finding a library:

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

* **If you do need to write a new module, please consider sharing so other people can find packages online so they have to go thought that again.** 

### External Project module

If the script that find the package is found but the package itself is not found, write a `ExternalProjectMyLibrary.cmake` script that adds the library with the `ExternalProject_Add` command. 

When writing a `ExternalProjectMyLibrary.cmake` module, you can use other modules as reference:

* Example 1: External CMake header only library on github ([`ExternalProjectPEGTL.cmake`](./Modules/ExternalProjectPEGTL.cmake`))
* Example 2: External CMake library on github  ([`ExternalProjectGoogleBenchmark.cmake`](./Modules/ExternalProjectGoogleBenchmark.cmake`))
* Example 2: External library on the web ([`ExternalProjectBoost.cmake`](./Modules/ExternalProjectBoost.cmake`))

There are only a few steps involved in finding a library. In most cases, it only takes one command. There are many [simple examples](https://cmake.org/cmake/help/git-stage/module/ExternalProject.html#examples) on CMake's website.

* **If you do need to write a new module, please consider sharing so other people can find packages online so they have to go thought that again.** 

## Issues
If you have issues, you can:

* [Create a new issue](https://github.com/alandefreitas/find_package_online/issues/new).
* [Look at closed issues](https://github.com/alandefreitas/find_package_online/issues?q=is%3Aissue+is%3Aclosed)

Thank you for trying this library. [Send me an email](mailto:alandefreitas@gmail.com) for any special considerations.
