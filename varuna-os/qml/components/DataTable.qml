import QtQuick
import QtQuick.Controls
import QtQuick.Layouts

Rectangle {
    id: root

    // =========================================================================
    // PUBLIC PROPERTIES
    // =========================================================================

    // Column definitions: [{"key": "name", "title": "Name", "width": 0.3}, ...]
    // width is a ratio (0.0-1.0) of total width, or -1 for equal distribution
    property var columns: []

    // Row data: [{"name": "Value1", "status": "OK"}, ...]
    property var rows: []

    // Styling
    property int windowWidth: 1280
    property int maxHeight: 400

    // Row click handling
    property bool rowsClickable: false
    signal rowClicked(int rowIndex, var rowData)

    // =========================================================================
    // INTERNAL THEME
    // =========================================================================
    readonly property color bgColor: "#0A0A0A"
    readonly property color headerBg: "#1A1A1A"
    readonly property color headerBorder: "#00FF00"
    readonly property color rowBorder: "#333333"
    readonly property color rowHover: "#1A1A1A"
    readonly property color textHeader: "#00FF00"
    readonly property color textCell: "#888888"
    readonly property color textHighlight: "#00FF00"
    readonly property string fontMono: "Monospace"

    // =========================================================================
    // COMPUTED PROPERTIES
    // =========================================================================
    readonly property int fontSize: {
        if (windowWidth <= 800) return 11;
        if (windowWidth <= 1280) return 13;
        if (windowWidth <= 1920) return 14;
        return 15;
    }

    readonly property int headerHeight: {
        if (windowWidth <= 800) return 38;
        if (windowWidth <= 1280) return 45;
        return 50;
    }

    readonly property int rowHeight: {
        if (windowWidth <= 800) return 35;
        if (windowWidth <= 1280) return 42;
        return 48;
    }

    readonly property int cellPadding: {
        if (windowWidth <= 800) return 8;
        if (windowWidth <= 1280) return 12;
        return 15;
    }

    // =========================================================================
    // APPEARANCE
    // =========================================================================
    color: bgColor
    border.width: 1
    border.color: rowBorder
    radius: 0

    implicitHeight: Math.min(maxHeight, headerHeight + (rows.length * rowHeight) + 2)

    // =========================================================================
    // CONTENT
    // =========================================================================
    ColumnLayout {
        anchors.fill: parent
        spacing: 0

        // =====================================================================
        // HEADER ROW
        // =====================================================================
        Rectangle {
            Layout.fillWidth: true
            Layout.preferredHeight: root.headerHeight
            color: root.headerBg

            // Bottom border
            Rectangle {
                anchors.left: parent.left
                anchors.right: parent.right
                anchors.bottom: parent.bottom
                height: 2
                color: root.headerBorder
            }

            Row {
                anchors.fill: parent

                Repeater {
                    model: root.columns

                    Rectangle {
                        width: {
                            if (modelData.width && modelData.width > 0) {
                                return parent.width * modelData.width;
                            }
                            return parent.width / root.columns.length;
                        }
                        height: parent.height
                        color: "transparent"

                        // Right border (except last column)
                        Rectangle {
                            anchors.right: parent.right
                            anchors.top: parent.top
                            anchors.bottom: parent.bottom
                            width: 1
                            color: root.rowBorder
                            visible: index < root.columns.length - 1
                        }

                        Text {
                            anchors.fill: parent
                            anchors.leftMargin: root.cellPadding
                            anchors.rightMargin: root.cellPadding
                            verticalAlignment: Text.AlignVCenter
                            horizontalAlignment: modelData.align === "right" ? Text.AlignRight :
                            modelData.align === "center" ? Text.AlignHCenter :
                            Text.AlignLeft
                            font.family: root.fontMono
                            font.pixelSize: root.fontSize
                            font.bold: true
                            color: root.textHeader
                            text: modelData.title || modelData.key || ""
                            elide: Text.ElideRight
                        }
                    }
                }
            }
        }

        // =====================================================================
        // DATA ROWS (Scrollable)
        // =====================================================================
        Flickable {
            Layout.fillWidth: true
            Layout.fillHeight: true
            contentWidth: width
            contentHeight: rowsColumn.height
            clip: true
            boundsBehavior: Flickable.StopAtBounds

            ScrollBar.vertical: ScrollBar {
                policy: ScrollBar.AsNeeded
                width: 8
            }

            Column {
                id: rowsColumn
                width: parent.width

                Repeater {
                    model: root.rows

                    Rectangle {
                        id: rowRect
                        width: parent.width
                        height: root.rowHeight
                        color: rowMouseArea.containsMouse ? root.rowHover : "transparent"

                        property var rowData: modelData
                        property int rowIndex: index

                        // Bottom border
                        Rectangle {
                            anchors.left: parent.left
                            anchors.right: parent.right
                            anchors.bottom: parent.bottom
                            height: 1
                            color: root.rowBorder
                        }

                        Row {
                            anchors.fill: parent

                            Repeater {
                                model: root.columns

                                Rectangle {
                                    width: {
                                        if (modelData.width && modelData.width > 0) {
                                            return parent.width * modelData.width;
                                        }
                                        return parent.width / root.columns.length;
                                    }
                                    height: parent.height
                                    color: "transparent"

                                    // Right border (except last column)
                                    Rectangle {
                                        anchors.right: parent.right
                                        anchors.top: parent.top
                                        anchors.bottom: parent.bottom
                                        width: 1
                                        color: root.rowBorder
                                        visible: index < root.columns.length - 1
                                    }

                                    Text {
                                        anchors.fill: parent
                                        anchors.leftMargin: root.cellPadding
                                        anchors.rightMargin: root.cellPadding
                                        verticalAlignment: Text.AlignVCenter
                                        horizontalAlignment: modelData.align === "right" ? Text.AlignRight :
                                        modelData.align === "center" ? Text.AlignHCenter :
                                        Text.AlignLeft
                                        font.family: root.fontMono
                                        font.pixelSize: root.fontSize
                                        color: {
                                            // Highlight if column has highlight property
                                            if (modelData.highlight) return root.textHighlight;
                                            // Check for status-based coloring
                                            var cellValue = rowRect.rowData[modelData.key];
                                            if (typeof cellValue === "string") {
                                                var lower = cellValue.toLowerCase();
                                                if (lower === "success" || lower === "ok" || lower.indexOf("✓") >= 0) {
                                                    return root.textHighlight;
                                                }
                                            }
                                            return root.textCell;
                                        }
                                        text: {
                                            var val = rowRect.rowData[modelData.key];
                                            if (val === undefined || val === null) return "--";
                                            return String(val);
                                        }
                                        elide: Text.ElideRight
                                    }
                                }
                            }
                        }

                        MouseArea {
                            id: rowMouseArea
                            anchors.fill: parent
                            hoverEnabled: root.rowsClickable
                            cursorShape: root.rowsClickable ? Qt.PointingHandCursor : Qt.ArrowCursor

                            onClicked: {
                                if (root.rowsClickable) {
                                    root.rowClicked(rowRect.rowIndex, rowRect.rowData);
                                }
                            }
                        }
                    }
                }
            }
        }
    }
}
