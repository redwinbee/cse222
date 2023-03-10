cmake_minimum_required(VERSION 3.24)
project(untitled C)

set(CMAKE_C_STANDARD 11)

# Find libsodium
find_package(PkgConfig REQUIRED)
pkg_check_modules(SODIUM REQUIRED libsodium)

# Add the libsodium include path to the include directories
include_directories(${SODIUM_INCLUDE_DIRS})

# Add the libsodium library path to the linker search directories
link_directories(${SODIUM_LIBRARY_DIRS})

# Create the executable
add_executable(untitled main.c)

# Link against the libsodium library
target_link_libraries(untitled ${SODIUM_LIBRARIES})
