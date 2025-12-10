// ╔═══════════════════════════════════════════════════════════════════════════╗
// ║ FILE: ScreenContainer.qml                                                  ║
// ║ LOCATION: varuna-os/qml/components/ScreenContainer.qml                     ║
// ║ PURPOSE: Container for all application screens with navigation            ║
// ║ UPDATED: Phase 7.6 - ALL SCREENS COMPLETE                                 ║
// ╚═══════════════════════════════════════════════════════════════════════════╝

import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import "../screens"

Rectangle {
    id: root

    property int currentIndex: 0
    property int windowWidth: 1280
    property int windowHeight: 800

    readonly property var screenNames: [
        "overview", "sensors", "history", "logs",
        "system", "calibrate", "export", "terminal"
    ]

    readonly property color bgColor: "#000000"
    readonly property color textPrimary: "#00FF00"
    readonly property color textSecondary: "#888888"
    readonly property color textMuted: "#666666"
    readonly property color cardBg: "#1A1A1A"
    readonly property color borderColor: "#333333"
    readonly property string fontMono: "Monospace"

    readonly property int contentPadding: {
        if (windowWidth <= 800) return 15;
        if (windowWidth <= 1280) return 20;
        if (windowWidth <= 1920) return 30;
        return 40;
    }

    readonly property int contentSpacing: {
        if (windowWidth <= 800) return 10;
        if (windowWidth <= 1280) return 15;
        if (windowWidth <= 1920) return 20;
        return 25;
    }

    readonly property int titleFontSize: {
        if (windowWidth <= 800) return 16;
        if (windowWidth <= 1280) return 18;
        if (windowWidth <= 1920) return 22;
        return 26;
    }

    readonly property int normalFontSize: {
        if (windowWidth <= 800) return 12;
        if (windowWidth <= 1280) return 14;
        if (windowWidth <= 1920) return 15;
        return 17;
    }

    color: bgColor

    signal navigateToScreen(int index)

    StackLayout {
        id: screenStack
        anchors.fill: parent
        currentIndex: root.currentIndex

        // =====================================================================
        // SCREEN 0: OVERVIEW
        // =====================================================================
        OverviewScreen {
            windowWidth: root.windowWidth
            windowHeight: root.windowHeight

            onViewHistoryClicked: {
                console.log("[OVERVIEW] Navigate to History");
                root.currentIndex = 2;
                root.navigateToScreen(2);
            }

            onViewLogsClicked: {
                console.log("[OVERVIEW] Navigate to Logs");
                root.currentIndex = 3;
                root.navigateToScreen(3);
            }

            onExportDataClicked: {
                console.log("[OVERVIEW] Navigate to Export");
                root.currentIndex = 6;
                root.navigateToScreen(6);
            }
        }

        // =====================================================================
        // SCREEN 1: SENSORS
        // =====================================================================
        SensorsScreen {
            windowWidth: root.windowWidth
            windowHeight: root.windowHeight

            onRunDiagnostics: {
                console.log("[SENSORS] Running full diagnostics...");
            }

            onCalibrateAll: {
                console.log("[SENSORS] Navigate to Calibrate");
                root.currentIndex = 5;
                root.navigateToScreen(5);
            }

            onExportSensorLogs: {
                console.log("[SENSORS] Navigate to Export");
                root.currentIndex = 6;
                root.navigateToScreen(6);
            }

            onNavigateToCalibrate: {
                console.log("[SENSORS] Navigate to Calibrate");
                root.currentIndex = 5;
                root.navigateToScreen(5);
            }
        }

        // =====================================================================
        // SCREEN 2: HISTORY
        // =====================================================================
        HistoryScreen {
            windowWidth: root.windowWidth
            windowHeight: root.windowHeight

            onGenerateChart: {
                console.log("[HISTORY] Generate chart requested");
            }

            onExportAllData: {
                console.log("[HISTORY] Navigate to Export");
                root.currentIndex = 6;
                root.navigateToScreen(6);
            }

            onCleanupOldData: {
                console.log("[HISTORY] Cleanup old data requested");
            }
        }

        // =====================================================================
        // SCREEN 3: LOGS
        // =====================================================================
        LogsScreen {
            windowWidth: root.windowWidth
            windowHeight: root.windowHeight

            onRefreshLogs: {
                console.log("[LOGS] Refresh logs requested");
            }

            onExportLogs: {
                console.log("[LOGS] Navigate to Export");
                root.currentIndex = 6;
                root.navigateToScreen(6);
            }

            onClearLogs: {
                console.log("[LOGS] Clear logs requested");
            }
        }

        // =====================================================================
        // SCREEN 4: SYSTEM
        // =====================================================================
        SystemScreen {
            windowWidth: root.windowWidth
            windowHeight: root.windowHeight

            onSaveConfiguration: {
                console.log("[SYSTEM] Save configuration requested");
            }

            onResetToDefaults: {
                console.log("[SYSTEM] Reset to defaults requested");
            }

            onModeChanged: function(newMode) {
                console.log("[SYSTEM] Mode changed to: " + newMode);
            }
        }

        // =====================================================================
        // SCREEN 5: CALIBRATE
        // =====================================================================
        CalibrateScreen {
            windowWidth: root.windowWidth
            windowHeight: root.windowHeight

            onStartCalibration: {
                console.log("[CALIBRATE] Calibration started");
            }

            onCancelCalibration: {
                console.log("[CALIBRATE] Calibration cancelled");
            }

            onCalibrationComplete: {
                console.log("[CALIBRATE] Calibration complete");
            }
        }

        // =====================================================================
        // SCREEN 6: EXPORT
        // =====================================================================
        ExportScreen {
            windowWidth: root.windowWidth
            windowHeight: root.windowHeight

            onExportAsCsv: {
                console.log("[EXPORT] CSV export requested");
            }

            onExportAsJson: {
                console.log("[EXPORT] JSON export requested");
            }

            onExportDatabase: {
                console.log("[EXPORT] Database export requested");
            }

            onExportLogs: {
                console.log("[EXPORT] Logs export requested");
            }

            onDetectUsb: {
                console.log("[EXPORT] USB detection requested");
            }

            onBackupToUsb: {
                console.log("[EXPORT] USB backup requested");
            }
        }

        // =====================================================================
        // SCREEN 7: TERMINAL
        // =====================================================================
        TerminalScreen {
            windowWidth: root.windowWidth
            windowHeight: root.windowHeight

            onCommandExecuted: function(command) {
                console.log("[TERMINAL] Command executed: " + command);
            }
        }
    }
}

// ╔═══════════════════════════════════════════════════════════════════════════╗
// ║ END OF FILE: ScreenContainer.qml                                           ║
// ╚═══════════════════════════════════════════════════════════════════════════╝