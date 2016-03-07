cmake_minimum_required(VERSION 3.3)
project(ECS60P4)

set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -std=c++11")

set(SOURCE_FILES defragmenter.cpp DefragRunner.cpp mynew.cpp)
add_executable(ECS60P4 ${SOURCE_FILES})