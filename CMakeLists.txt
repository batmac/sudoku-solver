cmake_minimum_required(VERSION 3.10)
project(sudoku LANGUAGES C)
add_compile_options(-Wall -Wextra -pedantic)

if(NOT CMAKE_BUILD_TYPE)
    set(CMAKE_BUILD_TYPE Release)
endif()

include(CheckIPOSupported)
check_ipo_supported(RESULT ipo OUTPUT ipo_output)

if(ipo)
    set(CMAKE_INTERPROCEDURAL_OPTIMIZATION TRUE)
    message(STATUS "IPO is supported.")
else()
    message(STATUS "IPO is not supported.")
endif()

add_executable(${PROJECT_NAME} ${PROJECT_NAME}.c)

find_package(OpenMP)

if(OpenMP_C_FOUND)
    target_link_libraries(${PROJECT_NAME} PUBLIC OpenMP::OpenMP_C)
else()
    message(WARNING "OpenMP not found.")
endif()

enable_testing()
add_subdirectory("test")
