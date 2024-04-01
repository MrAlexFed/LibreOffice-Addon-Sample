cmake_minimum_required(VERSION 3.26)

cmake_path(SET CMAKE_MODULE_PATH ${CMAKE_SOURCE_DIR})

project(SimpleAddon LANGUAGES CXX)

set(CMAKE_CXX_STANDARD 23)
set(CMAKE_POSITION_INDEPENDENT_CODE TRUE)

set(OFFICE_PROGRAM_PATH "C:/Program Files/LibreOffice/program")
cmake_path(SET LibreOffice_CACHE_DIR NORMALIZE $ENV{APPDATA}/LibreOffice)

add_library(SimpleAddon SHARED)

target_sources(SimpleAddon PRIVATE
                DispatchProvider.hxx
                ExportComponent.hxx
                Toolbar.hxx
                
                DispatchProvider.cxx
                ExportComponent.cxx
                Toolbar.cxx)

find_package(LibreOfficeSDK REQUIRED)

target_link_libraries(SimpleAddon PUBLIC LibreOffice::sdk)

set(EXTENSION_PLATFORM "windows_x86_64")

message(CHECK_START "Looking for unopkg needs to register *.oxt in LibreOffice registry")
find_program(UNOPKG
        REQUIRED
        NAMES unopkg
        PATHS ${OFFICE_PROGRAM_PATH}
        NO_DEFAULT_PATH)
message(CHECK_PASS "found")

include(ConfigureUI.cmake)
configure_ui()