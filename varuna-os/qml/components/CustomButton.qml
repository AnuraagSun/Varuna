import QtQuick
import QtQuick.Controls
import QtQuick.Layouts

Rectangle {
    id: root

    // =========================================================================
    // PUBLIC PROPERTIES
    // =========================================================================
    property string text: "Button"
    property string icon: ""  // Emoji or icon character
    property string variant: "primary"  // primary, secondary, danger, warning, success
    property bool enabled: true
    property int windowWidth: 1280
    property bool small: false

    signal clicked()

    // =========================================================================
    // INTERNAL THEME
    // =========================================================================
    readonly property color primaryBg: "#00FF00"
    readonly property color primaryText: "#000000"
    readonly property color primaryHoverBg: "#00CC00"

    readonly property color secondaryBg: "transparent"
    readonly property color secondaryBorder: "#00FF00"
    readonly property color secondaryText: "#00FF00"
    readonly property color secondaryHoverBg: "#00FF00"
    readonly property color secondaryHoverText: "#000000"

    readonly property color dangerBg: "transparent"
    readonly property color dangerBorder: "#FF0000"
    readonly property color dangerText: "#FF0000"
    readonly property color dangerHoverBg: "#FF0000"
    readonly property color dangerHoverText: "#FFFFFF"

    readonly property color warningBg: "transparent"
    readonly property color warningBorder: "#FFAA00"
    readonly property color warningText: "#FFAA00"
    readonly property color warningHoverBg: "#FFAA00"
    readonly property color warningHoverText: "#000000"

    readonly property color successBg: "transparent"
    readonly property color successBorder: "#00FF00"
    readonly property color successText: "#00FF00"
    readonly property color successHoverBg: "#00FF00"
    readonly property color successHoverText: "#000000"

    readonly property color disabledBg: "#333333"
    readonly property color disabledText: "#666666"
    readonly property color disabledBorder: "#444444"

    readonly property string fontMono: "Monospace"

    // =========================================================================
    // COMPUTED PROPERTIES
    // =========================================================================
    readonly property bool isHovered: mouseArea.containsMouse && root.enabled
    readonly property bool isPrimary: variant === "primary"

    readonly property color currentBg: {
        if (!root.enabled) return disabledBg;
        var v = variant.toLowerCase();
        if (v === "primary") return isHovered ? primaryHoverBg : primaryBg;
        if (v === "secondary") return isHovered ? secondaryHoverBg : secondaryBg;
        if (v === "danger") return isHovered ? dangerHoverBg : dangerBg;
        if (v === "warning") return isHovered ? warningHoverBg : warningBg;
        if (v === "success") return isHovered ? successHoverBg : successBg;
        return secondaryBg;
    }

    readonly property color currentBorder: {
        if (!root.enabled) return disabledBorder;
        var v = variant.toLowerCase();
        if (v === "primary") return primaryBg;
        if (v === "secondary") return secondaryBorder;
        if (v === "danger") return dangerBorder;
        if (v === "warning") return warningBorder;
        if (v === "success") return successBorder;
        return secondaryBorder;
    }

    readonly property color currentText: {
        if (!root.enabled) return disabledText;
        var v = variant.toLowerCase();
        if (v === "primary") return primaryText;
        if (v === "secondary") return isHovered ? secondaryHoverText : secondaryText;
        if (v === "danger") return isHovered ? dangerHoverText : dangerText;
        if (v === "warning") return isHovered ? warningHoverText : warningText;
        if (v === "success") return isHovered ? successHoverText : successText;
        return secondaryText;
    }

    readonly property int fontSize: {
        if (small) {
            if (windowWidth <= 800) return 11;
            if (windowWidth <= 1280) return 12;
            return 13;
        }
        if (windowWidth <= 800) return 12;
        if (windowWidth <= 1280) return 14;
        if (windowWidth <= 1920) return 15;
        return 16;
    }

    readonly property int buttonHeight: {
        if (small) {
            if (windowWidth <= 800) return 32;
            if (windowWidth <= 1280) return 36;
            return 40;
        }
        if (windowWidth <= 800) return 40;
        if (windowWidth <= 1280) return 48;
        return 55;
    }

    readonly property int horizontalPadding: {
        if (small) return 15;
        if (windowWidth <= 800) return 20;
        if (windowWidth <= 1280) return 25;
        return 30;
    }

    // =========================================================================
    // APPEARANCE
    // =========================================================================
    implicitWidth: contentRow.implicitWidth + (horizontalPadding * 2)
    implicitHeight: buttonHeight

    color: currentBg
    border.width: 2
    border.color: currentBorder
    radius: 5

    opacity: root.enabled ? 1.0 : 0.6

    Behavior on color {
        ColorAnimation { duration: 150 }
    }

    Behavior on border.color {
        ColorAnimation { duration: 150 }
    }

    // =========================================================================
    // CONTENT
    // =========================================================================
    RowLayout {
        id: contentRow
        anchors.centerIn: parent
        spacing: 8

        Text {
            visible: root.icon !== ""
            font.pixelSize: root.fontSize + 2
            text: root.icon
        }

        Text {
            font.family: root.fontMono
            font.pixelSize: root.fontSize
            font.bold: true
            color: root.currentText
            text: root.text

            Behavior on color {
                ColorAnimation { duration: 150 }
            }
        }
    }

    // =========================================================================
    // MOUSE INTERACTION
    // =========================================================================
    MouseArea {
        id: mouseArea
        anchors.fill: parent
        hoverEnabled: true
        cursorShape: root.enabled ? Qt.PointingHandCursor : Qt.ForbiddenCursor

        onClicked: {
            if (root.enabled) {
                root.clicked();
            }
        }
    }

    // =========================================================================
    // PRESS ANIMATION
    // =========================================================================
    scale: mouseArea.pressed && root.enabled ? 0.97 : 1.0

    Behavior on scale {
        NumberAnimation { duration: 100 }
    }
}
