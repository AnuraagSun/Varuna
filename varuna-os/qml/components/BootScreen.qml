import QtQuick
import QtQuick.Controls
import QtQuick.Layouts

Rectangle {
    id: bootScreen

    signal bootComplete()
    signal skipRequested()

    property bool isAnimating: true
    property int currentLineIndex: 0
    property bool showCursor: true
    property bool canSkip: true

    readonly property var bootLines: [
        { text: "[OK] Raspberry Pi 4 Model B (4GB) detected", status: "ok" },
        { text: "[OK] Loading configuration from /etc/varuna/config.json", status: "ok" },
        { text: "[OK] Device ID: CWC-RJ-001", status: "ok" },
        { text: "[OK] Initializing I2C bus...", status: "ok" },
        { text: "[OK] ESP32 Mini C3 link established", status: "ok" },
        { text: "[OK] Pressure sensor (tension) detected", status: "ok" },
        { text: "[OK] Stepper motor driver initialized", status: "ok" },
        { text: "[OK] Hall effect sensor active", status: "ok" },
        { text: "[OK] SIM900A GSM module detected", status: "ok" },
        { text: "[OK] NEO-6M GPS module active", status: "ok" },
        { text: "[OK] RTC (DS3231) synchronized", status: "ok" },
        { text: "[OK] Battery Bank 1: 78% (12.4V)", status: "ok" },
        { text: "[OK] Battery Bank 2: 82% (12.6V)", status: "ok" },
        { text: "[OK] Solar panel: 18.2V | MPPT active", status: "ok" },
        { text: "[OK] Wind turbine: 11.5V | Generating", status: "ok" },
        { text: "[OK] SD Card: 28.7 GB free / 32 GB total", status: "ok" },
        { text: "[OK] Loading historical data...", status: "ok" },
        { text: "[OK] Found 8,542 records in database", status: "ok" },
        { text: "[OK] Last water level: 87.6 cm @ 15:42:00", status: "ok" },
        { text: "[OK] Rope length: 1.82m | Tension: OPTIMAL", status: "ok" },
        { text: "[OK] Last transmission: 2 min ago (SUCCESS)", status: "ok" },
        { text: "[OK] Operating mode: NORMAL", status: "ok" },
        { text: "", status: "empty" },
        { text: "[WARN] Device removed from water", status: "warn" },
        { text: "[WARN] Entering maintenance mode", status: "warn" },
        { text: "", status: "empty" },
        { text: "[OK] Starting interface on localhost:8080", status: "ok" },
        { text: "[OK] All systems operational", status: "ok" },
        { text: "", status: "empty" },
        { text: "Press any key to continue...", status: "info" }
    ]

    readonly property int bootLinesCount: bootLines.length
    property int baseFontSize: 14
    property int headerFontSize: 12

    color: "#000000"
    anchors.fill: parent

    Flickable {
        id: bootFlickable
        anchors.fill: parent
        anchors.margins: 20
        contentWidth: width
        contentHeight: bootContent.height
        clip: true
        boundsBehavior: Flickable.StopAtBounds

        onContentHeightChanged: {
            if (contentHeight > height) {
                contentY = contentHeight - height;
            }
        }

        Column {
            id: bootContent
            width: parent.width
            spacing: 4

            Text {
                id: asciiHeader
                width: parent.width
                font.family: "Monospace"
                font.pixelSize: bootScreen.headerFontSize
                color: "#00FF00"
                lineHeight: 1.1
                text: "╔═══════════════════════════════════════════════════════════════╗\n" +
                      "║   ██╗   ██╗ █████╗ ██████╗ ██╗   ██╗███╗   ██╗ █████╗         ║\n" +
                      "║   ██║   ██║██╔══██╗██╔══██╗██║   ██║████╗  ██║██╔══██╗        ║\n" +
                      "║   ██║   ██║███████║██████╔╝██║   ██║██╔██╗ ██║███████║        ║\n" +
                      "║   ╚██╗ ██╔╝██╔══██║██╔══██╗██║   ██║██║╚██╗██║██╔══██║        ║\n" +
                      "║    ╚████╔╝ ██║  ██║██║  ██║╚██████╔╝██║ ╚████║██║  ██║        ║\n" +
                      "║     ╚═══╝  ╚═╝  ╚═╝╚═╝  ╚═╝ ╚═════╝ ╚═╝  ╚═══╝╚═╝  ╚═╝        ║\n" +
                      "║                                                               ║\n" +
                      "║   WATER LEVEL MONITORING SYSTEM - DIAGNOSTIC MODE             ║\n" +
                      "║   Firmware: v1.0.3 | Build: 20240115 | Device: CWC-RJ-001     ║\n" +
                      "╚═══════════════════════════════════════════════════════════════╝"

                opacity: 0
                Component.onCompleted: fadeIn.start()
                NumberAnimation on opacity { id: fadeIn; from: 0; to: 1; duration: 500 }
            }

            Item { width: parent.width; height: 15 }

            Column {
                id: logLinesContainer
                width: parent.width
                spacing: 6

                Repeater {
                    model: bootScreen.bootLinesCount

                    Text {
                        id: logLine
                        width: parent.width
                        font.family: "Monospace"
                        font.pixelSize: bootScreen.baseFontSize

                        property var lineData: bootScreen.bootLines[index]

                        color: {
                            if (lineData.status === "ok") return "#00FF00";
                            if (lineData.status === "warn") return "#FFAA00";
                            if (lineData.status === "error") return "#FF0000";
                            if (lineData.status === "info") return "#00FF00";
                            return "transparent";
                        }
                        text: lineData.text
                        wrapMode: Text.WordWrap
                        opacity: 0
                        visible: opacity > 0

                        Behavior on opacity { NumberAnimation { duration: 100 } }

                        Connections {
                            target: bootScreen
                            function onCurrentLineIndexChanged() {
                                if (index <= bootScreen.currentLineIndex) {
                                    logLine.opacity = 1;
                                }
                            }
                        }
                    }
                }
            }

            Text {
                font.family: "Monospace"
                font.pixelSize: bootScreen.baseFontSize
                color: "#00FF00"
                text: "█"
                visible: bootScreen.isAnimating && bootScreen.showCursor

                Timer {
                    running: bootScreen.isAnimating
                    interval: 500
                    repeat: true
                    onTriggered: bootScreen.showCursor = !bootScreen.showCursor
                }
            }

            Item { width: parent.width; height: 30 }
        }
    }

    Rectangle {
        anchors.right: parent.right
        anchors.rightMargin: 4
        anchors.top: bootFlickable.top
        anchors.bottom: bootFlickable.bottom
        width: 8
        color: "#0A0A0A"
        radius: 4
        visible: bootFlickable.contentHeight > bootFlickable.height

        Rectangle {
            width: parent.width
            radius: 4
            color: "#00FF00"
            height: Math.max(30, parent.height * (bootFlickable.height / bootFlickable.contentHeight))
            y: bootFlickable.contentHeight > bootFlickable.height ?
               (bootFlickable.contentY / (bootFlickable.contentHeight - bootFlickable.height)) * (parent.height - height) : 0
        }
    }

    Rectangle {
        anchors.bottom: parent.bottom
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.bottomMargin: 15
        width: skipText.width + 40
        height: skipText.height + 16
        color: "#1A1A1A"
        border.color: "#333333"
        border.width: 1
        radius: 5
        opacity: bootScreen.canSkip ? 0.9 : 0

        Text {
            id: skipText
            anchors.centerIn: parent
            font.family: "Monospace"
            font.pixelSize: 12
            color: "#888888"
            text: "Press SPACE or ENTER to skip"
        }
    }

    Rectangle {
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.bottom: parent.bottom
        height: 4
        color: "#0A0A0A"

        Rectangle {
            anchors.left: parent.left
            anchors.top: parent.top
            anchors.bottom: parent.bottom
            width: bootScreen.bootLinesCount > 1 ?
                   parent.width * (bootScreen.currentLineIndex / (bootScreen.bootLinesCount - 1)) : 0
            color: "#00FF00"
            Behavior on width { NumberAnimation { duration: 100 } }
        }
    }

    Timer {
        id: bootSequenceTimer
        interval: 80
        repeat: true
        running: bootScreen.isAnimating

        onTriggered: {
            if (bootScreen.currentLineIndex < bootScreen.bootLinesCount - 1) {
                bootScreen.currentLineIndex++;
            } else {
                bootSequenceTimer.stop();
                bootCompletionTimer.start();
            }
        }
    }

    Timer {
        id: bootCompletionTimer
        interval: 1500
        repeat: false
        onTriggered: bootScreen.finishBoot()
    }

    focus: true

    Keys.onPressed: function(event) {
        if (bootScreen.canSkip) {
            if (event.key === Qt.Key_Space || event.key === Qt.Key_Return ||
                event.key === Qt.Key_Enter || event.key === Qt.Key_Escape) {
                bootScreen.skipBoot();
                event.accepted = true;
            }
        }
    }

    MouseArea {
        anchors.fill: parent
        onClicked: {
            if (bootScreen.canSkip) {
                bootScreen.skipBoot();
            }
        }
    }

    function skipBoot() {
        if (!canSkip) return;
        canSkip = false;
        isAnimating = false;
        bootSequenceTimer.stop();
        bootCompletionTimer.stop();
        currentLineIndex = bootLinesCount - 1;
        skipRequested();
        fadeOutAnim.start();
    }

    function finishBoot() {
        canSkip = false;
        isAnimating = false;
        fadeOutAnim.start();
    }

    NumberAnimation {
        id: fadeOutAnim
        target: bootScreen
        property: "opacity"
        from: 1
        to: 0
        duration: 400
        onFinished: {
            bootScreen.visible = false;
            bootScreen.bootComplete();
        }
    }

    Component.onCompleted: {
        console.log("[BOOT] Boot screen initialized");
        startDelayTimer.start();
    }

    Timer {
        id: startDelayTimer
        interval: 300
        repeat: false
        onTriggered: bootSequenceTimer.start()
    }
}
