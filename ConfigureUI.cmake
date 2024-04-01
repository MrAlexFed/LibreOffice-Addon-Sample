#[=======================================================================[.rst:
ConfigureUI
-------

This module generates configuration files that match the *.xcu, *.xcs, *.png, *.xml, *.xdl, *.components and store it into the ``${UI_FILES}``

The following functions are provided by this module:

- :command:`configure_ui`

Result Variables
^^^^^^^^^^^^^^^^

This will define the following variables:

``${UI_FILES}``
  List of configuration files of LibreOffice addon.

#]=======================================================================]

function(configure_ui)
    message(CHECK_START "Generating files for UI")

    cmake_path(SET UI_DIR "${CMAKE_BINARY_DIR}")

    configure_file(${CMAKE_SOURCE_DIR}/ui/uno.components.in ${UI_DIR}/uno.components.in.1)

    file(GENERATE
         OUTPUT ${UI_DIR}/uno.components
         INPUT ${UI_DIR}/uno.components.in.1
         TARGET SimpleAddon)

    configure_file(${CMAKE_SOURCE_DIR}/ui/Addons.xcu.in ${UI_DIR}/Addons.xcu @ONLY)
    configure_file(${CMAKE_SOURCE_DIR}/ui/manifest.xml.in ${UI_DIR}/META-INF/manifest.xml @ONLY)
    configure_file(${CMAKE_SOURCE_DIR}/ui/WriterWindowState.xcu ${UI_DIR}/WriterWindowState.xcu COPYONLY)
    configure_file(${CMAKE_SOURCE_DIR}/ui/ProtocolHandler.xcu ${UI_DIR}/ProtocolHandler.xcu COPYONLY)
    configure_file(${CMAKE_SOURCE_DIR}/ui/manifest.xml.in ${UI_DIR}/META-INF/manifest.xml)
    configure_file(${CMAKE_SOURCE_DIR}/ui/MyDialog.xdl ${UI_DIR}/MyDialog.xdl COPYONLY)
    configure_file(${CMAKE_SOURCE_DIR}/ui/description.xml.in ${UI_DIR}/description.xml)

    set(UI_FILES
        uno.components
        Addons.xcu
        description.xml
        META-INF/manifest.xml
        WriterWindowState.xcu
        ProtocolHandler.xcu
        MyDialog.xdl
    )

    set_target_properties(SimpleAddon PROPERTIES
                          PREFIX ""
                          OUTPUT_NAME "addon.uno"
                          RUNTIME_OUTPUT_DIRECTORY_DEBUG ${CMAKE_BINARY_DIR}/${EXTENSION_PLATFORM}
                          RUNTIME_OUTPUT_DIRECTORY_RELEASE ${CMAKE_BINARY_DIR}/${EXTENSION_PLATFORM}
                          RUNTIME_OUTPUT_DIRECTORY_RELWITHDEBINFO ${CMAKE_BINARY_DIR}/${EXTENSION_PLATFORM}
                          RUNTIME_OUTPUT_DIRECTORY_MINSIZEREL ${CMAKE_BINARY_DIR}/${EXTENSION_PLATFORM}
                          PDB_OUTPUT_DIRECTORY ${CMAKE_BINARY_DIR}
                          LIBRARY_OUTPUT_DIRECTORY ${CMAKE_BINARY_DIR}/${EXTENSION_PLATFORM})

    add_custom_command(TARGET SimpleAddon
                       POST_BUILD
                       COMMAND ${CMAKE_COMMAND} -E rm -rf ${LibreOffice_CACHE_DIR}/4/user/uno_packages
                       COMMAND ${CMAKE_COMMAND} -E tar cvf ${CMAKE_BINARY_DIR}/addon.oxt --format=zip ${EXTENSION_PLATFORM} ${UI_FILES}
                       COMMAND ${UNOPKG} add -f ${CMAKE_BINARY_DIR}/addon.oxt
                       WORKING_DIRECTORY ${CMAKE_BINARY_DIR}
                       COMMENT "Creating addon.oxt"
                       COMMAND_EXPAND_LISTS
                       VERBATIM)

    message(CHECK_PASS "done")
endfunction()
