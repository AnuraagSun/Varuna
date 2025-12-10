import QtQuick
import QtQuick.Controls
import QtQuick.Layouts

Rectangle {
    id: root

    property string status: "normal"
    property string text: ""
    property int fontSize: 14
    property string subtitle: ""

    readonly property color goodBg: "#00FF00"
    readonly property color goodText: "#000000"
    readonly property color warnBg: "#FFAA00"
    readonly property color warnText: "#000000"
    readonly property color errorBg: "#FF0000"
    readonly property color errorText: "#FFFFFF"
    readonly property color offlineBg: "#666666"
    readonly property color offlineText: "#FFFFFF"
    readonly property string fontMono: "Monospace"

    readonly property color bgColor: {
        var s = status.toLowerCase();
        if (s === "ok" || s === "good" || s === "normal" || s === "success") {
            return goodBg;
        } else if (s === "warning" || s === "warn" || s === "maintenance" || s === "lowpower") {
            return warnBg;
        } else if (s === "error" || s === "danger" || s === "flood" || s === "critical") {
            return errorBg;
        } else if (s === "offline" || s === "disabled") {
            return offlineBg;
        }
        return warnBg;
    }

    readonly property color textColor: {
        var s = status.toLowerCase();
        if (s === "ok" || s === "good" || s === "normal" || s === "success") {
            return goodText;
        } else if (s === "warning" || s === "warn" || s === "maintenance" || s === "lowpower") {
            return warnText;
        } else if (s === "error" || s === "danger" || s === "flood" || s === "critical") {
            return errorText;
        } else if (s === "offline" || s === "disabled") {
            return offlineText;
        }
        return warnText;
    }

    readonly property string displayText: {
        if (text !== "") return text;
        var s = status.toLowerCase();
        if (s === "ok" || s === "good" || s === "normal") return "NORMAL";
        if (s === "maintenance") return "MAINTENANCE";
        if (s === "warning" || s === "warn") return "WARNING";
        if (s === "flood" || s === "danger") return "FLOOD MODE";
        if (s === "lowpower") return "LOW POWER";
        if (s === "offline") return "OFFLINE";
        return status.toUpperCase();
    }

    implicitWidth: contentLayout.implicitWidth + 36
    implicitHeight: contentLayout.implicitHeight + (subtitle !== "" ? 8 : 14)
    color: bgColor
    radius: 5

    ColumnLayout {
        id: contentLayout
        anchors.centerIn: parent
        spacing: 2

        Text {
            Layout.alignment: Qt.AlignHCenter
            font.family: root.fontMono
            font.pixelSize: root.fontSize
            font.bold: true
            color: root.textColor
            text: root.displayText
        }

        Text {
            Layout.alignment: Qt.AlignHCenter
            visible: root.subtitle !== ""
            font.family: root.fontMono
            font.pixelSize: Math.max(9, root.fontSize - 4)
            color: root.textColor
            opacity: 0.8
            text: root.subtitle
        }
    }

    SequentialAnimation {
        running: status.toLowerCase() === "flood" || status.toLowerCase() === "critical"
        loops: Animation.Infinite
        NumberAnimation { target: root; property: "opacity"; from: 1.0; to: 0.6; duration: 500 }
        NumberAnimation { target: root; property: "opacity"; from: 0.6; to: 1.0; duration: 500 }
    }
}
