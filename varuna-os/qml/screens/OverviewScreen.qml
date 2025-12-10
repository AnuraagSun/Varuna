// ╔═══════════════════════════════════════════════════════════════════════════╗
// ║ FILE: OverviewScreen.qml                                                   ║
// ║ LOCATION: varuna-os/qml/screens/OverviewScreen.qml                         ║
// ║ PURPOSE: Main overview screen showing system health and last readings     ║
// ║ FIXED: Removed recursive property binding issue                           ║
// ╚═══════════════════════════════════════════════════════════════════════════╝

import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import "../components"

Rectangle {
    id: root

    // =========================================================================
    // PUBLIC PROPERTIES
    // =========================================================================
    property int windowWidth: 1280
    property int windowHeight: 800

    // Data properties (will be connected to backend later)
    property var systemHealth: ({
        "pressure": {"status": "✓ OK", "type": "ok"},
        "stepper": {"status": "✓ OK", "type": "ok"},
        "esp32": {"status": "✓ LINKED", "type": "ok"},
        "gps": {"status": "✓ LOCKED", "type": "ok"},
        "gsm": {"status": "✓ CONNECTED", "type": "ok"},
        "battery": {"status": "78%", "type": "ok"},
        "storage": {"status": "28.7 GB", "type": "ok"},
        "power": {"status": "SOLAR", "type": "ok"},
        "transmission": {"status": "✓ SUCCESS", "type": "ok"}
    })

    property var lastReading: ({
        "waterLevel": 87.6,
        "ropeLength": 1.82,
        "angle": 32.5,
        "tension": "OPTIMAL",
        "timestamp": "15-Jan-2024 15:42:00",
        "trend": "+2.3 cm/hr"
    })

    property var powerStatus: ({
        "battery1": 78,
        "battery2": 82,
        "voltage1": 12.4,
        "voltage2": 12.6,
        "solarVoltage": 18.2,
        "windVoltage": 11.5,
        "solarPower": 8.5,
        "windPower": 3.2,
        "source": "SOLAR",
        "autonomy": "4.2 days"
    })

    property var communicationStatus: ({
        "network": "4G LTE (BSNL)",
                                       "signal": -67,
                                       "lastTx": "2 min ago",
                                       "status": "SUCCESS",
                                       "failedTx": 0
    })

    property var gpsStatus: ({
        "latitude": 26.9124,
        "longitude": 75.7873,
        "satellites": 8,
        "accuracy": "±3m",
        "status": "LOCKED"
    })

    property string operatingMode: "NORMAL"
    property int uptimeHours: 342

    property var statisticsData: [
        {"metric": "Water Level (cm)", "current": "87.6", "average": "75.4", "peak": "92.1", "low": "68.3"},
        {"metric": "Battery (%)", "current": "78", "average": "76", "peak": "85", "low": "68"},
        {"metric": "Solar Input (W)", "current": "8.5", "average": "6.2", "peak": "18.4", "low": "0.0"},
        {"metric": "GSM Signal (dBm)", "current": "-67", "average": "-72", "peak": "-65", "low": "-85"},
        {"metric": "Transmission Success", "current": "100%", "average": "99.8%", "peak": "100%", "low": "99.2%"}
    ]

    // =========================================================================
    // SIGNALS
    // =========================================================================
    signal viewHistoryClicked()
    signal viewLogsClicked()
    signal exportDataClicked()

    // =========================================================================
    // INTERNAL THEME
    // =========================================================================
    readonly property color bgColor: "#000000"
    readonly property color textPrimary: "#00FF00"
    readonly property color textSecondary: "#888888"
    readonly property string fontMono: "Monospace"

    // =========================================================================
    // RESPONSIVE CALCULATIONS - FIXED: Using functions instead of recursive bindings
    // =========================================================================
    function getContentPadding() {
        if (windowWidth <= 800) return 15;
        if (windowWidth <= 1280) return 20;
        if (windowWidth <= 1920) return 30;
        return 40;
    }

    function getSectionSpacing() {
        if (windowWidth <= 800) return 20;
        if (windowWidth <= 1280) return 25;
        if (windowWidth <= 1920) return 30;
        return 40;
    }

    function getGridColumns() {
        if (windowWidth <= 600) return 1;
        if (windowWidth <= 900) return 2;
        if (windowWidth <= 1400) return 3;
        return 3;
    }

    function getCardColumns() {
        if (windowWidth <= 700) return 1;
        if (windowWidth <= 1100) return 2;
        if (windowWidth <= 1600) return 3;
        return 3;
    }

    // =========================================================================
    // APPEARANCE
    // =========================================================================
    color: bgColor

    // =========================================================================
    // MAIN SCROLLABLE CONTENT
    // =========================================================================
    Flickable {
        id: contentFlickable
        anchors.fill: parent
        anchors.margins: root.getContentPadding()
        contentWidth: width
        contentHeight: mainColumn.height
        clip: true
        boundsBehavior: Flickable.StopAtBounds

        ScrollBar.vertical: ScrollBar {
            policy: ScrollBar.AsNeeded
            width: 10
        }

        Column {
            id: mainColumn
            width: parent.width
            spacing: root.getSectionSpacing()

            // =================================================================
            // SECTION 1: SYSTEM HEALTH STATUS
            // =================================================================
            SectionTitle {
                width: parent.width
                text: "SYSTEM HEALTH STATUS"
                icon: "📊"
                windowWidth: root.windowWidth
            }

            // Health Grid
            GridLayout {
                width: parent.width
                columns: root.getGridColumns()
                columnSpacing: 10
                rowSpacing: 10

                HealthItem {
                    Layout.fillWidth: true
                    label: "Pressure Sensor"
                    status: root.systemHealth.pressure.status
                    statusType: root.systemHealth.pressure.type
                    icon: "⚡"
                    windowWidth: root.windowWidth
                }

                HealthItem {
                    Layout.fillWidth: true
                    label: "Stepper Motor"
                    status: root.systemHealth.stepper.status
                    statusType: root.systemHealth.stepper.type
                    icon: "⚙️"
                    windowWidth: root.windowWidth
                }

                HealthItem {
                    Layout.fillWidth: true
                    label: "ESP32 Link"
                    status: root.systemHealth.esp32.status
                    statusType: root.systemHealth.esp32.type
                    icon: "📡"
                    windowWidth: root.windowWidth
                }

                HealthItem {
                    Layout.fillWidth: true
                    label: "GPS (NEO-6M)"
                    status: root.systemHealth.gps.status
                    statusType: root.systemHealth.gps.type
                    icon: "📍"
                    windowWidth: root.windowWidth
                }

                HealthItem {
                    Layout.fillWidth: true
                    label: "GSM (SIM900A)"
                    status: root.systemHealth.gsm.status
                    statusType: root.systemHealth.gsm.type
                    icon: "📶"
                    windowWidth: root.windowWidth
                }

                HealthItem {
                    Layout.fillWidth: true
                    label: "Battery (Dual)"
                    status: root.systemHealth.battery.status
                    statusType: root.systemHealth.battery.type
                    icon: "🔋"
                    windowWidth: root.windowWidth
                }

                HealthItem {
                    Layout.fillWidth: true
                    label: "Storage"
                    status: root.systemHealth.storage.status
                    statusType: root.systemHealth.storage.type
                    icon: "💾"
                    windowWidth: root.windowWidth
                }

                HealthItem {
                    Layout.fillWidth: true
                    label: "Solar/Wind"
                    status: root.systemHealth.power.status
                    statusType: root.systemHealth.power.type
                    icon: "☀️"
                    windowWidth: root.windowWidth
                }

                HealthItem {
                    Layout.fillWidth: true
                    label: "Data Transmission"
                    status: root.systemHealth.transmission.status
                    statusType: root.systemHealth.transmission.type
                    icon: "📤"
                    windowWidth: root.windowWidth
                }
            }

            // Spacer
            Item { width: 1; height: 10 }

            // =================================================================
            // SECTION 2: LAST RECORDED DATA
            // =================================================================
            SectionTitle {
                width: parent.width
                text: "LAST RECORDED DATA (Before Removal)"
                icon: "📈"
                windowWidth: root.windowWidth
            }

            // Info Cards Grid
            GridLayout {
                width: parent.width
                columns: root.getCardColumns()
                columnSpacing: 15
                rowSpacing: 15

                // Water Level Card
                InfoCard {
                    Layout.fillWidth: true
                    header: "Water Level"
                    value: root.lastReading.waterLevel.toFixed(1)
                    unit: "cm"
                    status: "healthy"
                    icon: "🌊"
                    windowWidth: root.windowWidth
                    details: "Recorded: " + root.lastReading.timestamp + "\n" +
                    "Status: SAFE (Below warning level)\n" +
                    "Trend: Rising at " + root.lastReading.trend
                }

                // Rope/Angle Card
                InfoCard {
                    Layout.fillWidth: true
                    header: "Rope Measurement"
                    value: root.lastReading.ropeLength.toFixed(2)
                    unit: "m"
                    status: "healthy"
                    icon: "📏"
                    windowWidth: root.windowWidth
                    details: "Angle: " + root.lastReading.angle.toFixed(1) + "°\n" +
                    "Tension: " + root.lastReading.tension + "\n" +
                    "Calculation: c = a × cos(θ)"
                }

                // Operating Mode Card
                InfoCard {
                    Layout.fillWidth: true
                    header: "Operating Mode"
                    value: root.operatingMode
                    status: "healthy"
                    icon: "⚡"
                    windowWidth: root.windowWidth
                    details: "Sampling interval: 60 minutes\n" +
                    "Last reading: 2 min ago\n" +
                    "Uptime: " + root.uptimeHours + " hours"
                }

                // Power System Card
                InfoCard {
                    Layout.fillWidth: true
                    header: "Power System"
                    value: Math.round((root.powerStatus.battery1 + root.powerStatus.battery2) / 2).toString()
                    unit: "%"
                    status: "healthy"
                    icon: "🔋"
                    windowWidth: root.windowWidth
                    details: "Bank 1: " + root.powerStatus.battery1 + "% (" + root.powerStatus.voltage1 + "V)\n" +
                    "Bank 2: " + root.powerStatus.battery2 + "% (" + root.powerStatus.voltage2 + "V)\n" +
                    "Solar: " + root.powerStatus.solarPower + "W | Wind: " + root.powerStatus.windPower + "W\n" +
                    "Autonomy: " + root.powerStatus.autonomy
                }

                // Communication Card
                InfoCard {
                    Layout.fillWidth: true
                    header: "Communication"
                    value: "✓ OK"
                    status: "healthy"
                    icon: "📶"
                    windowWidth: root.windowWidth
                    details: "Network: " + root.communicationStatus.network + "\n" +
                    "Signal: " + root.communicationStatus.signal + " dBm (GOOD)\n" +
                    "Last TX: " + root.communicationStatus.lastTx + " (" + root.communicationStatus.status + ")\n" +
                    "Failed transmissions: " + root.communicationStatus.failedTx
                }

                // GPS Location Card
                InfoCard {
                    Layout.fillWidth: true
                    header: "GPS Location"
                    value: root.gpsStatus.status
                    status: "healthy"
                    icon: "📍"
                    windowWidth: root.windowWidth
                    details: "Lat: " + root.gpsStatus.latitude.toFixed(4) + "°N\n" +
                    "Lon: " + root.gpsStatus.longitude.toFixed(4) + "°E\n" +
                    "Satellites: " + root.gpsStatus.satellites + "\n" +
                    "Accuracy: " + root.gpsStatus.accuracy
                }
            }

            // Spacer
            Item { width: 1; height: 10 }

            // =================================================================
            // SECTION 3: RECENT STATISTICS (Last 24 Hours)
            // =================================================================
            SectionTitle {
                width: parent.width
                text: "RECENT STATISTICS (Last 24 Hours)"
                icon: "📊"
                windowWidth: root.windowWidth
            }

            DataTable {
                width: parent.width
                windowWidth: root.windowWidth
                maxHeight: 300

                columns: [
                    {"key": "metric", "title": "Metric", "width": 0.35},
                    {"key": "current", "title": "Current", "width": 0.16, "highlight": true},
                    {"key": "average", "title": "Average", "width": 0.16},
                    {"key": "peak", "title": "Peak", "width": 0.16},
                    {"key": "low", "title": "Low", "width": 0.16}
                ]

                rows: root.statisticsData
            }

            // Spacer
            Item { width: 1; height: 15 }

            // =================================================================
            // SECTION 4: ACTION BUTTONS
            // =================================================================
            Flow {
                width: parent.width
                spacing: 15

                CustomButton {
                    text: "View Full History"
                    icon: "📈"
                    variant: "primary"
                    windowWidth: root.windowWidth
                    onClicked: root.viewHistoryClicked()
                }

                CustomButton {
                    text: "View Event Logs"
                    icon: "📋"
                    variant: "secondary"
                    windowWidth: root.windowWidth
                    onClicked: root.viewLogsClicked()
                }

                CustomButton {
                    text: "Export Data"
                    icon: "💾"
                    variant: "secondary"
                    windowWidth: root.windowWidth
                    onClicked: root.exportDataClicked()
                }
            }

            // Bottom padding
            Item { width: 1; height: 30 }
        }
    }
}

// ╔═══════════════════════════════════════════════════════════════════════════╗
// ║ END OF FILE: OverviewScreen.qml                                            ║
// ╚═══════════════════════════════════════════════════════════════════════════╝
