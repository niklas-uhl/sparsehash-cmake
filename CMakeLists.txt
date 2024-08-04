cmake_minimum_required(VERSION 3.5)

project(
  Sparsehash
  VERSION 2.0.4
  DESCRIPTION "Google Sparsehash with CMake support"
  HOMEPAGE_URL https://github.com/sparsehash/sparsehash
  LANGUAGES C CXX)

option(SPARSEHASH_BUILD_EXAMPLES "Build examples" ${PROJECT_IS_TOP_LEVEL})

include(CheckSymbolExists)
include(CheckTypeSize)
include(CheckSourceCompiles)
include(CheckIncludeFile)
set(GOOGLE_NAMESPACE "::google")

check_include_file("inttypes.h" HAVE_INTTYPES_H)
if(HAVE_INTTYPES_H)
  list(APPEND CMAKE_EXTRA_INCLUDE_FILES "inttypes.h")
endif()

check_type_size(uint16_t UINT16_T)
check_type_size(u_int16_t U_INT16_T)
check_type_size(__uint16 __UINT16)
check_type_size("long long" LONG_LONG)
check_symbol_exists(memcpy "string.h;stdio.h;stdlib.h;strings.h;unistd.h"
                    HAVE_MEMCPY)
set(CMAKE_REQUIRED_QUIET ON)
foreach(location unordered_map;tr1/unordered_map)
  foreach(namespace std;std::tr1)
    check_source_compiles(
      CXX
      "
#include <${location}>
int main(void) {
const ${namespace}::unordered_map<int, int> t;
return t.find(5) == t.end();
}
"
      FOUND_HASH_MAP)
    if(FOUND_HASH_MAP)
      set(HASH_NAMESPACE ${namespace})
      message(STATUS "Hash namespace: ${namespace}")
      set(HAVE_UNORDERED_MAP 1)
      message(STATUS "Looking for unordered_map - found")
      set(HASH_MAP_H "<${location}>")
      message(STATUS "Include for unordered_map: ${HASH_MAP_H}")
      break()
    endif()
  endforeach()
  if(FOUND_HASH_MAP)
    break()
  endif()
endforeach()
if(NOT HASH_NAMESPACE)
  message(STATUS "Looking for unordered map - not found - trying hash_map")
  foreach(location ext/hash_map;hash_map)
    foreach(namespace in __gnu_cxx;;std;stdext)
      check_source_compiles(
        CXX
        "
#include <${location}>
int main(void) {
${namespace}::hash_map<int, int> t;
return 0;
}
"
        FOUND_HASH_MAP)
      if(FOUND_HASH_MAP)
        set(HASH_NAMESPACE ${namespace})
        message(STATUS "Hash namespace: ${namespace}")
        set(HAVE_HASH_MAP 1)
        set(HAVE_HASH_SET 1)
        message(STATUS "Looking for hash_map - found")
        set(HASH_MAP_H "<${location}>")
        message(STATUS "Include for hash_map: ${HASH_MAP_H}")
        break()
      endif()
    endforeach()
    if(FOUND_HASH_MAP)
      break()
    endif()
  endforeach()
endif()
if(NOT HASH_NAMESPACE)
  message(FATAL_ERROR "Could not find a hash map implementation.")
endif()
foreach(
  location
  functional;tr1/functional;ext/hash_fun.h;ext/stl_hash_fun;hash_fun.h;stl_hash_fun.h;stl/_hash_fun.h
)

  check_source_compiles(
    CXX
    "
#include <${location}>
int main(void) {
int x = ${HASH_NAMESPACE}::hash<int>()(5);
return 0;
}
"
    FOUND_HASH_FUN)
  if(FOUND_HASH_FUN)
    set(HASH_FUN_H "<${location}>")
    message(STATUS "include for hash function: ${HASH_FUN_H}")
    break()
  endif()
endforeach()
if(NOT FOUND_HASH_FUN)
  message(FATAL_ERROR "Could not find hash function.")
endif()
unset(CMAKE_REQUIRED_QUIET)

set(SPARSEHASH_HASH "HASH_NAMESPACE::hash")
set(_END_GOOGLE_NAMESPACE_ "}")
set(_START_GOOGLE_NAMESPACE_ "namespace google {")
configure_file(src/sparseconfig.h.in sparsehash/internal/sparseconfig.h @ONLY)

add_library(sparsehash_sparsehash INTERFACE)
target_include_directories(
  sparsehash_sparsehash
  INTERFACE $<BUILD_INTERFACE:${CMAKE_CURRENT_LIST_DIR}/src>)
add_library(sparsehash::sparsehash ALIAS sparsehash_sparsehash)
target_include_directories(sparsehash_sparsehash
                           INTERFACE $<BUILD_INTERFACE:${CMAKE_BINARY_DIR}>)

if(SPARSEHASH_BUILD_EXAMPLES)
  add_executable(example example.cpp)
  target_link_libraries(example PUBLIC sparsehash::sparsehash)
endif()
