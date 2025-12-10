import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import "../components"

Rectangle {
    id: root

    property int windowWidth: 1280
    property int windowHeight: 800
    property var terminalHistory: []
    property var commandHistory: []
    property int historyIndex: -1
    property string hostname: "varuna-cwc-rj-001"

    signal commandExecuted(string command)

    color: "#000000"

    function addLine(type, text) {
        var h = terminalHistory.slice();
        h.push({"type": type, "text": text});
        terminalHistory = h;
    }

    function runCommand(cmd) {
        if (cmd.trim() === "") return;
        addLine("cmd", cmd);
        var ch = commandHistory.slice();
        ch.push(cmd);
        commandHistory = ch;
        historyIndex = commandHistory.length;

        var out = getOutput(cmd);
        for (var i = 0; i < out.length; i++) addLine("out", out[i]);
        addLine("out", "");
        commandExecuted(cmd);

        Qt.callLater(function() {
            if (termFlick.contentHeight > termFlick.height)
                termFlick.contentY = termFlick.contentHeight - termFlick.height;
        });
    }

    function getOutput(cmd) {
        var c = cmd.toLowerCase().trim();
        if (c === "help") return ["Commands: help, df, free, uptime, date, clear, status"];
        if (c === "df" || c === "df -h") return ["Filesystem  Size  Used  Avail", "/dev/root   29G   3.2G  26G"];
        if (c === "free" || c === "free -m") return ["Mem: 3916 total, 452 used, 3464 free"];
        if (c === "uptime") return ["up 14 days, load: 0.42"];
        if (c === "date") return [new Date().toString()];
        if (c === "clear") { terminalHistory = []; return []; }
        if (c === "status") return ["varuna.service: active (running)", "PID: 1234, Memory: 45.2M"];
        return [cmd + ": OK"];
    }

    function navHistory(dir) {
        if (commandHistory.length === 0) return;
        if (dir === "up" && historyIndex > 0) {
            historyIndex--;
            cmdInput.text = commandHistory[historyIndex];
        } else if (dir === "down") {
            if (historyIndex < commandHistory.length - 1) {
                historyIndex++;
                cmdInput.text = commandHistory[historyIndex];
            } else {
                historyIndex = commandHistory.length;
                cmdInput.text = "";
            }
        }
    }

    Component.onCompleted: {
        addLine("out", "Varuna Terminal v1.0.3");
        addLine("out", "Type 'help' for commands");
        addLine("out", "");
    }

    ColumnLayout {
        anchors.fill: parent
        anchors.margins: 20
        spacing: 15

        SectionTitle {
            Layout.fillWidth: true
            text: "SYSTEM TERMINAL"
            icon: "💻"
            windowWidth: root.windowWidth
        }

        Rectangle {
            Layout.fillWidth: true
            Layout.fillHeight: true
            color: "#000000"
            border.width: 2
            border.color: "#00FF00"
            radius: 5

            Flickable {
                id: termFlick
                anchors.fill: parent
                anchors.margins: 15
                contentWidth: width
                contentHeight: outCol.height
                clip: true
                boundsBehavior: Flickable.StopAtBounds
                ScrollBar.vertical: ScrollBar { policy: ScrollBar.AlwaysOn; width: 10 }

                Column {
                    id: outCol
                    width: parent.width - 15
                    spacing: 4

                    Repeater {
                        model: root.terminalHistory

                        Text {
                            width: parent.width
                            font.family: "Monospace"
                            font.pixelSize: 13
                            color: "#00FF00"
                            text: modelData.type === "cmd" ? "root@" + root.hostname + ":~# " + modelData.text : modelData.text
                            wrapMode: Text.WrapAnywhere
                        }
                    }
                }
            }
        }

        Rectangle {
            Layout.fillWidth: true
            Layout.preferredHeight: 45
            color: "#000000"
            border.width: 2
            border.color: "#00FF00"
            radius: 5

            RowLayout {
                anchors.fill: parent
                anchors.margins: 10
                spacing: 8

                Text {
                    font.family: "Monospace"
                    font.pixelSize: 13
                    color: "#00FF00"
                    text: "root@" + root.hostname + ":~#"
                }

                TextInput {
                    id: cmdInput
                    Layout.fillWidth: true
                    font.family: "Monospace"
                    font.pixelSize: 13
                    color: "#00FF00"
                    selectionColor: "#00FF00"
                    selectedTextColor: "#000000"
                    clip: true
                    focus: true

                    onAccepted: {
                        root.runCommand(text);
                        text = "";
                    }

                    Keys.onUpPressed: root.navHistory("up")
                    Keys.onDownPressed: root.navHistory("down")
                }
            }

            MouseArea {
                anchors.fill: parent
                onClicked: cmdInput.forceActiveFocus()
            }
        }

        RowLayout {
            Layout.fillWidth: true
            spacing: 10

            CustomButton {
                text: "Disk"
                icon: "💾"
                variant: "secondary"
                small: true
                windowWidth: root.windowWidth
                onClicked: root.runCommand("df -h")
            }

            CustomButton {
                text: "Memory"
                icon: "🧠"
                variant: "secondary"
                small: true
                windowWidth: root.windowWidth
                onClicked: root.runCommand("free -m")
            }

            CustomButton {
                text: "Status"
                icon: "📡"
                variant: "secondary"
                small: true
                windowWidth: root.windowWidth
                onClicked: root.runCommand("status")
            }

            CustomButton {
                text: "Clear"
                icon: "🗑️"
                variant: "secondary"
                small: true
                windowWidth: root.windowWidth
                onClicked: root.runCommand("clear")
            }

            CustomButton {
                text: "Help"
                icon: "❓"
                variant: "secondary"
                small: true
                windowWidth: root.windowWidth
                onClicked: root.runCommand("help")
            }

            Item { Layout.fillWidth: true }
        }
    }
}
