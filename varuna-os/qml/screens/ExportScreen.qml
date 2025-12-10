import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import "../components"

Rectangle {
    id: root

    property int windowWidth: 1280
    property int windowHeight: 800
    property bool usbDetected: false

    signal exportAsCsv()
    signal exportAsJson()
    signal exportDatabase()
    signal exportLogs()
    signal detectUsb()
    signal backupToUsb()

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
                text: "DATA EXPORT & BACKUP"
                icon: "💾"
                windowWidth: root.windowWidth
            }

            GridLayout {
                width: parent.width
                columns: windowWidth <= 900 ? 1 : 3
                columnSpacing: 15
                rowSpacing: 15

                InfoCard {
                    Layout.fillWidth: true
                    header: "Available Data"
                    value: "8,542"
                    status: "healthy"
                    icon: "📊"
                    windowWidth: root.windowWidth
                    details: "14 days of records\nSize: 3.2 GB"
                }

                InfoCard {
                    Layout.fillWidth: true
                    header: "Formats"
                    value: ""
                    status: "healthy"
                    icon: "📁"
                    windowWidth: root.windowWidth
                    details: "CSV, JSON\nSQLite, Logs"
                }

                InfoCard {
                    Layout.fillWidth: true
                    header: "Storage"
                    value: ""
                    status: "healthy"
                    icon: "💾"
                    windowWidth: root.windowWidth
                    details: "USB, SD Card\nFTP, Download"
                }
            }

            SectionTitle {
                width: parent.width
                text: "QUICK EXPORT"
                icon: "⚡"
                windowWidth: root.windowWidth
            }

            Flow {
                width: parent.width
                spacing: 15

                CustomButton {
                    text: "CSV"
                    icon: "📊"
                    variant: "primary"
                    windowWidth: root.windowWidth
                    onClicked: root.exportAsCsv()
                }

                CustomButton {
                    text: "JSON"
                    icon: "🔧"
                    variant: "primary"
                    windowWidth: root.windowWidth
                    onClicked: root.exportAsJson()
                }

                CustomButton {
                    text: "Database"
                    icon: "💾"
                    variant: "secondary"
                    windowWidth: root.windowWidth
                    onClicked: root.exportDatabase()
                }

                CustomButton {
                    text: "Logs"
                    icon: "📋"
                    variant: "secondary"
                    windowWidth: root.windowWidth
                    onClicked: root.exportLogs()
                }
            }

            SectionTitle {
                width: parent.width
                text: "USB BACKUP"
                icon: "🔌"
                windowWidth: root.windowWidth
            }

            Rectangle {
                width: parent.width
                height: 120
                color: "#1A1A1A"
                border.width: 1
                border.color: "#333333"
                radius: 5

                Column {
                    anchors.centerIn: parent
                    width: parent.width - 40
                    spacing: 15

                    Text {
                        font.family: "Monospace"
                        font.pixelSize: 14
                        color: "#888888"
                        text: root.usbDetected ? "USB: VARUNA_BACKUP (14.2 GB free)" : "Insert USB drive for backup"
                    }

                    RowLayout {
                        spacing: 15

                        CustomButton {
                            text: "Detect USB"
                            icon: "🔍"
                            variant: "primary"
                            windowWidth: root.windowWidth
                            onClicked: {
                                root.usbDetected = true;
                                root.detectUsb();
                            }
                        }

                        CustomButton {
                            text: "Backup"
                            icon: "💾"
                            variant: "secondary"
                            enabled: root.usbDetected
                            windowWidth: root.windowWidth
                            onClicked: root.backupToUsb()
                        }
                    }
                }
            }

            Item { width: 1; height: 50 }
        }
    }
}
