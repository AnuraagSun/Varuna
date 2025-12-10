// ╔═══════════════════════════════════════════════════════════════════════════╗
// ║ FILE: Theme.qml                                                            ║
// ║ LOCATION: varuna-os/qml/Theme.qml                                          ║
// ║ PURPOSE: Singleton containing all theme constants for VARUNA OS            ║
// ║ FIXED: Proper singleton declaration for Qt 6.8/6.9                        ║
// ╚═══════════════════════════════════════════════════════════════════════════╝

pragma Singleton
import QtQuick 2.15

QtObject {
    id: theme

    // =========================================================================
    // APPLICATION INFO
    // =========================================================================
    readonly property string appName: "VARUNA"
    readonly property string appVersion: "1.0.3"
    readonly property string appBuildDate: "20240115"
    readonly property string deviceId: "CWC-RJ-001"
    readonly property string siteName: "Chambal River Station 1"

    // =========================================================================
    // RESPONSIVE BREAKPOINTS
    // =========================================================================
    readonly property int breakpointSmall: 800
    readonly property int breakpointMedium: 1280
    readonly property int breakpointLarge: 1920
    readonly property int breakpointXLarge: 2560

    // =========================================================================
    // PRIMARY COLORS
    // =========================================================================
    readonly property color colorBackground: "#000000"
    readonly property color colorBackgroundLight: "#0A0A0A"
    readonly property color colorBackgroundCard: "#1A1A1A"
    readonly property color colorBackgroundInput: "#1A1A1A"
    readonly property color colorBackgroundHover: "#252525"
    readonly property color colorBackgroundWarning: "#3A1A1A"
    readonly property color colorBackgroundSelected: "#0A2A0A"

    // =========================================================================
    // TEXT COLORS
    // =========================================================================
    readonly property color colorTextPrimary: "#00FF00"
    readonly property color colorTextSecondary: "#888888"
    readonly property color colorTextMuted: "#666666"
    readonly property color colorTextDisabled: "#444444"
    readonly property color colorTextInverse: "#000000"

    // =========================================================================
    // STATUS COLORS
    // =========================================================================
    readonly property color colorSuccess: "#00FF00"
    readonly property color colorWarning: "#FFAA00"
    readonly property color colorError: "#FF0000"
    readonly property color colorInfo: "#00AAFF"
    readonly property color colorOffline: "#666666"

    // =========================================================================
    // BORDER COLORS
    // =========================================================================
    readonly property color colorBorder: "#333333"
    readonly property color colorBorderActive: "#00FF00"
    readonly property color colorBorderWarning: "#FFAA00"
    readonly property color colorBorderError: "#FF0000"

    // =========================================================================
    // BADGE COLORS
    // =========================================================================
    readonly property color badgeGoodBackground: "#00FF00"
    readonly property color badgeGoodText: "#000000"
    readonly property color badgeWarnBackground: "#FFAA00"
    readonly property color badgeWarnText: "#000000"
    readonly property color badgeErrorBackground: "#FF0000"
    readonly property color badgeErrorText: "#FFFFFF"
    readonly property color badgeOfflineBackground: "#666666"
    readonly property color badgeOfflineText: "#FFFFFF"

    // =========================================================================
    // FONT SETTINGS
    // =========================================================================
    readonly property string fontFamily: "Monospace"
    readonly property int fontSizeXSmall: 10
    readonly property int fontSizeSmall: 12
    readonly property int fontSizeNormal: 14
    readonly property int fontSizeMedium: 16
    readonly property int fontSizeLarge: 20
    readonly property int fontSizeXLarge: 24
    readonly property int fontSizeXXLarge: 36
    readonly property int fontSizeTitle: 20

    // =========================================================================
    // SPACING & SIZING
    // =========================================================================
    readonly property int spacingXSmall: 5
    readonly property int spacingSmall: 10
    readonly property int spacingMedium: 15
    readonly property int spacingLarge: 20
    readonly property int spacingXLarge: 30

    readonly property int paddingSmall: 10
    readonly property int paddingMedium: 15
    readonly property int paddingLarge: 20
    readonly property int paddingXLarge: 30

    // =========================================================================
    // BORDER & RADIUS
    // =========================================================================
    readonly property int borderWidth: 1
    readonly property int borderWidthThick: 2
    readonly property int borderWidthHeader: 3
    readonly property int borderRadius: 5
    readonly property int borderRadiusLarge: 8

    // =========================================================================
    // COMPONENT SIZES
    // =========================================================================
    readonly property int headerHeight: 80
    readonly property int navHeight: 50
    readonly property int buttonHeight: 50
    readonly property int buttonHeightSmall: 40
    readonly property int inputHeight: 45
    readonly property int cardMinWidth: 300
    readonly property int healthItemHeight: 50
    readonly property int logLineHeight: 35
    readonly property int tableRowHeight: 45
    readonly property int terminalHeight: 600
    readonly property int chartHeight: 400
    readonly property int logViewerHeight: 500
    readonly property int progressBarHeight: 30

    // =========================================================================
    // ANIMATION DURATIONS
    // =========================================================================
    readonly property int animationFast: 150
    readonly property int animationNormal: 250
    readonly property int animationSlow: 500
    readonly property int bootLineDelay: 80
    readonly property int bootScreenDuration: 3000
    readonly property int bootLineFadeInDuration: 150
    readonly property int bootCursorBlinkInterval: 500
    readonly property int bootCompletionDelay: 1500
    readonly property int bootFadeOutDuration: 400

    // =========================================================================
    // SCROLLBAR SETTINGS
    // =========================================================================
    readonly property int scrollBarWidth: 12
    readonly property color scrollBarBackground: "#0A0A0A"
    readonly property color scrollBarHandle: "#00FF00"
    readonly property color scrollBarHandleHover: "#00CC00"

    // =========================================================================
    // NAVIGATION ITEMS
    // =========================================================================
    readonly property var navigationItems: [
        { "id": "overview", "label": "OVERVIEW", "icon": "overview.png" },
        { "id": "sensors", "label": "SENSORS", "icon": "sensors.png" },
        { "id": "history", "label": "HISTORY", "icon": "history.png" },
        { "id": "logs", "label": "LOGS", "icon": "logs.png" },
        { "id": "system", "label": "SYSTEM", "icon": "system.png" },
        { "id": "calibrate", "label": "CALIBRATE", "icon": "calibrate.png" },
        { "id": "export", "label": "EXPORT", "icon": "export.png" },
        { "id": "terminal", "label": "TERMINAL", "icon": "terminal.png" }
    ]

    // =========================================================================
    // OPERATING MODES
    // =========================================================================
    readonly property var operatingModes: [
        { "id": "normal", "label": "NORMAL" },
        { "id": "flood", "label": "FLOOD" },
        { "id": "lowpower", "label": "LOW POWER" },
        { "id": "maintenance", "label": "MAINTENANCE" }
    ]

    // =========================================================================
    // SYSTEM HEALTH ITEMS
    // =========================================================================
    readonly property var healthItems: [
        { "id": "pressure", "label": "Pressure Sensor", "key": "tension" },
        { "id": "stepper", "label": "Stepper Motor", "key": "motor" },
        { "id": "esp32", "label": "ESP32 Link", "key": "esp32" },
        { "id": "gps", "label": "GPS (NEO-6M)", "key": "gps" },
        { "id": "gsm", "label": "GSM (SIM900A)", "key": "gsm" },
        { "id": "battery", "label": "Battery (Dual)", "key": "battery" },
        { "id": "storage", "label": "Storage", "key": "storage" },
        { "id": "power", "label": "Solar/Wind", "key": "power" },
        { "id": "transmission", "label": "Data Transmission", "key": "transmission" }
    ]

    // =========================================================================
    // HELPER FUNCTIONS
    // =========================================================================

    function scaledFontSize(baseSize, windowWidth) {
        if (windowWidth <= breakpointSmall) {
            return Math.max(10, baseSize * 0.8);
        } else if (windowWidth <= breakpointMedium) {
            return baseSize;
        } else if (windowWidth <= breakpointLarge) {
            return Math.round(baseSize * 1.15);
        } else {
            return Math.round(baseSize * 1.3);
        }
    }

    function responsivePadding(windowWidth) {
        if (windowWidth <= breakpointSmall) {
            return 15;
        } else if (windowWidth <= breakpointMedium) {
            return 20;
        } else if (windowWidth <= breakpointLarge) {
            return 30;
        } else {
            return 40;
        }
    }

    function responsiveSpacing(windowWidth) {
        if (windowWidth <= breakpointSmall) {
            return 10;
        } else if (windowWidth <= breakpointMedium) {
            return 15;
        } else if (windowWidth <= breakpointLarge) {
            return 20;
        } else {
            return 25;
        }
    }

    function responsiveHeaderHeight(windowHeight) {
        if (windowHeight <= 600) {
            return 60;
        } else if (windowHeight <= 800) {
            return 70;
        } else if (windowHeight <= 1080) {
            return 85;
        } else {
            return 100;
        }
    }

    function responsiveNavHeight(windowHeight) {
        if (windowHeight <= 600) {
            return 40;
        } else if (windowHeight <= 800) {
            return 45;
        } else if (windowHeight <= 1080) {
            return 55;
        } else {
            return 65;
        }
    }

    function responsiveCardMinWidth(windowWidth) {
        if (windowWidth <= breakpointSmall) {
            return windowWidth - 40;
        } else if (windowWidth <= breakpointMedium) {
            return 280;
        } else if (windowWidth <= breakpointLarge) {
            return 320;
        } else {
            return 380;
        }
    }

    function getStatusColor(status) {
        var s = status.toString().toLowerCase();
        if (s === "ok" || s === "good" || s === "success" || s === "connected" || s === "locked" || s === "optimal") {
            return colorSuccess;
        } else if (s === "warning" || s === "warn" || s === "low" || s === "high") {
            return colorWarning;
        } else if (s === "error" || s === "fail" || s === "critical" || s === "fault") {
            return colorError;
        } else if (s === "offline" || s === "unknown" || s === "disabled") {
            return colorOffline;
        }
        return colorTextSecondary;
    }

    function getCardBorderColor(status) {
        var s = status.toString().toLowerCase();
        if (s === "healthy" || s === "ok" || s === "good") {
            return colorBorderActive;
        } else if (s === "warning" || s === "warn") {
            return colorBorderWarning;
        } else if (s === "critical" || s === "error") {
            return colorBorderError;
        }
        return colorBorder;
    }

    function formatWaterLevel(value) {
        if (value === null || value === undefined) return "--";
        return value.toFixed(1) + " cm";
    }

    function formatPercentage(value) {
        if (value === null || value === undefined) return "--";
        return Math.round(value) + "%";
    }

    function isSmallScreen(windowWidth) {
        return windowWidth <= breakpointSmall;
    }

    function isLargeScreen(windowWidth) {
        return windowWidth >= breakpointLarge;
    }
}

// ╔═══════════════════════════════════════════════════════════════════════════╗
// ║ END OF FILE: Theme.qml                                                     ║
// ╚═══════════════════════════════════════════════════════════════════════════╝
