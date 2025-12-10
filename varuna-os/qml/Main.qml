import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import QtQuick.Window
import "components"

ApplicationWindow {
    id: mainWindow

    readonly property string appVersion: "1.0.3"
    readonly property string deviceId: "CWC-RJ-001"
    readonly property string siteName: "Chambal River Station 1"

    width: 1280
    height: 800
    minimumWidth: 800
    minimumHeight: 480
    visible: true
    title: "VARUNA - Water Level Monitoring System v" + appVersion
    color: "#000000"

    // Kiosk mode properties (set from C++)
    property bool isKioskMode: typeof kioskMode !== "undefined" ? kioskMode : false
    property bool isWindowedMode: typeof windowedMode !== "undefined" ? windowedMode : false

    // Remove window decorations in kiosk mode
    flags: isKioskMode ? (Qt.Window | Qt.FramelessWindowHint) : Qt.Window

    // Start fullscreen in kiosk mode
    visibility: isKioskMode ? Window.FullScreen : Window.Windowed

    font.family: "Monospace"
    font.pixelSize: 14

    property string currentMode: "maintenance"
    property string modeSubtitle: "Device removed from water"
    property bool isDeviceConnected: true
    property bool bootComplete: false
    property int currentScreenIndex: 0

    Item {
        id: rootContainer
        anchors.fill: parent

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

        Rectangle {
            id: mainInterface
            anchors.fill: parent
            color: "#000000"
            visible: mainWindow.bootComplete
            opacity: mainWindow.bootComplete ? 1 : 0

            Behavior on opacity {
                NumberAnimation { duration: 400; easing.type: Easing.OutQuad }
            }

            ColumnLayout {
                anchors.fill: parent
                spacing: 0

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

                    onStatusClicked: console.log("[HEADER] Status clicked")
                    onTitleClicked: console.log("[HEADER] Title clicked")
                }

                NavigationBar {
                    id: navBar
                    Layout.fillWidth: true
                    currentIndex: mainWindow.currentScreenIndex
                    windowWidth: mainWindow.width
                    windowHeight: mainWindow.height

                    onTabClicked: function(index, tabId) {
                        console.log("[NAV] Tab: " + tabId);
                        mainWindow.currentScreenIndex = index;
                    }
                }

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

    // Keyboard shortcuts
    Shortcut {
        sequence: "F11"
        onActivated: {
            if (mainWindow.visibility === Window.FullScreen) {
                mainWindow.showNormal();
            } else {
                mainWindow.showFullScreen();
            }
        }
    }

    Shortcut {
        sequence: "Escape"
        onActivated: {
            // In kiosk mode, don't allow escape to exit fullscreen
            if (!mainWindow.isKioskMode && mainWindow.visibility === Window.FullScreen) {
                mainWindow.showNormal();
            }
        }
    }

    Shortcut {
        sequence: "Ctrl+R"
        onActivated: {
            if (mainWindow.bootComplete) {
                mainWindow.bootComplete = false;
                bootLoader.active = true;
            }
        }
    }

    Shortcut {
        sequence: "Ctrl+Tab"
        onActivated: { if (mainWindow.bootComplete) navBar.selectNext(); }
    }

    Shortcut {
        sequence: "Ctrl+Shift+Tab"
        onActivated: { if (mainWindow.bootComplete) navBar.selectPrevious(); }
    }

    Shortcut { sequence: "Ctrl+1"; onActivated: { if (mainWindow.bootComplete) navBar.selectByIndex(0); } }
    Shortcut { sequence: "Ctrl+2"; onActivated: { if (mainWindow.bootComplete) navBar.selectByIndex(1); } }
    Shortcut { sequence: "Ctrl+3"; onActivated: { if (mainWindow.bootComplete) navBar.selectByIndex(2); } }
    Shortcut { sequence: "Ctrl+4"; onActivated: { if (mainWindow.bootComplete) navBar.selectByIndex(3); } }
    Shortcut { sequence: "Ctrl+5"; onActivated: { if (mainWindow.bootComplete) navBar.selectByIndex(4); } }
    Shortcut { sequence: "Ctrl+6"; onActivated: { if (mainWindow.bootComplete) navBar.selectByIndex(5); } }
    Shortcut { sequence: "Ctrl+7"; onActivated: { if (mainWindow.bootComplete) navBar.selectByIndex(6); } }
    Shortcut { sequence: "Ctrl+8"; onActivated: { if (mainWindow.bootComplete) navBar.selectByIndex(7); } }

    // Secret exit shortcut for kiosk mode (Ctrl+Alt+Q)
    Shortcut {
        sequence: "Ctrl+Alt+Q"
        onActivated: {
            console.log("[KIOSK] Emergency exit requested");
            Qt.quit();
        }
    }

    Component.onCompleted: {
        console.log("");
        console.log("═══════════════════════════════════════════════════════════");
        console.log("  VARUNA Embedded OS - Window Initialized");
        console.log("═══════════════════════════════════════════════════════════");
        console.log("  Device: " + deviceId);
        console.log("  Kiosk Mode: " + isKioskMode);
        console.log("  Size: " + width + " x " + height);
        console.log("═══════════════════════════════════════════════════════════");
    }
}
