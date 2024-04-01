cmake_minimum_required(VERSION 3.24)

include(FindPackageHandleStandardArgs)

cmake_path(SET LibreOfficeSDK_DIR "C:/Program Files/LibreOffice/sdk")

find_package_handle_standard_args(LibreOfficeSDK DEFAULT_MSG LibreOfficeSDK_DIR)

cmake_path(SET LibreOffice_DIR ${LibreOfficeSDK_DIR}/..)
cmake_path(SET LibreOfficeSDK_INCLUDE_DIR ${LibreOfficeSDK_DIR}/include)
cmake_path(SET INCLUDE_GENERATED_HEADERS $ENV{APPDATA}/libreoffice_sdk_headers/Windows/inc)

find_path(LibreOffice_PROGRAM_DIR soffice.bin
            REQUIRED
            PATHS ${LibreOffice_DIR}
            PATH_SUFFIXES program)

find_path(LIBREOFFICE_URE_MISC_DIR types.rdb
            REQUIRED
            PATHS ${LibreOffice_PROGRAM_DIR})

find_path(LibreOffice_OFFICE_TYPES_DIR offapi.rdb
            REQUIRED
            PATHS ${LibreOffice_PROGRAM_DIR}
            PATH_SUFFIXES types)

if (NOT TARGET LibreOffice::sdk)
    add_library(LibreOffice::sdk INTERFACE IMPORTED)
endif ()

target_include_directories(LibreOffice::sdk 
                            INTERFACE
                            ${LibreOfficeSDK_INCLUDE_DIR}
                            ${INCLUDE_GENERATED_HEADERS})

target_link_libraries(LibreOffice::sdk
                        INTERFACE
                        LibreOfficeSDK::uno_sal
                        LibreOfficeSDK::uno_cppu
                        LibreOfficeSDK::uno_cppuhelper
                        )

target_compile_options(LibreOffice::sdk
                        INTERFACE
                        $<$<CXX_COMPILER_ID:MSVC>:
                        /FS
                        /Zm500
                        /Zc:wchar_t
                        /wd4251
                        /wd4275
                        /wd4290
                        /wd4675
                        /wd4786
                        /wd4800
                        /GR
                        /EHa>)

target_compile_definitions(LibreOffice::sdk
                            INTERFACE
                            $<$<CXX_COMPILER_ID:MSVC>:
                            WNT
                            _DLL
                            CPPU_ENV=mscx>)

find_program(CPPUMAKER
            REQUIRED
            NAMES cppumaker
            PATHS ${LibreOfficeSDK_DIR}
            PATH_SUFFIXES bin
            NO_DEFAULT_PATH)

find_library(uno_sal_PATH
            REQUIRED
            NAMES uno_sal isal
            PATHS ${LibreOfficeSDK_DIR}
            PATH_SUFFIXES lib)

find_library(uno_cppu_PATH
            REQUIRED
            NAMES uno_cppu icppu
            PATHS ${LibreOfficeSDK_DIR}
            PATH_SUFFIXES lib)

find_library(uno_cppuhelper_PATH
            REQUIRED
            NAMES uno_cppuhelpergss3 icppuhelper
            PATHS ${LibreOfficeSDK_DIR}
            PATH_SUFFIXES lib)

add_library(LibreOfficeSDK::uno_sal SHARED IMPORTED)
add_library(LibreOfficeSDK::uno_cppu SHARED IMPORTED)
add_library(LibreOfficeSDK::uno_cppuhelper SHARED IMPORTED)

set_target_properties(LibreOfficeSDK::uno_sal PROPERTIES
                        IMPORTED_IMPLIB ${uno_sal_PATH})

set_target_properties(LibreOfficeSDK::uno_cppu PROPERTIES
                        IMPORTED_IMPLIB ${uno_cppu_PATH})

set_target_properties(LibreOfficeSDK::uno_cppuhelper PROPERTIES
                        IMPORTED_IMPLIB ${uno_cppuhelper_PATH})

if (NOT EXISTS ${INCLUDE_GENERATED_HEADERS})

    set(ENV{PATH} "${LibreOffice_PROGRAM_DIR};$ENV{PATH}")
    execute_process( COMMAND ${CPPUMAKER} -Gc -O ${INCLUDE_GENERATED_HEADERS} ${LibreOffice_PROGRAM_DIR}/types.rdb
                        ${LibreOffice_OFFICE_TYPES_DIR}/offapi.rdb RESULT_VARIABLE result)

    message(${result})
endif ()