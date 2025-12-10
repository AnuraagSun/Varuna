import QtQuick
import QtQuick.Controls
import QtQuick.Layouts

Rectangle {
    id: root

    // =========================================================================
    // PUBLIC PROPERTIES
    // =========================================================================
    property string title: "SENSOR NAME"
    property string icon: "🔧"
    property string status: "OK"
    property string statusType: "ok"
    property var details: []
    property var healthChecks: []
    property string currentReading: ""
    property bool showTestButton: true
    property bool showCalibrateButton: false
    property int windowWidth: 1280

    // =========================================================================
    // SIGNALS
    // =========================================================================
    signal testClicked()
    signal calibrateClicked()

    // =========================================================================
    // INTERNAL THEME
    // =========================================================================
    readonly property color bgColor: "#1A1A1A"
    readonly property color borderOk: "#00FF00"
    readonly property color borderWarning: "#FFAA00"
    readonly property color borderError: "#FF0000"
    readonly property color borderOffline: "#666666"
    readonly property color textPrimary: "#00FF00"
    readonly property color textSecondary: "#888888"
    readonly property color textMuted: "#666666"
    readonly property color dividerColor: "#333333"
    readonly property string fontMono: "Monospace"

    // =========================================================================
    // COMPUTED PROPERTIES
    // =========================================================================
    readonly property color borderClr: {
        var s = statusType.toLowerCase();
        if (s === "ok" || s === "good" || s === "success") return borderOk;
        if (s === "warning" || s === "warn") return borderWarning;
        if (s === "error" || s === "fail" || s === "critical") return borderError;
        return borderOffline;
    }

    readonly property color statusColor: borderClr

    readonly property int titleFontSize: {
        if (windowWidth <= 800) return 13;
        if (windowWidth <= 1280) return 15;
        if (windowWidth <= 1920) return 16;
        return 18;
    }

    readonly property int normalFontSize: {
        if (windowWidth <= 800) return 11;
        if (windowWidth <= 1280) return 13;
        if (windowWidth <= 1920) return 14;
        return 15;
    }

    readonly property int statusFontSize: {
        if (windowWidth <= 800) return 18;
        if (windowWidth <= 1280) return 22;
        if (windowWidth <= 1920) return 26;
        return 30;
    }

    readonly property int cardPadding: {
        if (windowWidth <= 800) return 15;
        if (windowWidth <= 1280) return 20;
        return 25;
    }

    // =========================================================================
    // APPEARANCE
    // =========================================================================
    color: bgColor
    border.width: 2
    border.color: borderClr
    radius: 8

    implicitHeight: contentColumn.implicitHeight + (cardPadding * 2)

    // =========================================================================
    // CONTENT
    // =========================================================================
    ColumnLayout {
        id: contentColumn
        anchors.fill: parent
        anchors.margins: root.cardPadding
        spacing: 15

        // Header Row
        RowLayout {
            Layout.fillWidth: true
            spacing: 10

            Text {
                font.pixelSize: root.titleFontSize + 4
                text: root.icon
            }

            Text {
                Layout.fillWidth: true
                font.family: root.fontMono
                font.pixelSize: root.titleFontSize
                font.bold: true
                color: root.textSecondary
                text: root.title
                elide: Text.ElideRight
            }
        }

        // Status Row
        Text {
            font.family: root.fontMono
            font.pixelSize: root.statusFontSize
            font.bold: true
            color: root.statusColor
            text: root.status
        }

        // Divider
        Rectangle {
            Layout.fillWidth: true
            height: 1
            color: root.dividerColor
        }

        // Details Section
        ColumnLayout {
            Layout.fillWidth: true
            spacing: 6
            visible: root.details.length > 0

            Text {
                font.family: root.fontMono
                font.pixelSize: root.normalFontSize
                font.bold: true
                color: root.textSecondary
                text: "Last Valid Reading:"
            }

            Repeater {
                model: root.details

                RowLayout {
                    Layout.fillWidth: true
                    spacing: 10

                    Text {
                        font.family: root.fontMono
                        font.pixelSize: root.normalFontSize
                        color: root.textMuted
                        text: modelData.label + ":"
                    }

                    Item { Layout.fillWidth: true }

                    Text {
                        font.family: root.fontMono
                        font.pixelSize: root.normalFontSize
                        color: root.textPrimary
                        text: modelData.value
                    }
                }
            }
        }

        // Health Checks Section
        ColumnLayout {
            Layout.fillWidth: true
            spacing: 6
            visible: root.healthChecks.length > 0

            Rectangle {
                Layout.fillWidth: true
                height: 1
                color: root.dividerColor
                visible: root.details.length > 0
            }

            Text {
                font.family: root.fontMono
                font.pixelSize: root.normalFontSize
                font.bold: true
                color: root.textSecondary
                text: "Health Check:"
            }

            Repeater {
                model: root.healthChecks

                RowLayout {
                    Layout.fillWidth: true
                    spacing: 10

                    Text {
                        font.family: root.fontMono
                        font.pixelSize: root.normalFontSize
                        color: root.textMuted
                        text: modelData.label
                    }

                    Item { Layout.fillWidth: true }

                    Text {
                        font.family: root.fontMono
                        font.pixelSize: root.normalFontSize
                        font.bold: true
                        color: {
                            var s = modelData.status.toLowerCase();
                            if (s.indexOf("ok") >= 0 || s.indexOf("✓") >= 0) return root.borderOk;
                            if (s.indexOf("warn") >= 0) return root.borderWarning;
                            if (s.indexOf("error") >= 0 || s.indexOf("fail") >= 0) return root.borderError;
                            return root.textMuted;
                        }
                        text: modelData.status
                    }
                }
            }
        }

        // Current Reading Section
        ColumnLayout {
            Layout.fillWidth: true
            spacing: 6
            visible: root.currentReading !== ""

            Rectangle {
                Layout.fillWidth: true
                height: 1
                color: root.dividerColor
            }

            Text {
                font.family: root.fontMono
                font.pixelSize: root.normalFontSize
                font.bold: true
                color: root.textSecondary
                text: "Current Status:"
            }

            Text {
                Layout.fillWidth: true
                font.family: root.fontMono
                font.pixelSize: root.normalFontSize
                color: root.textMuted
                text: root.currentReading
                wrapMode: Text.WordWrap
            }
        }

        // Action Buttons
        RowLayout {
            Layout.fillWidth: true
            spacing: 10
            visible: root.showTestButton || root.showCalibrateButton

            // Test Button (inline implementation to avoid import issues)
            Rectangle {
                visible: root.showTestButton
                implicitWidth: testBtnRow.implicitWidth + 24
                implicitHeight: 36
                color: "transparent"
                border.width: 2
                border.color: root.borderOk
                radius: 5

                RowLayout {
                    id: testBtnRow
                    anchors.centerIn: parent
                    spacing: 6

                    Text {
                        font.pixelSize: 14
                        text: "🔍"
                    }

                    Text {
                        font.family: root.fontMono
                        font.pixelSize: 12
                        font.bold: true
                        color: root.borderOk
                        text: "Test"
                    }
                }

                MouseArea {
                    anchors.fill: parent
                    cursorShape: Qt.PointingHandCursor
                    onClicked: root.testClicked()
                }
            }

            // Calibrate Button
            Rectangle {
                visible: root.showCalibrateButton
                implicitWidth: calibBtnRow.implicitWidth + 24
                implicitHeight: 36
                color: "transparent"
                border.width: 2
                border.color: root.borderWarning
                radius: 5

                RowLayout {
                    id: calibBtnRow
                    anchors.centerIn: parent
                    spacing: 6

                    Text {
                        font.pixelSize: 14
                        text: "📐"
                    }

                    Text {
                        font.family: root.fontMono
                        font.pixelSize: 12
                        font.bold: true
                        color: root.borderWarning
                        text: "Calibrate"
                    }
                }

                MouseArea {
                    anchors.fill: parent
                    cursorShape: Qt.PointingHandCursor
                    onClicked: root.calibrateClicked()
                }
            }
        }
    }
}
