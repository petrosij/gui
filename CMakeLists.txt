cmake_minimum_required(VERSION 3.16)
project(gui VERSION 1.2.0)
message(STATUS "Building ${PROJECT_NAME} version ${PROJECT_VERSION}")


set(CMAKE_CXX_STANDARD 17)
set(CMAKE_CXX_STANDARD_REQUIRED ON)

# AUTOMOC/AUTOUIC/AUTORCC — работают отлично
set(CMAKE_AUTOMOC ON)
set(CMAKE_AUTOUIC ON)
set(CMAKE_AUTORCC ON)

find_package(Qt6 REQUIRED COMPONENTS Core Widgets)

set(SOURCES src/main.cpp src/mainwindow.cpp)
set(HEADERS include/mainwindow.h)
set(UI_FILES resources/mainwindow.ui)

add_executable(${PROJECT_NAME} ${SOURCES} ${HEADERS} ${UI_FILES})

target_include_directories(
    ${PROJECT_NAME} PRIVATE
    ${CMAKE_CURRENT_SOURCE_DIR}/include
)

target_link_libraries(${PROJECT_NAME}
    Qt6::Core
    Qt6::Widgets
)