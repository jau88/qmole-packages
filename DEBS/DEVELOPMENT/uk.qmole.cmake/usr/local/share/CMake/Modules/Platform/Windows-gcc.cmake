SET(CMAKE_LINK_LIBRARY_SUFFIX "")  
SET(CMAKE_STATIC_LIBRARY_PREFIX "lib")
SET(CMAKE_STATIC_LIBRARY_SUFFIX ".a")
SET(CMAKE_SHARED_LIBRARY_PREFIX "lib")          # lib
SET(CMAKE_SHARED_LIBRARY_SUFFIX ".dll")          # .so
SET(CMAKE_SHARED_MODULE_PREFIX "lib")          # lib
SET(CMAKE_SHARED_MODULE_SUFFIX ".dll")          # .so
SET(CMAKE_IMPORT_LIBRARY_PREFIX "lib")
SET(CMAKE_IMPORT_LIBRARY_SUFFIX ".dll.a")
SET(CMAKE_EXECUTABLE_SUFFIX ".exe")          # .exe
SET(CMAKE_DL_LIBS "")
SET(CMAKE_SHARED_LIBRARY_C_FLAGS "")            # -pic 
SET(CMAKE_SHARED_LIBRARY_CXX_FLAGS "")            # -pic 
SET(CMAKE_SHARED_LIBRARY_CREATE_C_FLAGS "-shared")       # -shared
SET(CMAKE_SHARED_LIBRARY_LINK_C_FLAGS "")         # +s, flag for exe link to use shared lib
SET(CMAKE_SHARED_LIBRARY_RUNTIME_C_FLAG "")       # -rpath
SET(CMAKE_SHARED_LIBRARY_RUNTIME_C_FLAG_SEP "")   # : or empty
SET(CMAKE_LIBRARY_PATH_FLAG "-L")
SET(CMAKE_LINK_LIBRARY_FLAG "-l")

IF(MINGW)
  SET(CMAKE_FIND_LIBRARY_PREFIXES "lib" "")
  SET(CMAKE_FIND_LIBRARY_SUFFIXES ".dll" ".dll.a" ".a")
ENDIF(MINGW)

SET(CMAKE_C_CREATE_SHARED_MODULE
  "<CMAKE_C_COMPILER> <CMAKE_SHARED_MODULE_C_FLAGS> <LINK_FLAGS> <CMAKE_SHARED_MODULE_CREATE_C_FLAGS> -o <TARGET> <OBJECTS> <LINK_LIBRARIES>")
SET(CMAKE_CXX_CREATE_SHARED_MODULE
  "<CMAKE_CXX_COMPILER> <CMAKE_SHARED_MODULE_CXX_FLAGS> <LINK_FLAGS> <CMAKE_SHARED_MODULE_CREATE_CXX_FLAGS> -o <TARGET> <OBJECTS> <LINK_LIBRARIES>")

SET(CMAKE_C_CREATE_SHARED_LIBRARY
  "<CMAKE_C_COMPILER> <CMAKE_SHARED_LIBRARY_C_FLAGS> <LINK_FLAGS> <CMAKE_SHARED_LIBRARY_CREATE_C_FLAGS> -o <TARGET> -Wl,--out-implib,<TARGET_IMPLIB> <OBJECTS> <LINK_LIBRARIES>")
SET(CMAKE_CXX_CREATE_SHARED_LIBRARY
  "<CMAKE_CXX_COMPILER> <CMAKE_SHARED_LIBRARY_CXX_FLAGS> <LINK_FLAGS> <CMAKE_SHARED_LIBRARY_CREATE_CXX_FLAGS> -o <TARGET> -Wl,--out-implib,<TARGET_IMPLIB> <OBJECTS> <LINK_LIBRARIES>")