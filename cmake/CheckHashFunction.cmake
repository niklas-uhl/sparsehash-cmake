include(CheckSourceCompiles)
function(check_hash_function NAMESPACE _HASH_FUN_H)
  set(CMAKE_REQUIRED_QUIET ON)
  foreach(
    location
    functional;tr1/functional;ext/hash_fun.h;ext/stl_hash_fun;hash_fun.h;stl_hash_fun.h;stl/_hash_fun.h
  )

    check_source_compiles(
      CXX
      "
#include <${location}>
int main(void) {
int x = ${NAMESPACE}::hash<int>()(5);
return 0;
}
"
      FOUND_HASH_FUN)
    if(FOUND_HASH_FUN)
      set(${_HASH_FUN_H} "<${location}>")
      set(${_HASH_FUN_H} "<${location}>" PARENT_SCOPE)
      message(STATUS "Looking for hash function - found")
      message(STATUS "Include for hash function: ${${_HASH_FUN_H}}")
      break()
    endif()
  endforeach()
  if(NOT FOUND_HASH_FUN)
    message(FATAL_ERROR "Could not find hash function.")
  endif()
endfunction()
