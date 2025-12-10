# ╔═══════════════════════════════════════════════════════════════════════════╗
# ║ FILE: CMakeLists.txt                                                       ║
# ║ LOCATION: varuna-os/CMakeLists.txt                                         ║
# ║ PURPOSE: CMake build configuration for VARUNA Embedded OS                  ║
# ║ FIXED: Using qt_add_resources for reliable QRC handling                   ║
# ╚═══════════════════════════════════════════════════════════════════════════╝

cmake_minimum_required(VERSION 3.16)

project(VarunaOS
    VERSION 1.0.3
    DESCRIPTION "VARUNA Water Level Monitoring System - Embedded OS"
    LANGUAGES CXX
)

set(CMAKE_CXX_STANDARD 17)
set(CMAKE_CXX_STANDARD_REQUIRED ON)

set(CMAKE_AUTOMOC ON)
set(CMAKE_AUTORCC ON)
set(CMAKE_AUTOUIC ON)

find_package(Qt6 6.2 REQUIRED COMPONENTS
    Core
    Gui
    Qml
    Quick
    QuickControls2
)

qt_standard_project_setup()

# Create executable with resources
qt_add_executable(VarunaOS
    main.cpp
    resources.qrc
)

target_link_libraries(VarunaOS PRIVATE
    Qt6::Core
    Qt6::Gui
    Qt6::Qml
    Qt6::Quick
    Qt6::QuickControls2
)

set_target_properties(VarunaOS PROPERTIES
    WIN32_EXECUTABLE TRUE
    MACOSX_BUNDLE TRUE
)

if(CMAKE_SYSTEM_NAME STREQUAL "Linux")
    set_target_properties(VarunaOS PROPERTIES
        RUNTIME_OUTPUT_DIRECTORY "${CMAKE_BINARY_DIR}/bin"
    )
endif()

install(TARGETS VarunaOS
    BUNDLE DESTINATION .
    LIBRARY DESTINATION ${CMAKE_INSTALL_LIBDIR}
    RUNTIME DESTINATION ${CMAKE_INSTALL_BINDIR}
)

message(STATUS "")
message(STATUS "═══════════════════════════════════════════════════════════")
message(STATUS "  VARUNA Embedded OS - Build Configuration")
message(STATUS "═══════════════════════════════════════════════════════════")
message(STATUS "  Version  : ${PROJECT_VERSION}")
message(STATUS "  Qt       : ${Qt6_VERSION}")
message(STATUS "  C++      : ${CMAKE_CXX_STANDARD}")
message(STATUS "  Platform : ${CMAKE_SYSTEM_NAME}")
message(STATUS "═══════════════════════════════════════════════════════════")
message(STATUS "")

# ╔═══════════════════════════════════════════════════════════════════════════╗
# ║ END OF FILE: CMakeLists.txt                                                ║
# ╚═══════════════════════════════════════════════════════════════════════════╝
