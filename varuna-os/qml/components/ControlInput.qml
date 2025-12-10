import QtQuick
import QtQuick.Controls
import QtQuick.Layouts

Item {
    id: root

    property string label: ""
    property string value: ""
    property string placeholder: ""
    property bool readOnly: false
    property int windowWidth: 1280
    property string errorMessage: ""

    signal inputChanged(string newValue)
    signal inputEditingFinished()

    implicitHeight: col.implicitHeight

    ColumnLayout {
        id: col
        anchors.left: parent.left
        anchors.right: parent.right
        spacing: 6

        Text {
            Layout.fillWidth: true
            visible: root.label !== ""
            font.family: "Monospace"
            font.pixelSize: 13
            color: "#888888"
            text: root.label
        }

        Rectangle {
            Layout.fillWidth: true
            Layout.preferredHeight: 45
            color: root.readOnly ? "#0A0A0A" : "#1A1A1A"
            border.width: 1
            border.color: inp.activeFocus ? "#00FF00" : "#333333"
            radius: 5

            TextInput {
                id: inp
                anchors.fill: parent
                anchors.leftMargin: 12
                anchors.rightMargin: 12
                verticalAlignment: Text.AlignVCenter
                font.family: "Monospace"
                font.pixelSize: 14
                color: "#00FF00"
                selectionColor: "#00FF00"
                selectedTextColor: "#000000"
                text: root.value
                readOnly: root.readOnly
                selectByMouse: true
                clip: true

                Text {
                    anchors.fill: parent
                    verticalAlignment: Text.AlignVCenter
                    visible: !inp.text && !inp.activeFocus && root.placeholder !== ""
                    font.family: "Monospace"
                    font.pixelSize: 14
                    color: "#666666"
                    text: root.placeholder
                }

                onTextChanged: {
                    root.value = text;
                    root.inputChanged(text);
                }

                onEditingFinished: root.inputEditingFinished()
            }
        }

        Text {
            Layout.fillWidth: true
            visible: root.errorMessage !== ""
            font.family: "Monospace"
            font.pixelSize: 11
            color: "#FF0000"
            text: root.errorMessage
        }
    }
}
