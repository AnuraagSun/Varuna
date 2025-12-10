import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import "../components"

Rectangle {
    id: root

    property int windowWidth: 1280
    property int windowHeight: 800

    property var logEntries: [
        {"timestamp": "15:45:12", "level": "info", "message": "Device entering maintenance mode"},
        {"timestamp": "15:42:34", "level": "info", "message": "Data transmission successful [200 OK]"},
        {"timestamp": "15:42:00", "level": "info", "message": "Hourly reading: 87.6cm | Battery: 78%"},
        {"timestamp": "13:45:33", "level": "warn", "message": "Water rise: +5.2cm in 15 minutes"},
        {"timestamp": "10:15:22", "level": "warn", "message": "GSM signal weak: -82 dBm"},
        {"timestamp": "06:00:45", "level": "info", "message": "Calibration completed"},
        {"timestamp": "05:58:42", "level": "info", "message": "System boot completed"}
    ]

    property string filterLevel: "all"

    signal refreshLogs()
    signal exportLogs()
    signal clearLogs()

    color: "#000000"

    ColumnLayout {
        anchors.fill: parent
        anchors.margins: 20
        spacing: 15

        SectionTitle {
            Layout.fillWidth: true
            text: "SYSTEM EVENT LOG"
            icon: "📋"
            windowWidth: root.windowWidth
        }

        RowLayout {
            Layout.fillWidth: true
            spacing: 10

            Text {
                font.family: "Monospace"
                font.pixelSize: 14
                color: "#888888"
                text: "Filter:"
            }

            Repeater {
                model: [
                    {"id": "all", "label": "ALL", "color": "#888888"},
                    {"id": "info", "label": "INFO", "color": "#00FF00"},
                    {"id": "warn", "label": "WARN", "color": "#FFAA00"}
                ]

                Rectangle {
                    width: 60
                    height: 28
                    radius: 4
                    color: root.filterLevel === modelData.id ? modelData.color : "transparent"
                    border.width: 1
                    border.color: modelData.color

                    Text {
                        anchors.centerIn: parent
                        font.family: "Monospace"
                        font.pixelSize: 11
                        font.bold: true
                        color: root.filterLevel === modelData.id ? "#000000" : modelData.color
                        text: modelData.label
                    }

                    MouseArea {
                        anchors.fill: parent
                        cursorShape: Qt.PointingHandCursor
                        onClicked: root.filterLevel = modelData.id
                    }
                }
            }

            Item { Layout.fillWidth: true }
        }

        Rectangle {
            Layout.fillWidth: true
            Layout.fillHeight: true
            color: "#000000"
            border.width: 2
            border.color: "#00FF00"
            radius: 5

            Flickable {
                anchors.fill: parent
                anchors.margins: 15
                contentWidth: width
                contentHeight: logCol.height
                clip: true
                boundsBehavior: Flickable.StopAtBounds
                ScrollBar.vertical: ScrollBar { policy: ScrollBar.AlwaysOn; width: 10 }

                Column {
                    id: logCol
                    width: parent.width - 15
                    spacing: 8

                    Repeater {
                        model: {
                            if (root.filterLevel === "all") return root.logEntries;
                            var result = [];
                            for (var i = 0; i < root.logEntries.length; i++) {
                                if (root.logEntries[i].level === root.filterLevel) {
                                    result.push(root.logEntries[i]);
                                }
                            }
                            return result;
                        }

                        LogLine {
                            width: parent.width
                            timestamp: modelData.timestamp
                            level: modelData.level
                            message: modelData.message
                            windowWidth: root.windowWidth
                        }
                    }
                }
            }
        }

        RowLayout {
            Layout.fillWidth: true
            spacing: 15

            CustomButton {
                text: "Refresh"
                icon: "🔄"
                variant: "secondary"
                windowWidth: root.windowWidth
                onClicked: root.refreshLogs()
            }

            CustomButton {
                text: "Export"
                icon: "💾"
                variant: "secondary"
                windowWidth: root.windowWidth
                onClicked: root.exportLogs()
            }

            CustomButton {
                text: "Clear"
                icon: "🗑️"
                variant: "warning"
                windowWidth: root.windowWidth
                onClicked: root.clearLogs()
            }

            Item { Layout.fillWidth: true }
        }
    }
}
