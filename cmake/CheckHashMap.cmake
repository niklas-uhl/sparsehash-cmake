include(CheckSourceCompiles)
function(check_hash_map _HASH_NAMESPACE _HAVE_UNORDERED_MAP _HAVE_HASH_MAP
         _HAVE_HASH_SET _HASH_MAP_H)
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
        set(${_HASH_NAMESPACE} ${namespace})
        set(${_HASH_NAMESPACE}
            ${namespace}
            PARENT_SCOPE)
        message(STATUS "Hash namespace: ${${_HASH_NAMESPACE}}")
        set(${_HAVE_UNORDERED_MAP}
            1
            PARENT_SCOPE)
        message(STATUS "Looking for unordered_map - found")
        set(${_HASH_MAP_H} "<${location}>")
        set(${_HASH_MAP_H}
            "<${location}>"
            PARENT_SCOPE)
        message(STATUS "Include for unordered_map: ${${_HASH_MAP_H}}")
        break()
      endif()
    endforeach()
    if(FOUND_HASH_MAP)
      break()
    endif()
  endforeach()
  if(NOT ${_HASH_NAMESPACE})
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
          set(${_HASH_NAMESPACE} ${namespace})
          set(${_HASH_NAMESPACE}
              ${namespace}
              PARENT_SCOPE)
          message(STATUS "Hash namespace: ${${_HASH_NAMESPACE}}")
          set(${_HAVE_HASH_MAP}
              1
              PARENT_SCOPE)
          set(${_HAVE_HASH_SET}
              1
              PARENT_SCOPE)
          message(STATUS "Looking for hash_map - found")
          set(${_HASH_MAP_H} "<${location}>")
          set(${_HASH_MAP_H}
              "<${location}>"
              PARENT_SCOPE)
          message(STATUS "Include for hash_map: ${${_HASH_MAP_H}}")
          break()
        endif()
      endforeach()
      if(FOUND_HASH_MAP)
        break()
      endif()
    endforeach()
  endif()
  if(NOT ${_HASH_NAMESPACE})
    message(FATAL_ERROR "Could not find a hash map implementation.")
  endif()
endfunction()
