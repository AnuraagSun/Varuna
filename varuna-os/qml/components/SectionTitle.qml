import QtQuick
import QtQuick.Controls
import QtQuick.Layouts

Item {
    id: root

    // =========================================================================
    // PUBLIC PROPERTIES
    // =========================================================================
    property string text: "SECTION TITLE"
    property string icon: ""  // Optional emoji/icon
    property int windowWidth: 1280
    property bool showLine: true
    property color accentColor: "#00FF00"

    // =========================================================================
    // INTERNAL THEME
    // =========================================================================
    readonly property color textColor: "#00FF00"
    readonly property color lineColor: accentColor
    readonly property string fontMono: "Monospace"

    // =========================================================================
    // COMPUTED PROPERTIES
    // =========================================================================
    readonly property int fontSize: {
        if (windowWidth <= 800) return 16;
        if (windowWidth <= 1280) return 18;
        if (windowWidth <= 1920) return 20;
        return 24;
    }

    readonly property int bottomMargin: {
        if (windowWidth <= 800) return 12;
        if (windowWidth <= 1280) return 15;
        return 20;
    }

    // =========================================================================
    // APPEARANCE
    // =========================================================================
    implicitHeight: titleRow.implicitHeight + (showLine ? lineRect.height + 8 : 0) + bottomMargin

    // =========================================================================
    // CONTENT
    // =========================================================================
    Column {
        anchors.left: parent.left
        anchors.right: parent.right
        spacing: 8

        // Title Row
        Row {
            id: titleRow
            spacing: 10

            Text {
                visible: root.icon !== ""
                font.pixelSize: root.fontSize
                text: root.icon
            }

            Text {
                font.family: root.fontMono
                font.pixelSize: root.fontSize
                font.bold: true
                color: root.textColor
                text: root.text
            }
        }

        // Underline
        Rectangle {
            id: lineRect
            visible: root.showLine
            width: parent.width
            height: 2
            color: root.lineColor
        }
    }
}
