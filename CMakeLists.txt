cmake_minimum_required(VERSION 3.24)

project(Sparsehash
  VERSION 2.0.4
  DESCRIPTION "Google Sparsehash with CMake support"
  HOMEPAGE_URL https://github.com/sparsehash/sparsehash
  LANGUAGES C CXX
)

option(SPARSEHASH_BUILD_EXAMPLES "Build examples" ${PROJECT_IS_TOP_LEVEL})

include(ExternalProject)

ExternalProject_Add(
  sparsehash
  SOURCE_DIR ${CMAKE_CURRENT_LIST_DIR}
  CONFIGURE_COMMAND CC=${CMAKE_C_COMPILER} CXX=${CMAKE_CXX_COMPILER} <SOURCE_DIR>/configure --prefix=<INSTALL_DIR>
  INSTALL_COMMAND make install
  # this does not play well with the clean target, because the directories are not empty
  # INSTALL_BYPRODUCTS <INSTALL_DIR>/include <INSTALL_DIR>/lib <INSTALL_DIR>/share
)
ExternalProject_Get_Property(sparsehash INSTALL_DIR)

add_library(sparsehash::sparsehash INTERFACE IMPORTED)
file(MAKE_DIRECTORY "${INSTALL_DIR}/include")
target_include_directories(sparsehash::sparsehash INTERFACE "${INSTALL_DIR}/include")
add_dependencies(sparsehash::sparsehash sparsehash)

if(SPARSEHASH_BUILD_EXAMPLES)
  add_executable(example example.cpp)
  target_link_libraries(example PUBLIC sparsehash::sparsehash)
endif()
