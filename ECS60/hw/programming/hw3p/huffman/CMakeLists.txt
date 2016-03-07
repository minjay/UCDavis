cmake_minimum_required(VERSION 3.3)
project(ECS60P3)

set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -std=c++11")

set(SOURCE_FILES huffman.cpp BinaryTree.h)
add_executable(ECS60P3 ${SOURCE_FILES})