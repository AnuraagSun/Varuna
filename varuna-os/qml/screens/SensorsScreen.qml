// ╔═══════════════════════════════════════════════════════════════════════════╗
// ║ FILE: SensorsScreen.qml                                                    ║
// ║ LOCATION: varuna-os/qml/screens/SensorsScreen.qml                          ║
// ║ PURPOSE: Display sensor diagnostics and status                            ║
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
    property bool isOutOfWater: true

    // Pressure Sensor Data
    property var pressureSensor: ({
        "status": "✓ OPERATIONAL",
        "statusType": "ok",
        "lastReading": {
            "tension": "OPTIMAL",
            "pressure": "1.2 bar",
            "ropeLoad": "Normal"
        },
        "healthChecks": [
            {"label": "I2C Connection", "status": "✓ OK"},
            {"label": "Calibration", "status": "✓ Valid"},
            {"label": "Response Time", "status": "<5ms ✓"}
        ],
        "currentStatus": "Reading atmospheric pressure (device out of water)"
    })

    // ESP32 Link Data
    property var esp32Link: ({
        "status": "✓ LINKED",
        "statusType": "ok",
        "lastReading": {
            "signalStrength": "-45 dBm",
            "latency": "12 ms",
            "packetsLost": "0"
        },
        "healthChecks": [
            {"label": "RF Connection", "status": "✓ OK"},
            {"label": "Motor Control", "status": "✓ Ready"},
            {"label": "Last Heartbeat", "status": "2s ago ✓"}
        ],
        "currentStatus": "Anchor station responding normally"
    })

    // Stepper Motor Data
    property var stepperMotor: ({
        "status": "✓ READY",
        "statusType": "ok",
        "lastReading": {
            "position": "4520 steps",
            "ropeOut": "1.82 m",
            "direction": "HOLD"
        },
        "healthChecks": [
            {"label": "Driver (A4988)", "status": "✓ OK"},
                                {"label": "Limit Switches", "status": "✓ Clear"},
                                {"label": "Current Sense", "status": "Normal ✓"}
        ],
        "currentStatus": "Motor holding position, tension stable"
    })

    // GPS Data
    property var gpsSensor: ({
        "status": "✓ LOCKED",
        "statusType": "ok",
        "lastReading": {
            "latitude": "26.9124°N",
            "longitude": "75.7873°E",
            "satellites": "8",
            "hdop": "1.2"
        },
        "healthChecks": [
            {"label": "UART Connection", "status": "✓ OK"},
            {"label": "Fix Quality", "status": "3D Fix ✓"},
            {"label": "Accuracy", "status": "±3m ✓"}
        ],
        "currentStatus": "Stable fix with 8 satellites"
    })

    // Hall Effect Sensor Data
    property var hallSensor: ({
        "status": "SOLAR",
        "statusType": "ok",
        "lastReading": {
            "solarVoltage": "18.2 V",
            "windVoltage": "11.5 V",
            "dominant": "SOLAR"
        },
        "healthChecks": [
            {"label": "GPIO Pin", "status": "✓ OK"},
            {"label": "Solar Input", "status": "Active ✓"},
            {"label": "Wind Input", "status": "Active ✓"}
        ],
        "currentStatus": "Solar providing primary power"
    })

    // GSM Module Data
    property var gsmModule: ({
        "status": "✓ CONNECTED",
        "statusType": "ok",
        "lastReading": {
            "network": "BSNL 4G",
            "signal": "-67 dBm",
            "registration": "Registered"
        },
        "healthChecks": [
            {"label": "UART Connection", "status": "✓ OK"},
            {"label": "SIM Card", "status": "✓ Detected"},
            {"label": "Network Reg", "status": "✓ OK"}
        ],
        "currentStatus": "Ready for data transmission"
    })

    // Rope/Tension History
    property var tensionHistory: [
        {"timestamp": "15:42:00", "ropeLength": "1.82 m", "angle": "32.5°", "tension": "OPTIMAL", "waterLevel": "87.6 cm"},
        {"timestamp": "14:42:00", "ropeLength": "1.78 m", "angle": "31.2°", "tension": "OPTIMAL", "waterLevel": "85.3 cm"},
        {"timestamp": "13:42:00", "ropeLength": "1.75 m", "angle": "30.1°", "tension": "OPTIMAL", "waterLevel": "82.7 cm"},
        {"timestamp": "12:42:00", "ropeLength": "1.71 m", "angle": "28.8°", "tension": "OPTIMAL", "waterLevel": "79.4 cm"},
        {"timestamp": "11:42:00", "ropeLength": "1.68 m", "angle": "27.5°", "tension": "OPTIMAL", "waterLevel": "77.0 cm"}
    ]

    // =========================================================================
    // SIGNALS
    // =========================================================================
    signal runDiagnostics()
    signal calibrateAll()
    signal exportSensorLogs()
    signal navigateToCalibrate()

    // =========================================================================
    // INTERNAL THEME
    // =========================================================================
    readonly property color bgColor: "#000000"
    readonly property color textPrimary: "#00FF00"
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

    function getCardColumns() {
        if (windowWidth <= 700) return 1;
        if (windowWidth <= 1200) return 2;
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
            // WARNING BANNER
            // =================================================================
            WarningBanner {
                width: parent.width
                showing: root.isOutOfWater
                type: "warning"
                message: "Device is out of water. Sensor readings may be invalid until redeployment."
                windowWidth: root.windowWidth
                dismissible: true
            }

            // =================================================================
            // SECTION: SENSOR DIAGNOSTICS
            // =================================================================
            SectionTitle {
                width: parent.width
                text: "SENSOR DIAGNOSTICS"
                icon: "🔍"
                windowWidth: root.windowWidth
            }

            // Sensor Cards Grid
            GridLayout {
                width: parent.width
                columns: root.getCardColumns()
                columnSpacing: 15
                rowSpacing: 15

                // Pressure Sensor Card
                SensorCard {
                    Layout.fillWidth: true
                    title: "PRESSURE SENSOR (Tension)"
                    icon: "⚡"
                    status: root.pressureSensor.status
                    statusType: root.pressureSensor.statusType
                    windowWidth: root.windowWidth
                    showTestButton: true
                    showCalibrateButton: false

                    details: [
                        {"label": "Tension Level", "value": root.pressureSensor.lastReading.tension},
                        {"label": "Pressure Reading", "value": root.pressureSensor.lastReading.pressure},
                        {"label": "Rope Load", "value": root.pressureSensor.lastReading.ropeLoad}
                    ]

                    healthChecks: root.pressureSensor.healthChecks
                    currentReading: root.pressureSensor.currentStatus

                    onTestClicked: console.log("[SENSOR] Testing pressure sensor...")
                }

                // ESP32 Link Card
                SensorCard {
                    Layout.fillWidth: true
                    title: "ESP32 LINK (Anchor)"
                    icon: "📡"
                    status: root.esp32Link.status
                    statusType: root.esp32Link.statusType
                    windowWidth: root.windowWidth
                    showTestButton: true

                    details: [
                        {"label": "Signal Strength", "value": root.esp32Link.lastReading.signalStrength},
                        {"label": "Latency", "value": root.esp32Link.lastReading.latency},
                        {"label": "Packets Lost", "value": root.esp32Link.lastReading.packetsLost}
                    ]

                    healthChecks: root.esp32Link.healthChecks
                    currentReading: root.esp32Link.currentStatus

                    onTestClicked: console.log("[SENSOR] Testing ESP32 link...")
                }

                // Stepper Motor Card
                SensorCard {
                    Layout.fillWidth: true
                    title: "STEPPER MOTOR (Rope)"
                    icon: "⚙️"
                    status: root.stepperMotor.status
                    statusType: root.stepperMotor.statusType
                    windowWidth: root.windowWidth
                    showTestButton: true
                    showCalibrateButton: true

                    details: [
                        {"label": "Position", "value": root.stepperMotor.lastReading.position},
                        {"label": "Rope Out", "value": root.stepperMotor.lastReading.ropeOut},
                        {"label": "Direction", "value": root.stepperMotor.lastReading.direction}
                    ]

                    healthChecks: root.stepperMotor.healthChecks
                    currentReading: root.stepperMotor.currentStatus

                    onTestClicked: console.log("[SENSOR] Testing stepper motor...")
                    onCalibrateClicked: root.navigateToCalibrate()
                }

                // GPS Card
                SensorCard {
                    Layout.fillWidth: true
                    title: "GPS MODULE (NEO-6M)"
                    icon: "📍"
                    status: root.gpsSensor.status
                    statusType: root.gpsSensor.statusType
                    windowWidth: root.windowWidth
                    showTestButton: true

                    details: [
                        {"label": "Latitude", "value": root.gpsSensor.lastReading.latitude},
                        {"label": "Longitude", "value": root.gpsSensor.lastReading.longitude},
                        {"label": "Satellites", "value": root.gpsSensor.lastReading.satellites}
                    ]

                    healthChecks: root.gpsSensor.healthChecks
                    currentReading: root.gpsSensor.currentStatus

                    onTestClicked: console.log("[SENSOR] Testing GPS module...")
                }

                // Hall Effect Sensor Card
                SensorCard {
                    Layout.fillWidth: true
                    title: "HALL EFFECT (Power)"
                    icon: "🔌"
                    status: root.hallSensor.status
                    statusType: root.hallSensor.statusType
                    windowWidth: root.windowWidth
                    showTestButton: true

                    details: [
                        {"label": "Solar Voltage", "value": root.hallSensor.lastReading.solarVoltage},
                        {"label": "Wind Voltage", "value": root.hallSensor.lastReading.windVoltage},
                        {"label": "Dominant Source", "value": root.hallSensor.lastReading.dominant}
                    ]

                    healthChecks: root.hallSensor.healthChecks
                    currentReading: root.hallSensor.currentStatus

                    onTestClicked: console.log("[SENSOR] Testing hall effect sensor...")
                }

                // GSM Module Card
                SensorCard {
                    Layout.fillWidth: true
                    title: "GSM MODULE (SIM900A)"
                    icon: "📶"
                    status: root.gsmModule.status
                    statusType: root.gsmModule.statusType
                    windowWidth: root.windowWidth
                    showTestButton: true

                    details: [
                        {"label": "Network", "value": root.gsmModule.lastReading.network},
                        {"label": "Signal", "value": root.gsmModule.lastReading.signal},
                        {"label": "Registration", "value": root.gsmModule.lastReading.registration}
                    ]

                    healthChecks: root.gsmModule.healthChecks
                    currentReading: root.gsmModule.currentStatus

                    onTestClicked: console.log("[SENSOR] Testing GSM module...")
                }
            }

            // Spacer
            Item { width: 1; height: 10 }

            // =================================================================
            // SECTION: ROPE & TENSION STATUS
            // =================================================================
            SectionTitle {
                width: parent.width
                text: "ROPE & TENSION HISTORY"
                icon: "📏"
                windowWidth: root.windowWidth
            }

            DataTable {
                width: parent.width
                windowWidth: root.windowWidth
                maxHeight: 250

                columns: [
                    {"key": "timestamp", "title": "Time", "width": 0.15},
                    {"key": "ropeLength", "title": "Rope Length", "width": 0.20},
                    {"key": "angle", "title": "Angle", "width": 0.15},
                    {"key": "tension", "title": "Tension", "width": 0.20},
                    {"key": "waterLevel", "title": "Water Level", "width": 0.20, "highlight": true}
                ]

                rows: root.tensionHistory
            }

            // Spacer
            Item { width: 1; height: 10 }

            // =================================================================
            // MEASUREMENT FORMULA
            // =================================================================
            Rectangle {
                width: parent.width
                height: formulaColumn.height + 30
                color: "#0A1A0A"
                border.width: 2
                border.color: "#00FF00"
                radius: 8

                Column {
                    id: formulaColumn
                    anchors.centerIn: parent
                    width: parent.width - 40
                    spacing: 8

                    Text {
                        font.family: root.fontMono
                        font.pixelSize: 16
                        font.bold: true
                        color: root.textPrimary
                        text: "📐 WATER LEVEL CALCULATION"
                    }

                    Text {
                        font.family: root.fontMono
                        font.pixelSize: 13
                        color: "#888888"
                        text: "Formula: Water Level (c) = Rope Length (a) × cos(θ)"
                    }

                    Text {
                        font.family: root.fontMono
                        font.pixelSize: 13
                        color: "#888888"
                        text: "Example: c = 1.82m × cos(32.5°) = 1.53m ≈ 87.6 cm"
                    }
                }
            }

            // Spacer
            Item { width: 1; height: 15 }

            // =================================================================
            // ACTION BUTTONS
            // =================================================================
            Flow {
                width: parent.width
                spacing: 15

                CustomButton {
                    text: "Run Full Diagnostics"
                    icon: "🔍"
                    variant: "primary"
                    windowWidth: root.windowWidth
                    onClicked: {
                        console.log("[SENSORS] Running full diagnostics...");
                        root.runDiagnostics();
                    }
                }

                CustomButton {
                    text: "Calibrate All Sensors"
                    icon: "📐"
                    variant: "secondary"
                    windowWidth: root.windowWidth
                    onClicked: root.navigateToCalibrate()
                }

                CustomButton {
                    text: "Export Sensor Logs"
                    icon: "💾"
                    variant: "warning"
                    windowWidth: root.windowWidth
                    onClicked: {
                        console.log("[SENSORS] Exporting sensor logs...");
                        root.exportSensorLogs();
                    }
                }
            }

            // Bottom padding
            Item { width: 1; height: 30 }
        }
    }
}

// ╔═══════════════════════════════════════════════════════════════════════════╗
// ║ END OF FILE: SensorsScreen.qml                                             ║
// ╚═══════════════════════════════════════════════════════════════════════════╝
