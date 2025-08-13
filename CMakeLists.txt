cmake_minimum_required(VERSION 3.15)
project(engine) # Ja, ez beállítja a nevet és CMake verziót.

set(CMAKE_CXX_STANDARD 20) # C++20-at használunk

option(ENABLE_CMAKE_LOGGING "Enable CMake configuration logging" ON)
if(ENABLE_CMAKE_LOGGING)
    message(STATUS "Configuring engine build...")
    message(STATUS "Source directory: ${CMAKE_SOURCE_DIR}")
endif() # Vmi logging bekapcsolása

#ÚÚÚT
set(ENGINE_DIR ${CMAKE_SOURCE_DIR}/engine)
set(GAME_DIR ${CMAKE_SOURCE_DIR}/game)

#Logolás beapcsolása?
if(ENABLE_CMAKE_LOGGING)
    message(STATUS "Engine directory: ${ENGINE_DIR}")
    message(STATUS "Game directory: ${GAME_DIR}")
endif()

# Main ls include/core mindig!!!!!!!
set(SOURCE_FILES ${ENGINE_DIR}/main.cpp)
set(INCLUDE_DIRS ${ENGINE_DIR}/include/core)
list(APPEND HEADERS ${ENGINE_DIR}/engine.hpp)
set(HEADERS)
set(FEATURES_INCLUDED)

# halvány lila gőzöm sics
find_package(spdlog REQUIRED)
if(spdlog_FOUND AND ENABLE_CMAKE_LOGGING)
    message(STATUS "spdlog van: ${spdlog_VERSION}")
endif()

# feature hozzáadás rendszer
function(add_feature FEATURE_NAME)
    if(ENABLE_CMAKE_LOGGING)
        message(STATUS "Feature hozzáadása: ${FEATURE_NAME}")
    endif()

    list(FIND FEATURES_INCLUDED ${FEATURE_NAME} _found)
    if(NOT _found EQUAL -1)
        if(ENABLE_CMAKE_LOGGING)
            message(STATUS "Feature ${FEATURE_NAME} already included, skipping")
        endif()
        return()
    endif()
    
    list(APPEND FEATURES_INCLUDED ${FEATURE_NAME})
    set(FEATURES_INCLUDED ${FEATURES_INCLUDED} PARENT_SCOPE)

    set(DEP_FILE "${ENGINE_DIR}/include/features/${FEATURE_NAME}/dependencies.txt")
    if(EXISTS ${DEP_FILE})
        if(ENABLE_CMAKE_LOGGING)
            message(STATUS "Found dependencies file: ${DEP_FILE}")
        endif()

        file(READ ${DEP_FILE} DEP_CONTENTS)
        string(REPLACE "\n" ";" DEP_LINES "${DEP_CONTENTS}")

        foreach(line ${DEP_LINES})
            string(STRIP "${line}" line)

            if(line MATCHES "^feature:")
                string(REPLACE "feature:" "" ftrs "${line}")
                string(REPLACE "," ";" ftrs "${ftrs}")
                foreach(f ${ftrs})
                    string(STRIP ${f} f)
                    if(ENABLE_CMAKE_LOGGING)
                        message(STATUS "Adding dependency feature: ${f}")
                    endif()
                    add_feature(${f})
                endforeach()
            elseif(line MATCHES "^header:")
                string(REPLACE "header:" "" hdrs "${line}")
                string(REPLACE "," ";" hdrs "${hdrs}")
                foreach(h ${hdrs})
                    string(STRIP ${h} h)
                    set(HDR_PATH "${ENGINE_DIR}/include/${h}")
                    if(EXISTS "${HDR_PATH}")
                        list(APPEND HEADERS "${HDR_PATH}")
                        if(ENABLE_CMAKE_LOGGING)
                            message(STATUS "Adding header: ${h}")
                        endif()
                    else()
                        message(WARNING "Header file not found: ${HDR_PATH}")
                    endif()
                endforeach()
            elseif(line MATCHES "^src:")
                string(REPLACE "src:" "" srcs "${line}")
                string(REPLACE "," ";" srcs "${srcs}")
                foreach(s ${srcs})
                    string(STRIP ${s} s)
                    set(SRC_PATH "${ENGINE_DIR}/src/${s}")
                    if(EXISTS "${SRC_PATH}")
                        list(APPEND SOURCE_FILES "${SRC_PATH}")
                        if(ENABLE_CMAKE_LOGGING)
                            message(STATUS "Adding source: ${s}")
                        endif()
                    else()
                        message(WARNING "Source file not found: ${SRC_PATH}")
                    endif()
                endforeach()
            endif()
        endforeach()

        set(SOURCE_FILES ${SOURCE_FILES} PARENT_SCOPE)
        set(HEADERS ${HEADERS} PARENT_SCOPE)
    else()
        if(ENABLE_CMAKE_LOGGING)
            message(STATUS "No dependencies file found for ${FEATURE_NAME}")
        endif()
    endif()
endfunction()

# olvassa a feature.txt-t
if(EXISTS ${GAME_DIR}/features.txt)
    file(READ ${GAME_DIR}/features.txt GAME_FEATURES)
    string(REPLACE "\n" ";" GAME_FEATURES "${GAME_FEATURES}")
    string(REPLACE "," ";" GAME_FEATURES "${GAME_FEATURES}")

    if(ENABLE_CMAKE_LOGGING)
        message(STATUS "Game features: ${GAME_FEATURES}")
    endif()

    foreach(f ${GAME_FEATURES})
        string(STRIP ${f} f)
        if(NOT f STREQUAL "")
            add_feature(${f})
        endif()
    endforeach()
else()
    message(WARNING "No features.txt found in game directory")
endif()

# Hozzáadja game-et rekurzívan
file(GLOB_RECURSE GAME_SOURCE_FILES
    ${GAME_DIR}/*.cpp
    ${GAME_DIR}/*.c
    ${GAME_DIR}/*.cc
    ${GAME_DIR}/*.cxx
)
foreach(src ${GAME_SOURCE_FILES})
    if(EXISTS "${src}")
        list(APPEND SOURCE_FILES "${src}")
    else()
        message(WARNING "Game source file not found: ${src}")
    endif()
endforeach()

if(ENABLE_CMAKE_LOGGING)
    message(STATUS "Found ${GAME_SOURCE_FILES} game source files")
endif()

# ellopja ezeket
file(GLOB_RECURSE GAME_HEADERS
    ${GAME_DIR}/*.h
    ${GAME_DIR}/*.hpp
    ${GAME_DIR}/*.hh
    ${GAME_DIR}/*.hxx
)
list(APPEND HEADERS ${GAME_HEADERS})

if(ENABLE_CMAKE_LOGGING)
    message(STATUS "Found ${GAME_HEADERS} game header files")
endif()

# Vmi main.cpp hogy menjen.
if(SOURCE_FILES STREQUAL "")
    message(WARNING "No source files found, creating dummy main.cpp")
    file(WRITE "${CMAKE_BINARY_DIR}/dummy_main.cpp" "int main(){return 0;}")
    list(APPEND SOURCE_FILES "${CMAKE_BINARY_DIR}/dummy_main.cpp")
endif()

# hozzáadás
add_executable(Game
    ${SOURCE_FILES}
    ${HEADERS}
)

target_include_directories(Game PRIVATE
    ${INCLUDE_DIRS}
    ${GAME_DIR}
)

# spdlog vmi, chatgpt íjánlotta
target_link_libraries(Game PRIVATE spdlog::spdlog)


option(ENABLE_DEBUG_LOGGING "Enable debug logging" ON)
if(ENABLE_DEBUG_LOGGING)
    target_compile_definitions(Game PRIVATE ENABLE_DEBUG_LOGGING)
    if(ENABLE_CMAKE_LOGGING)
        message(STATUS "Debug logging enabled")
    endif()
endif()

# Add build type specific logging
if(CMAKE_BUILD_TYPE STREQUAL "Debug")
    target_compile_definitions(Game PRIVATE LOG_LEVEL=3)  # Debug level
else()
    target_compile_definitions(Game PRIVATE LOG_LEVEL=2)  # Info level
endif()

if(ENABLE_CMAKE_LOGGING)
    message(STATUS "Build configuration complete")
    message(STATUS "Total source files: ${SOURCE_FILES}")
    message(STATUS "Total headers: ${HEADERS}")
endif()
