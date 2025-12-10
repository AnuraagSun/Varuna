import QtQuick
import QtQuick.Controls
import QtQuick.Layouts

Rectangle {
    id: root

    // =========================================================================
    // PUBLIC PROPERTIES
    // =========================================================================
    property string label: "Component"
    property string status: "OK"
    property string statusType: "ok"  // ok, warning, error, offline
    property int windowWidth: 1280

    // Optional icon
    property string icon: ""

    // Click handling
    property bool clickable: false
    signal clicked()

    // =========================================================================
    // INTERNAL THEME
    // =========================================================================
    readonly property color bgColor: "#1A1A1A"
    readonly property color borderOk: "#00FF00"
    readonly property color borderWarning: "#FFAA00"
    readonly property color borderError: "#FF0000"
    readonly property color borderOffline: "#666666"
    readonly property color textPrimary: "#00FF00"
    readonly property color textSecondary: "#888888"
    readonly property string fontMono: "Monospace"

    // =========================================================================
    // COMPUTED PROPERTIES
    // =========================================================================
    readonly property color accentColor: {
        var s = statusType.toLowerCase();
        if (s === "ok" || s === "good" || s === "success" || s === "connected" || s === "locked") return borderOk;
        if (s === "warning" || s === "warn" || s === "low" || s === "high") return borderWarning;
        if (s === "error" || s === "fail" || s === "critical" || s === "fault") return borderError;
        return borderOffline;
    }

    readonly property color statusTextColor: accentColor

    readonly property int fontSize: {
        if (windowWidth <= 800) return 12;
        if (windowWidth <= 1280) return 14;
        if (windowWidth <= 1920) return 15;
        return 16;
    }

    readonly property int statusFontSize: {
        if (windowWidth <= 800) return 14;
        if (windowWidth <= 1280) return 16;
        if (windowWidth <= 1920) return 18;
        return 20;
    }

    readonly property int itemHeight: {
        if (windowWidth <= 800) return 45;
        if (windowWidth <= 1280) return 50;
        return 55;
    }

    // =========================================================================
    // APPEARANCE
    // =========================================================================
    implicitHeight: itemHeight
    color: bgColor

    // Left accent border
    Rectangle {
        id: accentBorder
        anchors.left: parent.left
        anchors.top: parent.top
        anchors.bottom: parent.bottom
        width: 4
        color: root.accentColor

        Behavior on color {
            ColorAnimation { duration: 200 }
        }
    }

    // Hover effect
    Rectangle {
        anchors.fill: parent
        color: "#FFFFFF"
        opacity: clickable && mouseArea.containsMouse ? 0.05 : 0

        Behavior on opacity {
            NumberAnimation { duration: 150 }
        }
    }

    // =========================================================================
    // CONTENT
    // =========================================================================
    RowLayout {
        anchors.fill: parent
        anchors.leftMargin: 15
        anchors.rightMargin: 15
        spacing: 10

        // Icon (if provided)
        Text {
            visible: root.icon !== ""
            font.pixelSize: root.fontSize + 2
            text: root.icon
        }

        // Label
        Text {
            Layout.fillWidth: true
            font.family: root.fontMono
            font.pixelSize: root.fontSize
            color: root.textSecondary
            text: root.label
            elide: Text.ElideRight
        }

        // Status
        Text {
            font.family: root.fontMono
            font.pixelSize: root.statusFontSize
            font.bold: true
            color: root.statusTextColor
            text: root.status
        }
    }

    // =========================================================================
    // MOUSE INTERACTION
    // =========================================================================
    MouseArea {
        id: mouseArea
        anchors.fill: parent
        hoverEnabled: root.clickable
        cursorShape: root.clickable ? Qt.PointingHandCursor : Qt.ArrowCursor

        onClicked: {
            if (root.clickable) {
                root.clicked();
            }
        }
    }
}
