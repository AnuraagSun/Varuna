import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import "../components"

Rectangle {
    id: root

    property int windowWidth: 1280
    property int windowHeight: 800

    property string configDeviceId: "CWC-RJ-001"
    property string configSiteName: "Chambal River Station 1"
    property int configWarningLevel: 120
    property int configDangerLevel: 150
    property string currentMode: "normal"

    signal saveConfiguration()
    signal resetToDefaults()
    signal modeChanged(string newMode)

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
                text: "SYSTEM INFORMATION"
                icon: "⚙️"
                windowWidth: root.windowWidth
            }

            GridLayout {
                width: parent.width
                columns: windowWidth <= 900 ? 2 : 4
                columnSpacing: 15
                rowSpacing: 15

                InfoCard {
                    Layout.fillWidth: true
                    header: "Hardware"
                    value: ""
                    status: "healthy"
                    icon: "🖥️"
                    windowWidth: root.windowWidth
                    details: "RPi 4 Model B\nRAM: 4 GB\nTemp: 45°C"
                }

                InfoCard {
                    Layout.fillWidth: true
                    header: "OS"
                    value: ""
                    status: "healthy"
                    icon: "💻"
                    windowWidth: root.windowWidth
                    details: "Raspbian 11\nUptime: 342h"
                }

                InfoCard {
                    Layout.fillWidth: true
                    header: "Storage"
                    value: ""
                    status: "healthy"
                    icon: "💾"
                    windowWidth: root.windowWidth
                    details: "Used: 3.2 GB\nFree: 28.7 GB"
                }

                InfoCard {
                    Layout.fillWidth: true
                    header: "Network"
                    value: ""
                    status: "healthy"
                    icon: "📶"
                    windowWidth: root.windowWidth
                    details: "4G LTE\nIP: 10.145.32.18"
                }
            }

            SectionTitle {
                width: parent.width
                text: "CONFIGURATION"
                icon: "🔧"
                windowWidth: root.windowWidth
            }

            ControlInput {
                width: parent.width
                label: "Device ID"
                value: root.configDeviceId
                readOnly: true
                windowWidth: root.windowWidth
            }

            ControlInput {
                width: parent.width
                label: "Site Name"
                value: root.configSiteName
                windowWidth: root.windowWidth
                onInputChanged: function(v) { root.configSiteName = v; }
            }

            GridLayout {
                width: parent.width
                columns: windowWidth <= 800 ? 1 : 2
                columnSpacing: 20
                rowSpacing: 15

                ControlInput {
                    Layout.fillWidth: true
                    label: "Warning Level (cm)"
                    value: root.configWarningLevel.toString()
                    windowWidth: root.windowWidth
                    onInputChanged: function(v) { var n = parseInt(v); if (!isNaN(n)) root.configWarningLevel = n; }
                }

                ControlInput {
                    Layout.fillWidth: true
                    label: "Danger Level (cm)"
                    value: root.configDangerLevel.toString()
                    windowWidth: root.windowWidth
                    onInputChanged: function(v) { var n = parseInt(v); if (!isNaN(n)) root.configDangerLevel = n; }
                }
            }

            RowLayout {
                width: parent.width
                spacing: 15

                CustomButton {
                    text: "Save"
                    icon: "💾"
                    variant: "primary"
                    windowWidth: root.windowWidth
                    onClicked: root.saveConfiguration()
                }

                CustomButton {
                    text: "Reset"
                    icon: "🔄"
                    variant: "warning"
                    windowWidth: root.windowWidth
                    onClicked: root.resetToDefaults()
                }
            }

            SectionTitle {
                width: parent.width
                text: "OPERATING MODE"
                icon: "⚡"
                windowWidth: root.windowWidth
            }

            Flow {
                width: parent.width
                spacing: 15

                Repeater {
                    model: [
                        {"id": "normal", "label": "NORMAL", "color": "#00FF00"},
                        {"id": "flood", "label": "FLOOD", "color": "#FF0000"},
                        {"id": "lowpower", "label": "LOW POWER", "color": "#FFAA00"},
                        {"id": "maintenance", "label": "MAINTENANCE", "color": "#888888"}
                    ]

                    Rectangle {
                        width: 140
                        height: 45
                        radius: 5
                        color: root.currentMode === modelData.id ? modelData.color : "transparent"
                        border.width: 2
                        border.color: modelData.color

                        Text {
                            anchors.centerIn: parent
                            font.family: "Monospace"
                            font.pixelSize: 13
                            font.bold: true
                            color: root.currentMode === modelData.id ? "#000000" : modelData.color
                            text: modelData.label
                        }

                        MouseArea {
                            anchors.fill: parent
                            cursorShape: Qt.PointingHandCursor
                            onClicked: {
                                root.currentMode = modelData.id;
                                root.modeChanged(modelData.id);
                            }
                        }
                    }
                }
            }

            Item { width: 1; height: 50 }
        }
    }
}
