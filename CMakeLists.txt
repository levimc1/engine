cmake_minimum_required(VERSION 3.15)
project(engine)

set(CMAKE_CXX_STANDARD 20)

# Enable verbose logging for CMake configuration (optional)
option(ENABLE_CMAKE_LOGGING "Enable CMake configuration logging" ON)
if(ENABLE_CMAKE_LOGGING)
    message(STATUS "Configuring engine build...")
    message(STATUS "Source directory: ${CMAKE_SOURCE_DIR}")
endif()

# Engine and game paths
set(ENGINE_DIR ${CMAKE_SOURCE_DIR}/engine)
set(GAME_DIR ${CMAKE_SOURCE_DIR}/game)

if(ENABLE_CMAKE_LOGGING)
    message(STATUS "Engine directory: ${ENGINE_DIR}")
    message(STATUS "Game directory: ${GAME_DIR}")
endif()

# Always include core headers and main.cpp
set(SOURCE_FILES ${ENGINE_DIR}/src/main.cpp)
set(INCLUDE_DIRS ${ENGINE_DIR}/include/core)
set(HEADERS)
set(FEATURES_INCLUDED)

# Find and include spdlog for runtime logging
find_package(spdlog REQUIRED)
if(spdlog_FOUND AND ENABLE_CMAKE_LOGGING)
    message(STATUS "spdlog found: ${spdlog_VERSION}")
endif()

# Function to add a feature and its dependencies with logging
function(add_feature FEATURE_NAME)
    if(ENABLE_CMAKE_LOGGING)
        message(STATUS "Processing feature: ${FEATURE_NAME}")
    endif()

    # Skip if already added
    list(FIND FEATURES_INCLUDED ${FEATURE_NAME} _found)
    if(NOT _found EQUAL -1)
        if(ENABLE_CMAKE_LOGGING)
            message(STATUS "Feature ${FEATURE_NAME} already included, skipping")
        endif()
        return()
    endif()
    
    list(APPEND FEATURES_INCLUDED ${FEATURE_NAME})
    set(FEATURES_INCLUDED ${FEATURES_INCLUDED} PARENT_SCOPE)

    # Check if dependencies.txt exists
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
                    list(APPEND HEADERS "${ENGINE_DIR}/include/${h}")
                    if(ENABLE_CMAKE_LOGGING)
                        message(STATUS "Adding header: ${h}")
                    endif()
                endforeach()
            elseif(line MATCHES "^src:")
                string(REPLACE "src:" "" srcs "${line}")
                string(REPLACE "," ";" srcs "${srcs}")
                foreach(s ${srcs})
                    string(STRIP ${s} s)
                    list(APPEND SOURCE_FILES "${ENGINE_DIR}/src/${s}")
                    if(ENABLE_CMAKE_LOGGING)
                        message(STATUS "Adding source: ${s}")
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

# Read features.txt from game folder
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

# Add all game source files recursively
file(GLOB_RECURSE GAME_SOURCE_FILES
    ${GAME_DIR}/*.cpp
    ${GAME_DIR}/*.c
    ${GAME_DIR}/*.cc
    ${GAME_DIR}/*.cxx
)
list(APPEND SOURCE_FILES ${GAME_SOURCE_FILES})

if(ENABLE_CMAKE_LOGGING)
    message(STATUS "Found ${GAME_SOURCE_FILES} game source files")
endif()

# Add all game headers recursively (for IDE support)
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

# Add executable
add_executable(Game
    ${SOURCE_FILES}
    ${HEADERS}
)

# Include directories
target_include_directories(Game PRIVATE
    ${INCLUDE_DIRS}
    ${GAME_DIR}
)

# Link spdlog for runtime logging
target_link_libraries(Game PRIVATE spdlog::spdlog)

# Add compile definition for logging level
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