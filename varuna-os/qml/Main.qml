// ╔═══════════════════════════════════════════════════════════════════════════╗
// ║ FILE: Main.qml                                                             ║
// ║ LOCATION: varuna-os/qml/Main.qml                                           ║
// ║ PURPOSE: Main application window for VARUNA Embedded OS                    ║
// ║ UPDATED: Phase 3 - Using modular Header, NavigationBar, ScreenContainer   ║
// ╚═══════════════════════════════════════════════════════════════════════════╝

import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import QtQuick.Window
import "components"

ApplicationWindow {
    id: mainWindow

    // =========================================================================
    // APPLICATION CONSTANTS
    // =========================================================================
    readonly property string appVersion: "1.0.3"
    readonly property string deviceId: "CWC-RJ-001"
    readonly property string siteName: "Chambal River Station 1"

    // =========================================================================
    // WINDOW PROPERTIES
    // =========================================================================
    width: 1280
    height: 800
    minimumWidth: 800
    minimumHeight: 480
    visible: true
    title: "VARUNA - Water Level Monitoring System v" + appVersion
    color: "#000000"

    flags: Qt.Window

    font.family: "Monospace"
    font.pixelSize: 14

    // =========================================================================
    // APPLICATION STATE
    // =========================================================================
    property string currentMode: "maintenance"
    property string modeSubtitle: "Device removed from water"
    property bool isDeviceConnected: true
    property bool bootComplete: false
    property int currentScreenIndex: 0

    // =========================================================================
    // MAIN CONTAINER
    // =========================================================================
    Item {
        id: rootContainer
        anchors.fill: parent

        // =====================================================================
        // BOOT SCREEN
        // =====================================================================
        Loader {
            id: bootLoader
            anchors.fill: parent
            active: !mainWindow.bootComplete
            visible: active
            z: 100

            sourceComponent: BootScreen {
                anchors.fill: parent

                onBootComplete: {
                    console.log("[MAIN] Boot sequence completed");
                    mainWindow.bootComplete = true;
                    bootLoader.active = false;
                }

                onSkipRequested: {
                    console.log("[MAIN] Boot skipped by user");
                }
            }
        }

        // =====================================================================
        // MAIN INTERFACE
        // =====================================================================
        Rectangle {
            id: mainInterface
            anchors.fill: parent
            color: "#000000"
            visible: mainWindow.bootComplete
            opacity: mainWindow.bootComplete ? 1 : 0

            Behavior on opacity {
                NumberAnimation {
                    duration: 400
                    easing.type: Easing.OutQuad
                }
            }

            ColumnLayout {
                anchors.fill: parent
                spacing: 0

                // =============================================================
                // HEADER COMPONENT
                // =============================================================
                Header {
                    id: appHeader
                    Layout.fillWidth: true

                    deviceId: mainWindow.deviceId
                    siteName: mainWindow.siteName
                    firmwareVersion: mainWindow.appVersion
                    mode: mainWindow.currentMode
                    modeSubtitle: mainWindow.modeSubtitle
                    isConnected: mainWindow.isDeviceConnected
                    windowWidth: mainWindow.width
                    windowHeight: mainWindow.height

                    onStatusClicked: {
                        console.log("[HEADER] Status badge clicked");
                        // Future: Open mode selection dialog
                    }

                    onTitleClicked: {
                        console.log("[HEADER] Title clicked");
                        // Future: Open device info dialog
                    }
                }

                // =============================================================
                // NAVIGATION BAR COMPONENT
                // =============================================================
                NavigationBar {
                    id: navBar
                    Layout.fillWidth: true

                    currentIndex: mainWindow.currentScreenIndex
                    windowWidth: mainWindow.width
                    windowHeight: mainWindow.height

                    onTabClicked: function(index, tabId) {
                        console.log("[NAV] Tab clicked: " + tabId + " (index: " + index + ")");
                        mainWindow.currentScreenIndex = index;
                    }
                }

                // =============================================================
                // SCREEN CONTAINER
                // =============================================================
                ScreenContainer {
                    id: screenContainer
                    Layout.fillWidth: true
                    Layout.fillHeight: true

                    currentIndex: mainWindow.currentScreenIndex
                    windowWidth: mainWindow.width
                    windowHeight: mainWindow.height
                }
            }
        }
    }

    // =========================================================================
    // KEYBOARD SHORTCUTS
    // =========================================================================

    // Fullscreen toggle
    Shortcut {
        sequence: "F11"
        onActivated: {
            if (mainWindow.visibility === Window.FullScreen) {
                mainWindow.showNormal();
                console.log("[WINDOW] Exited fullscreen");
            } else {
                mainWindow.showFullScreen();
                console.log("[WINDOW] Entered fullscreen");
            }
        }
    }

    // Exit fullscreen
    Shortcut {
        sequence: "Escape"
        onActivated: {
            if (mainWindow.visibility === Window.FullScreen) {
                mainWindow.showNormal();
                console.log("[WINDOW] Exited fullscreen via Escape");
            }
        }
    }

    // Restart boot sequence (debug)
    Shortcut {
        sequence: "Ctrl+R"
        onActivated: {
            if (mainWindow.bootComplete) {
                console.log("[DEBUG] Restarting boot sequence...");
                mainWindow.bootComplete = false;
                bootLoader.active = true;
            }
        }
    }

    // Navigate to next tab
    Shortcut {
        sequence: "Ctrl+Tab"
        onActivated: {
            if (mainWindow.bootComplete) {
                navBar.selectNext();
            }
        }
    }

    // Navigate to previous tab
    Shortcut {
        sequence: "Ctrl+Shift+Tab"
        onActivated: {
            if (mainWindow.bootComplete) {
                navBar.selectPrevious();
            }
        }
    }

    // Quick navigation shortcuts (1-8)
    Shortcut {
        sequence: "Ctrl+1"
        onActivated: { if (mainWindow.bootComplete) navBar.selectByIndex(0); }
    }
    Shortcut {
        sequence: "Ctrl+2"
        onActivated: { if (mainWindow.bootComplete) navBar.selectByIndex(1); }
    }
    Shortcut {
        sequence: "Ctrl+3"
        onActivated: { if (mainWindow.bootComplete) navBar.selectByIndex(2); }
    }
    Shortcut {
        sequence: "Ctrl+4"
        onActivated: { if (mainWindow.bootComplete) navBar.selectByIndex(3); }
    }
    Shortcut {
        sequence: "Ctrl+5"
        onActivated: { if (mainWindow.bootComplete) navBar.selectByIndex(4); }
    }
    Shortcut {
        sequence: "Ctrl+6"
        onActivated: { if (mainWindow.bootComplete) navBar.selectByIndex(5); }
    }
    Shortcut {
        sequence: "Ctrl+7"
        onActivated: { if (mainWindow.bootComplete) navBar.selectByIndex(6); }
    }
    Shortcut {
        sequence: "Ctrl+8"
        onActivated: { if (mainWindow.bootComplete) navBar.selectByIndex(7); }
    }

    // =========================================================================
    // WINDOW INITIALIZATION
    // =========================================================================
    Component.onCompleted: {
        console.log("");
        console.log("═══════════════════════════════════════════════════════════");
        console.log("  VARUNA Embedded OS - Main Window Initialized");
        console.log("═══════════════════════════════════════════════════════════");
        console.log("  Device: " + deviceId);
        console.log("  Site: " + siteName);
        console.log("  Version: " + appVersion);
        console.log("  Size: " + width + " x " + height);
        console.log("═══════════════════════════════════════════════════════════");
        console.log("  Keyboard Shortcuts:");
        console.log("    F11           - Toggle Fullscreen");
        console.log("    Escape        - Exit Fullscreen");
        console.log("    Ctrl+R        - Restart Boot Sequence");
        console.log("    Ctrl+Tab      - Next Screen");
        console.log("    Ctrl+Shift+Tab- Previous Screen");
        console.log("    Ctrl+1..8     - Jump to Screen 1-8");
        console.log("═══════════════════════════════════════════════════════════");
        console.log("");
    }

    // =========================================================================
    // WINDOW RESIZE HANDLER
    // =========================================================================
    onWidthChanged: {
        console.log("[RESPONSIVE] Width: " + width);
    }

    onHeightChanged: {
        console.log("[RESPONSIVE] Height: " + height);
    }
}

// ╔═══════════════════════════════════════════════════════════════════════════╗
// ║ END OF FILE: Main.qml                                                      ║
// ╚═══════════════════════════════════════════════════════════════════════════╝
