import QtQuick
import QtQuick.Controls
import QtQuick.Layouts

Rectangle {
    id: root

    // =========================================================================
    // PUBLIC PROPERTIES
    // =========================================================================
    property string header: "HEADER"
    property string value: "--"
    property string details: ""
    property string status: "normal"  // normal, healthy, warning, critical, offline
    property int windowWidth: 1280

    // Icon (emoji or single character)
    property string icon: ""

    // Optional unit suffix for value
    property string unit: ""

    // Click handling
    property bool clickable: false
    signal clicked()

    // =========================================================================
    // INTERNAL THEME
    // =========================================================================
    readonly property color bgColor: "#1A1A1A"
    readonly property color borderNormal: "#333333"
    readonly property color borderHealthy: "#00FF00"
    readonly property color borderWarning: "#FFAA00"
    readonly property color borderCritical: "#FF0000"
    readonly property color borderOffline: "#666666"
    readonly property color textPrimary: "#00FF00"
    readonly property color textSecondary: "#888888"
    readonly property color textMuted: "#666666"
    readonly property string fontMono: "Monospace"

    // =========================================================================
    // COMPUTED PROPERTIES
    // =========================================================================
    readonly property color borderColor: {
        var s = status.toLowerCase();
        if (s === "healthy" || s === "ok" || s === "good" || s === "success") return borderHealthy;
        if (s === "warning" || s === "warn") return borderWarning;
        if (s === "critical" || s === "error" || s === "danger") return borderCritical;
        if (s === "offline" || s === "disabled") return borderOffline;
        return borderNormal;
    }

    readonly property int headerFontSize: {
        if (windowWidth <= 800) return 12;
        if (windowWidth <= 1280) return 14;
        if (windowWidth <= 1920) return 16;
        return 18;
    }

    readonly property int valueFontSize: {
        if (windowWidth <= 800) return 24;
        if (windowWidth <= 1280) return 32;
        if (windowWidth <= 1920) return 36;
        return 42;
    }

    readonly property int detailsFontSize: {
        if (windowWidth <= 800) return 11;
        if (windowWidth <= 1280) return 13;
        if (windowWidth <= 1920) return 14;
        return 15;
    }

    readonly property int cardPadding: {
        if (windowWidth <= 800) return 15;
        if (windowWidth <= 1280) return 20;
        return 25;
    }

    // =========================================================================
    // APPEARANCE
    // =========================================================================
    implicitWidth: 300
    implicitHeight: contentColumn.implicitHeight + (cardPadding * 2)

    color: bgColor
    border.width: 2
    border.color: borderColor
    radius: 8

    Behavior on border.color {
        ColorAnimation { duration: 200 }
    }

    // Hover effect for clickable cards
    Rectangle {
        anchors.fill: parent
        radius: parent.radius
        color: "#FFFFFF"
        opacity: clickable && mouseArea.containsMouse ? 0.05 : 0

        Behavior on opacity {
            NumberAnimation { duration: 150 }
        }
    }

    // =========================================================================
    // CONTENT
    // =========================================================================
    ColumnLayout {
        id: contentColumn
        anchors.fill: parent
        anchors.margins: root.cardPadding
        spacing: 10

        // Header Row
        RowLayout {
            Layout.fillWidth: true
            spacing: 8

            Text {
                visible: root.icon !== ""
                font.pixelSize: root.headerFontSize + 2
                text: root.icon
            }

            Text {
                Layout.fillWidth: true
                font.family: root.fontMono
                font.pixelSize: root.headerFontSize
                font.bold: false
                color: root.textSecondary
                text: root.header.toUpperCase()
                elide: Text.ElideRight
            }
        }

        // Value Row
        RowLayout {
            Layout.fillWidth: true
            spacing: 4

            Text {
                font.family: root.fontMono
                font.pixelSize: root.valueFontSize
                font.bold: true
                color: root.textPrimary
                text: root.value
            }

            Text {
                visible: root.unit !== ""
                font.family: root.fontMono
                font.pixelSize: root.valueFontSize * 0.5
                font.bold: false
                color: root.textSecondary
                text: root.unit
                Layout.alignment: Qt.AlignBottom
                Layout.bottomMargin: root.valueFontSize * 0.15
            }
        }

        // Details Text
        Text {
            Layout.fillWidth: true
            visible: root.details !== ""
            font.family: root.fontMono
            font.pixelSize: root.detailsFontSize
            color: root.textMuted
            text: root.details
            wrapMode: Text.WordWrap
            lineHeight: 1.4
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
