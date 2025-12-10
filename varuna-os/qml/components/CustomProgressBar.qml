import QtQuick
import QtQuick.Controls
import QtQuick.Layouts

Rectangle {
    id: root

    // =========================================================================
    // PUBLIC PROPERTIES
    // =========================================================================
    property real value: 0  // 0.0 to 1.0
    property real minValue: 0
    property real maxValue: 100
    property bool showPercentage: true
    property bool showLabel: false
    property string label: ""
    property int windowWidth: 1280
    property bool indeterminate: false  // Animated loading bar

    // Computed percentage
    readonly property real percentage: {
        var range = maxValue - minValue;
        if (range <= 0) return 0;
        return Math.max(0, Math.min(100, ((value - minValue) / range) * 100));
    }

    // =========================================================================
    // INTERNAL THEME
    // =========================================================================
    readonly property color bgColor: "#1A1A1A"
    readonly property color borderColor: "#333333"
    readonly property color fillColor: "#00FF00"
    readonly property color textColor: "#000000"
    readonly property color labelColor: "#888888"
    readonly property string fontMono: "Monospace"

    // =========================================================================
    // COMPUTED PROPERTIES
    // =========================================================================
    readonly property int barHeight: {
        if (windowWidth <= 800) return 25;
        if (windowWidth <= 1280) return 30;
        return 35;
    }

    readonly property int fontSize: {
        if (windowWidth <= 800) return 11;
        if (windowWidth <= 1280) return 13;
        return 14;
    }

    readonly property int labelFontSize: {
        if (windowWidth <= 800) return 12;
        if (windowWidth <= 1280) return 14;
        return 15;
    }

    // =========================================================================
    // APPEARANCE
    // =========================================================================
    implicitHeight: showLabel ? (barHeight + labelFontSize + 10) : barHeight

    color: "transparent"

    // =========================================================================
    // CONTENT
    // =========================================================================
    ColumnLayout {
        anchors.fill: parent
        spacing: 6

        // Label (optional)
        Text {
            Layout.fillWidth: true
            visible: root.showLabel && root.label !== ""
            font.family: root.fontMono
            font.pixelSize: root.labelFontSize
            color: root.labelColor
            text: root.label
        }

        // Progress Bar Container
        Rectangle {
            Layout.fillWidth: true
            Layout.preferredHeight: root.barHeight
            color: root.bgColor
            border.width: 1
            border.color: root.borderColor
            radius: 5
            clip: true

            // Fill Rectangle
            Rectangle {
                id: fillRect
                anchors.left: parent.left
                anchors.top: parent.top
                anchors.bottom: parent.bottom
                width: root.indeterminate ? parent.width * 0.3 : parent.width * (root.percentage / 100)
                color: root.fillColor
                radius: parent.radius

                Behavior on width {
                    enabled: !root.indeterminate
                    NumberAnimation {
                        duration: 300
                        easing.type: Easing.OutQuad
                    }
                }

                // Indeterminate animation
                SequentialAnimation on x {
                    running: root.indeterminate
                    loops: Animation.Infinite

                    NumberAnimation {
                        from: -fillRect.width
                        to: root.width
                        duration: 1500
                        easing.type: Easing.InOutQuad
                    }
                }
            }

            // Percentage Text
            Text {
                anchors.centerIn: parent
                visible: root.showPercentage && !root.indeterminate
                font.family: root.fontMono
                font.pixelSize: root.fontSize
                font.bold: true
                color: root.textColor
                text: Math.round(root.percentage) + "%"

                // Make text visible even over unfilled area
                style: Text.Outline
                styleColor: root.percentage < 50 ? root.fillColor : "transparent"
            }

            // Indeterminate loading text
            Text {
                anchors.centerIn: parent
                visible: root.indeterminate
                font.family: root.fontMono
                font.pixelSize: root.fontSize
                font.bold: true
                color: root.labelColor
                text: "Loading..."
            }
        }
    }
}
