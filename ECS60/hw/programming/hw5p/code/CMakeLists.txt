cmake_minimum_required(VERSION 3.3)
project(ECS60P5)

set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -std=c++11")

set(SOURCE_FILES NetDriver.cpp maxfinder.cpp)
add_executable(ECS60P5 ${SOURCE_FILES})