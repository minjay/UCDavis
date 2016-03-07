cmake_minimum_required(VERSION 3.3)
project(ECS60P2)

include_directories(
        ${PROJECT_SOURCE_DIR}/include_static
        ${PROJECT_SOURCE_DIR}/include)

set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -std=c++11")

set(SOURCE_FILES
        src/BTreeDriverDebug.cpp
        src/BTree.cpp
        src/BTreeNode.cpp
        src/LeafNode.cpp
        src/InternalNode.cpp)

add_executable(BTree ${SOURCE_FILES})