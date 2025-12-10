import QtQuick
import QtQuick.Controls
import QtQuick.Layouts

Rectangle {
    id: root

    property int currentIndex: 0
    property int windowWidth: 1280
    property int windowHeight: 800

    property var navItems: [
        {"id": "overview",  "label": "OVERVIEW",  "icon": "📊"},
        {"id": "sensors",   "label": "SENSORS",   "icon": "🔍"},
        {"id": "history",   "label": "HISTORY",   "icon": "📈"},
        {"id": "logs",      "label": "LOGS",      "icon": "📋"},
        {"id": "system",    "label": "SYSTEM",    "icon": "⚙️"},
        {"id": "calibrate", "label": "CALIBRATE", "icon": "📐"},
        {"id": "export",    "label": "EXPORT",    "icon": "💾"},
        {"id": "terminal",  "label": "TERMINAL",  "icon": "💻"}
    ]

    signal tabClicked(int index, string tabId)

    readonly property color bgColor: "#0A0A0A"
    readonly property color bgHover: "#1A1A1A"
    readonly property color bgActive: "#00FF00"
    readonly property color borderColor: "#333333"
    readonly property color textNormal: "#888888"
    readonly property color textHover: "#CCCCCC"
    readonly property color textActive: "#000000"
    readonly property string fontMono: "Monospace"

    readonly property int navHeight: {
        if (windowHeight <= 600) return 40;
        if (windowHeight <= 800) return 48;
        if (windowHeight <= 1080) return 55;
        return 65;
    }

    readonly property int fontSize: {
        if (windowWidth <= 800) return 10;
        if (windowWidth <= 1024) return 11;
        if (windowWidth <= 1280) return 12;
        if (windowWidth <= 1920) return 14;
        return 16;
    }

    readonly property bool showIcons: windowWidth > 900
    readonly property bool showLabels: windowWidth > 600

    implicitHeight: navHeight
    color: bgColor
    border.width: 1
    border.color: borderColor

    RowLayout {
        anchors.fill: parent
        spacing: 0

        Repeater {
            model: root.navItems

            Rectangle {
                id: tabButton
                Layout.fillWidth: true
                Layout.fillHeight: true

                property bool isActive: index === root.currentIndex
                property bool isHovered: tabMouseArea.containsMouse

                color: {
                    if (isActive) return root.bgActive;
                    if (isHovered) return root.bgHover;
                    return "transparent";
                }

                border.width: 1
                border.color: root.borderColor

                Behavior on color { ColorAnimation { duration: 120 } }

                RowLayout {
                    anchors.centerIn: parent
                    spacing: 6

                    Text {
                        visible: root.showIcons
                        font.pixelSize: root.fontSize + 2
                        text: modelData.icon
                    }

                    Text {
                        visible: root.showLabels
                        font.family: root.fontMono
                        font.pixelSize: root.fontSize
                        font.bold: tabButton.isActive
                        color: {
                            if (tabButton.isActive) return root.textActive;
                            if (tabButton.isHovered) return root.textHover;
                            return root.textNormal;
                        }
                        text: modelData.label
                        Behavior on color { ColorAnimation { duration: 120 } }
                    }
                }

                Text {
                    anchors.centerIn: parent
                    visible: !root.showLabels
                    font.pixelSize: root.fontSize + 4
                    text: modelData.icon
                }

                Rectangle {
                    anchors.left: parent.left
                    anchors.right: parent.right
                    anchors.bottom: parent.bottom
                    height: 3
                    color: tabButton.isActive ? root.textActive : "transparent"
                    visible: tabButton.isActive
                }

                MouseArea {
                    id: tabMouseArea
                    anchors.fill: parent
                    hoverEnabled: true
                    cursorShape: Qt.PointingHandCursor
                    onClicked: {
                        if (root.currentIndex !== index) {
                            root.currentIndex = index;
                            root.tabClicked(index, modelData.id);
                        }
                    }
                }
            }
        }
    }

    function selectNext() {
        if (currentIndex < navItems.length - 1) {
            currentIndex++;
            tabClicked(currentIndex, navItems[currentIndex].id);
        }
    }

    function selectPrevious() {
        if (currentIndex > 0) {
            currentIndex--;
            tabClicked(currentIndex, navItems[currentIndex].id);
        }
    }

    function selectByIndex(idx) {
        if (idx >= 0 && idx < navItems.length) {
            currentIndex = idx;
            tabClicked(currentIndex, navItems[currentIndex].id);
        }
    }

    function selectById(tabId) {
        for (var i = 0; i < navItems.length; i++) {
            if (navItems[i].id === tabId) {
                currentIndex = i;
                tabClicked(currentIndex, navItems[currentIndex].id);
                return;
            }
        }
    }
}
