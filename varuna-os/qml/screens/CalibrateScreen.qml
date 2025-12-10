import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import "../components"

Rectangle {
    id: root

    property int windowWidth: 1280
    property int windowHeight: 800

    property int calibrationStep: 0
    property int calibrationProgress: 0
    property int samplesCollected: 0
    property int totalSamples: 20

    property var calibrationHistory: [
        {"timestamp": "15-Jan-2024 06:00:15", "tension": "1.2 bar", "ropeZero": "0.00 m", "samples": "20", "status": "VALID"},
        {"timestamp": "01-Jan-2024 10:30:42", "tension": "1.1 bar", "ropeZero": "0.00 m", "samples": "20", "status": "VALID"}
    ]

    signal startCalibration()
    signal cancelCalibration()
    signal calibrationComplete()

    color: "#000000"

    Timer {
        id: calibrationTimer
        interval: 150
        repeat: true
        running: root.calibrationStep === 1
        onTriggered: {
            if (root.samplesCollected < root.totalSamples) {
                root.samplesCollected++;
                root.calibrationProgress = Math.round((root.samplesCollected / root.totalSamples) * 100);
            } else {
                calibrationTimer.stop();
                root.calibrationStep = 2;
                root.calibrationComplete();
            }
        }
    }

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
                text: "SENSOR CALIBRATION"
                icon: "📐"
                windowWidth: root.windowWidth
            }

            Rectangle {
                width: parent.width
                height: 120
                color: "#3A1A1A"
                border.width: 2
                border.color: "#FF0000"
                radius: 5
                visible: root.calibrationStep === 0

                Column {
                    anchors.centerIn: parent
                    width: parent.width - 40
                    spacing: 10

                    Text {
                        font.family: "Monospace"
                        font.pixelSize: 16
                        font.bold: true
                        color: "#FF0000"
                        text: "⚠️ CRITICAL WARNING:"
                    }

                    Text {
                        width: parent.width
                        font.family: "Monospace"
                        font.pixelSize: 14
                        color: "#FF0000"
                        wrapMode: Text.WordWrap
                        text: "• Device must be OUT OF WATER\n• Ensure rope is fully retracted\n• Avoid movement during calibration"
                    }
                }
            }

            Rectangle {
                width: parent.width
                height: 200
                color: "#1A1A1A"
                border.width: 2
                border.color: "#333333"
                radius: 8
                visible: root.calibrationStep === 0

                Column {
                    anchors.centerIn: parent
                    width: parent.width - 40
                    spacing: 15

                    Text {
                        font.family: "Monospace"
                        font.pixelSize: 18
                        font.bold: true
                        color: "#00FF00"
                        text: "📐 CALIBRATION WIZARD"
                    }

                    Text {
                        width: parent.width
                        font.family: "Monospace"
                        font.pixelSize: 14
                        color: "#888888"
                        wrapMode: Text.WordWrap
                        text: "1. Remove device from water\n2. Clean sensors\n3. Ensure rope is retracted\n4. Click START when ready"
                    }

                    CustomButton {
                        text: "START CALIBRATION"
                        icon: "✓"
                        variant: "primary"
                        windowWidth: root.windowWidth
                        onClicked: {
                            root.calibrationStep = 1;
                            root.samplesCollected = 0;
                            root.calibrationProgress = 0;
                            root.startCalibration();
                        }
                    }
                }
            }

            Rectangle {
                width: parent.width
                height: 180
                color: "#3A2A0A"
                border.width: 2
                border.color: "#FFAA00"
                radius: 8
                visible: root.calibrationStep === 1

                Column {
                    anchors.centerIn: parent
                    width: parent.width - 40
                    spacing: 15

                    Text {
                        font.family: "Monospace"
                        font.pixelSize: 18
                        font.bold: true
                        color: "#FFAA00"
                        text: "⏳ CALIBRATION IN PROGRESS"
                    }

                    CustomProgressBar {
                        width: parent.width
                        value: root.calibrationProgress
                        minValue: 0
                        maxValue: 100
                        showPercentage: true
                        windowWidth: root.windowWidth
                    }

                    Text {
                        font.family: "Monospace"
                        font.pixelSize: 14
                        color: "#888888"
                        text: "Samples: " + root.samplesCollected + " / " + root.totalSamples
                    }

                    CustomButton {
                        text: "Cancel"
                        icon: "✕"
                        variant: "danger"
                        windowWidth: root.windowWidth
                        onClicked: {
                            calibrationTimer.stop();
                            root.calibrationStep = 0;
                            root.cancelCalibration();
                        }
                    }
                }
            }

            Rectangle {
                width: parent.width
                height: 150
                color: "#0A3A1A"
                border.width: 2
                border.color: "#00FF00"
                radius: 8
                visible: root.calibrationStep === 2

                Column {
                    anchors.centerIn: parent
                    width: parent.width - 40
                    spacing: 15

                    Text {
                        font.family: "Monospace"
                        font.pixelSize: 18
                        font.bold: true
                        color: "#00FF00"
                        text: "✓ CALIBRATION COMPLETE"
                    }

                    Text {
                        font.family: "Monospace"
                        font.pixelSize: 14
                        color: "#888888"
                        text: "Baseline tension: 1.2 bar\nRope zero point: 0.00 m"
                    }

                    CustomButton {
                        text: "DONE"
                        icon: "✓"
                        variant: "primary"
                        windowWidth: root.windowWidth
                        onClicked: root.calibrationStep = 0
                    }
                }
            }

            SectionTitle {
                width: parent.width
                text: "CALIBRATION HISTORY"
                icon: "📋"
                windowWidth: root.windowWidth
            }

            DataTable {
                width: parent.width
                windowWidth: root.windowWidth
                maxHeight: 200
                columns: [
                    {"key": "timestamp", "title": "Timestamp", "width": 0.35},
                    {"key": "tension", "title": "Tension", "width": 0.20},
                    {"key": "ropeZero", "title": "Rope Zero", "width": 0.20},
                    {"key": "status", "title": "Status", "width": 0.25}
                ]
                rows: root.calibrationHistory
            }

            Item { width: 1; height: 50 }
        }
    }
}
