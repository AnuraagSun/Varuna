import QtQuick
import QtQuick.Controls
import QtQuick.Layouts

Rectangle {
    id: root

    // =========================================================================
    // PUBLIC PROPERTIES
    // =========================================================================
    property string message: "Warning message"
    property string type: "warning"  // warning, error, info, success
    property bool dismissible: false
    property bool showing: true  // Use 'showing' instead of 'visible'
    property int windowWidth: 1280

    // =========================================================================
    // SIGNALS
    // =========================================================================
    signal dismissed()

    // =========================================================================
    // INTERNAL THEME
    // =========================================================================
    readonly property color warningBg: "#3A2A0A"
    readonly property color warningBorder: "#FFAA00"
    readonly property color warningText: "#FFAA00"

    readonly property color errorBg: "#3A1A1A"
    readonly property color errorBorder: "#FF0000"
    readonly property color errorText: "#FF0000"

    readonly property color infoBg: "#0A2A3A"
    readonly property color infoBorder: "#00AAFF"
    readonly property color infoText: "#00AAFF"

    readonly property color successBg: "#0A3A1A"
    readonly property color successBorder: "#00FF00"
    readonly property color successText: "#00FF00"

    readonly property string fontMono: "Monospace"

    // =========================================================================
    // COMPUTED PROPERTIES
    // =========================================================================
    readonly property color bgColor: {
        var t = type.toLowerCase();
        if (t === "error" || t === "danger" || t === "critical") return errorBg;
        if (t === "info") return infoBg;
        if (t === "success" || t === "ok") return successBg;
        return warningBg;
    }

    readonly property color borderClr: {
        var t = type.toLowerCase();
        if (t === "error" || t === "danger" || t === "critical") return errorBorder;
        if (t === "info") return infoBorder;
        if (t === "success" || t === "ok") return successBorder;
        return warningBorder;
    }

    readonly property color textClr: {
        var t = type.toLowerCase();
        if (t === "error" || t === "danger" || t === "critical") return errorText;
        if (t === "info") return infoText;
        if (t === "success" || t === "ok") return successText;
        return warningText;
    }

    readonly property string iconText: {
        var t = type.toLowerCase();
        if (t === "error" || t === "danger" || t === "critical") return "⛔";
        if (t === "info") return "ℹ️";
        if (t === "success" || t === "ok") return "✓";
        return "⚠️";
    }

    readonly property int fontSize: {
        if (windowWidth <= 800) return 12;
        if (windowWidth <= 1280) return 14;
        if (windowWidth <= 1920) return 15;
        return 16;
    }

    readonly property int padding: {
        if (windowWidth <= 800) return 12;
        if (windowWidth <= 1280) return 15;
        return 20;
    }

    // =========================================================================
    // APPEARANCE
    // =========================================================================
    visible: showing
    implicitHeight: showing ? contentRow.implicitHeight + (padding * 2) : 0
    opacity: showing ? 1 : 0

    color: bgColor
    border.width: 2
    border.color: borderClr
    radius: 5

    Behavior on opacity {
        NumberAnimation { duration: 200 }
    }

    Behavior on implicitHeight {
        NumberAnimation { duration: 200 }
    }

    // =========================================================================
    // CONTENT
    // =========================================================================
    RowLayout {
        id: contentRow
        anchors.fill: parent
        anchors.margins: root.padding
        spacing: 12

        Text {
            font.pixelSize: root.fontSize + 4
            text: root.iconText
        }

        Text {
            Layout.fillWidth: true
            font.family: root.fontMono
            font.pixelSize: root.fontSize
            font.bold: true
            color: root.textClr
            text: root.message
            wrapMode: Text.WordWrap
        }

        Rectangle {
            visible: root.dismissible
            width: 28
            height: 28
            radius: 14
            color: "transparent"
            border.width: 1
            border.color: root.borderClr

            Text {
                anchors.centerIn: parent
                font.pixelSize: 14
                font.bold: true
                color: root.textClr
                text: "✕"
            }

            MouseArea {
                anchors.fill: parent
                cursorShape: Qt.PointingHandCursor
                onClicked: {
                    root.showing = false;
                    root.dismissed();
                }
            }
        }
    }
}
