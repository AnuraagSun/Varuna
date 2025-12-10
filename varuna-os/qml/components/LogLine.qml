import QtQuick
import QtQuick.Controls
import QtQuick.Layouts

Rectangle {
    id: root

    // =========================================================================
    // PUBLIC PROPERTIES
    // =========================================================================
    property string timestamp: ""
    property string level: "info"  // info, warn, error, debug
    property string message: ""
    property int windowWidth: 1280

    // =========================================================================
    // INTERNAL THEME
    // =========================================================================
    readonly property color bgColor: "transparent"
    readonly property color infoColor: "#00FF00"
    readonly property color warnColor: "#FFAA00"
    readonly property color errorColor: "#FF0000"
    readonly property color debugColor: "#888888"
    readonly property color timestampColor: "#666666"
    readonly property string fontMono: "Monospace"

    // =========================================================================
    // COMPUTED PROPERTIES
    // =========================================================================
    readonly property color levelColor: {
        var l = level.toLowerCase();
        if (l === "info" || l === "ok" || l === "success") return infoColor;
        if (l === "warn" || l === "warning") return warnColor;
        if (l === "error" || l === "err" || l === "critical" || l === "fatal") return errorColor;
        if (l === "debug" || l === "trace") return debugColor;
        return infoColor;
    }

    readonly property int fontSize: {
        if (windowWidth <= 800) return 11;
        if (windowWidth <= 1280) return 13;
        if (windowWidth <= 1920) return 14;
        return 15;
    }

    readonly property int lineHeight: {
        if (windowWidth <= 800) return 28;
        if (windowWidth <= 1280) return 32;
        return 38;
    }

    // =========================================================================
    // APPEARANCE
    // =========================================================================
    implicitHeight: Math.max(lineHeight, messageText.implicitHeight + 12)
    color: bgColor

    // Left accent border
    Rectangle {
        anchors.left: parent.left
        anchors.top: parent.top
        anchors.bottom: parent.bottom
        width: 3
        color: root.levelColor
    }

    // =========================================================================
    // CONTENT
    // =========================================================================
    RowLayout {
        anchors.fill: parent
        anchors.leftMargin: 12
        anchors.rightMargin: 8
        spacing: 10

        // Timestamp
        Text {
            visible: root.timestamp !== ""
            Layout.alignment: Qt.AlignTop
            Layout.topMargin: 6
            font.family: root.fontMono
            font.pixelSize: root.fontSize
            color: root.timestampColor
            text: "[" + root.timestamp + "]"
        }

        // Level tag
        Text {
            Layout.alignment: Qt.AlignTop
            Layout.topMargin: 6
            font.family: root.fontMono
            font.pixelSize: root.fontSize
            font.bold: true
            color: root.levelColor
            text: "[" + root.level.toUpperCase() + "]"
        }

        // Message
        Text {
            id: messageText
            Layout.fillWidth: true
            Layout.alignment: Qt.AlignTop
            Layout.topMargin: 6
            font.family: root.fontMono
            font.pixelSize: root.fontSize
            color: root.levelColor
            text: root.message
            wrapMode: Text.WordWrap
        }
    }
}
