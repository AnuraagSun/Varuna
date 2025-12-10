import QtQuick
import QtQuick.Controls
import QtQuick.Layouts

Rectangle {
    id: root

    property string deviceId: "CWC-RJ-001"
    property string siteName: "Chambal River Station 1"
    property string firmwareVersion: "1.0.3"
    property string mode: "normal"
    property string modeSubtitle: ""
    property bool isConnected: true
    property int windowWidth: 1280
    property int windowHeight: 800

    readonly property color bgColor: "#1A1A1A"
    readonly property color borderColor: "#00FF00"
    readonly property color textPrimary: "#00FF00"
    readonly property color textMuted: "#666666"
    readonly property string fontMono: "Monospace"

    readonly property int headerHeight: {
        if (windowHeight <= 600) return 60;
        if (windowHeight <= 800) return 70;
        if (windowHeight <= 1080) return 85;
        return 100;
    }

    readonly property int horizontalPadding: {
        if (windowWidth <= 800) return 15;
        if (windowWidth <= 1280) return 20;
        if (windowWidth <= 1920) return 30;
        return 40;
    }

    readonly property int titleFontSize: {
        if (windowWidth <= 800) return 18;
        if (windowWidth <= 1280) return 22;
        if (windowWidth <= 1920) return 26;
        return 30;
    }

    readonly property int subtitleFontSize: {
        if (windowWidth <= 800) return 11;
        if (windowWidth <= 1280) return 13;
        if (windowWidth <= 1920) return 14;
        return 16;
    }

    readonly property int badgeFontSize: {
        if (windowWidth <= 800) return 11;
        if (windowWidth <= 1280) return 13;
        if (windowWidth <= 1920) return 14;
        return 16;
    }

    signal statusClicked()
    signal titleClicked()

    implicitHeight: headerHeight
    color: bgColor
    border.width: 3
    border.color: borderColor

    RowLayout {
        anchors.fill: parent
        anchors.leftMargin: root.horizontalPadding
        anchors.rightMargin: root.horizontalPadding
        anchors.topMargin: 8
        anchors.bottomMargin: 8
        spacing: 20

        ColumnLayout {
            Layout.fillWidth: true
            Layout.fillHeight: true
            Layout.alignment: Qt.AlignVCenter
            spacing: 4

            RowLayout {
                Layout.fillWidth: true
                spacing: 10

                Text {
                    font.pixelSize: root.titleFontSize
                    text: "🌊"
                }

                Text {
                    font.family: root.fontMono
                    font.pixelSize: root.titleFontSize
                    font.bold: true
                    color: root.textPrimary
                    text: "VARUNA " + root.deviceId

                    MouseArea {
                        anchors.fill: parent
                        cursorShape: Qt.PointingHandCursor
                        onClicked: root.titleClicked()
                    }
                }

                Rectangle {
                    width: 12
                    height: 12
                    radius: 6
                    color: root.isConnected ? "#00FF00" : "#FF0000"
                    visible: windowWidth > 600

                    SequentialAnimation on opacity {
                        running: root.isConnected
                        loops: Animation.Infinite
                        NumberAnimation { from: 1; to: 0.4; duration: 1000 }
                        NumberAnimation { from: 0.4; to: 1; duration: 1000 }
                    }
                }
            }

            Text {
                Layout.fillWidth: true
                font.family: root.fontMono
                font.pixelSize: root.subtitleFontSize
                color: root.textMuted
                text: root.siteName + " | Firmware v" + root.firmwareVersion
                elide: Text.ElideRight
            }
        }

        StatusBadge {
            Layout.alignment: Qt.AlignVCenter
            status: root.mode
            fontSize: root.badgeFontSize
            subtitle: root.modeSubtitle

            MouseArea {
                anchors.fill: parent
                cursorShape: Qt.PointingHandCursor
                onClicked: root.statusClicked()
            }
        }
    }

    Rectangle {
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.bottom: parent.bottom
        height: 3
        color: root.borderColor
    }
}