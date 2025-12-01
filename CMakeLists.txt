cmake_minimum_required(VERSION 3.5)

project(
  Sparsehash
  VERSION 2.0.4
  DESCRIPTION "Google Sparsehash with CMake support"
  HOMEPAGE_URL https://github.com/sparsehash/sparsehash
  LANGUAGES C CXX)

list(APPEND CMAKE_MODULE_PATH "${CMAKE_CURRENT_LIST_DIR}/cmake")

option(SPARSEHASH_BUILD_EXAMPLES "Build examples" ${PROJECT_IS_TOP_LEVEL})

################################
# Check for types and includes #
################################

include(CheckSymbolExists)
include(CheckTypeSize)
include(CheckIncludeFile)
include(SetupGoogleNamespace)
include(CheckHashMap)
include(CheckHashFunction)

setup_google_namespace(google)

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

check_hash_map(HASH_NAMESPACE HAVE_UNORDERED_MAP HAVE_HASH_MAP HAVE_HASH_SET
  HASH_MAP_H)

check_hash_function(${HASH_NAMESPACE} HASH_FUN_H)

set(SPARSEHASH_HASH "HASH_NAMESPACE::hash")

###############################################################
# Configure the config header with the information from above #
###############################################################

configure_file(src/sparseconfig.h.in sparsehash/internal/sparseconfig.h @ONLY)

######################
# Define the library #
######################
add_library(sparsehash_sparsehash INTERFACE)
target_include_directories(
  sparsehash_sparsehash
  INTERFACE $<BUILD_INTERFACE:${CMAKE_CURRENT_LIST_DIR}/src>)
add_library(sparsehash::sparsehash ALIAS sparsehash_sparsehash)
target_include_directories(sparsehash_sparsehash
                           INTERFACE $<BUILD_INTERFACE:${CMAKE_CURRENT_BINARY_DIR}>)

if(SPARSEHASH_BUILD_EXAMPLES)
  add_executable(example example.cpp)
  target_link_libraries(example PUBLIC sparsehash::sparsehash)
endif()
