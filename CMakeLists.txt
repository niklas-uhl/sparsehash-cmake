cmake_minimum_required(VERSION 3.5)

project(
  Sparsehash
  VERSION 2.0.4
  DESCRIPTION "Google Sparsehash with CMake support"
  HOMEPAGE_URL https://github.com/sparsehash/sparsehash
  LANGUAGES C CXX)

list(APPEND CMAKE_MODULE_PATH "${CMAKE_CURRENT_LIST_DIR}/cmake")

option(SPARSEHASH_BUILD_EXAMPLES "Build examples" ${PROJECT_IS_TOP_LEVEL})

include(DetermineCompilerDefinitions)
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
