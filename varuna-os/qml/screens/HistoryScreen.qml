import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import "../components"

Rectangle {
    id: root

    property int windowWidth: 1280
    property int windowHeight: 800

    property var recentReadings: [
        {"timestamp": "15-Jan 15:42", "waterLevel": "87.6 cm", "battery": "78%", "mode": "NORMAL", "txStatus": "SUCCESS"},
        {"timestamp": "15-Jan 14:42", "waterLevel": "85.3 cm", "battery": "77%", "mode": "NORMAL", "txStatus": "SUCCESS"},
        {"timestamp": "15-Jan 13:42", "waterLevel": "82.7 cm", "battery": "76%", "mode": "NORMAL", "txStatus": "SUCCESS"},
        {"timestamp": "15-Jan 12:42", "waterLevel": "79.4 cm", "battery": "75%", "mode": "NORMAL", "txStatus": "SUCCESS"}
    ]

    signal generateChart()
    signal exportAllData()
    signal cleanupOldData()

    color: "#000000"

    Flickable {
        anchors.fill: parent
        anchors.margins: 20
        contentWidth: width
        contentHeight: mainColumn.height
        clip: true
        boundsBehavior: Flickable.StopAtBounds
        ScrollBar.vertical: ScrollBar { policy: ScrollBar.AsNeeded; width: 10 }

        Column {
            id: mainColumn
            width: parent.width
            spacing: 25

            SectionTitle {
                width: parent.width
                text: "HISTORICAL DATA"
                icon: "📈"
                windowWidth: root.windowWidth
            }

            GridLayout {
                width: parent.width
                columns: windowWidth <= 900 ? 1 : 3
                columnSpacing: 15
                rowSpacing: 15

                InfoCard {
                    Layout.fillWidth: true
                    header: "Total Records"
                    value: "8,542"
                    status: "healthy"
                    icon: "📊"
                    windowWidth: root.windowWidth
                    details: "Coverage: 14 days\nOldest: 01-Jan-2024"
                }

                InfoCard {
                    Layout.fillWidth: true
                    header: "Storage Used"
                    value: "3.2 GB"
                    status: "healthy"
                    icon: "💾"
                    windowWidth: root.windowWidth
                    details: "CSV: 1.2 GB\nDatabase: 1.8 GB"
                }

                InfoCard {
                    Layout.fillWidth: true
                    header: "Data Integrity"
                    value: "100%"
                    status: "healthy"
                    icon: "✓"
                    windowWidth: root.windowWidth
                    details: "Corrupt: 0\nLast backup: 2h ago"
                }
            }

            SectionTitle {
                width: parent.width
                text: "WATER LEVEL TREND"
                icon: "📈"
                windowWidth: root.windowWidth
            }

            Rectangle {
                width: parent.width
                height: 250
                color: "#0A0A0A"
                border.width: 1
                border.color: "#333333"
                radius: 5

                Column {
                    anchors.centerIn: parent
                    spacing: 10

                    Text {
                        anchors.horizontalCenter: parent.horizontalCenter
                        font.pixelSize: 48
                        text: "📈"
                    }

                    Text {
                        anchors.horizontalCenter: parent.horizontalCenter
                        font.family: "Monospace"
                        font.pixelSize: 16
                        color: "#888888"
                        text: "Chart Area (Backend Integration)"
                    }
                }
            }

            SectionTitle {
                width: parent.width
                text: "RECENT READINGS"
                icon: "📋"
                windowWidth: root.windowWidth
            }

            DataTable {
                width: parent.width
                windowWidth: root.windowWidth
                maxHeight: 250
                columns: [
                    {"key": "timestamp", "title": "Time", "width": 0.20},
                    {"key": "waterLevel", "title": "Level", "width": 0.20, "highlight": true},
                    {"key": "battery", "title": "Battery", "width": 0.15},
                    {"key": "mode", "title": "Mode", "width": 0.20},
                    {"key": "txStatus", "title": "TX", "width": 0.25}
                ]
                rows: root.recentReadings
            }

            Flow {
                width: parent.width
                spacing: 15

                CustomButton {
                    text: "Generate Chart"
                    icon: "📊"
                    variant: "primary"
                    windowWidth: root.windowWidth
                    onClicked: root.generateChart()
                }

                CustomButton {
                    text: "Export Data"
                    icon: "💾"
                    variant: "secondary"
                    windowWidth: root.windowWidth
                    onClicked: root.exportAllData()
                }

                CustomButton {
                    text: "Cleanup"
                    icon: "🗑️"
                    variant: "warning"
                    windowWidth: root.windowWidth
                    onClicked: root.cleanupOldData()
                }
            }

            Item { width: 1; height: 30 }
        }
    }
}
