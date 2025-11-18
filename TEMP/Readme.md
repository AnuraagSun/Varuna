
**PHASE 1: Project Setup and Core UI Framework**
- Step 1.1: Initialize the Qt Quick Application project structure for RPi 3B.
- Step 1.2: Define constants (colors, fonts, spacing) in QML based on the HTML/CSS design (`#0A0A0F` background, card colors, etc.).
- Step 1.3: Create the main application window (`main.qml`) with a root `Item` or `ApplicationWindow`.
- Step 1.4: Implement the main layout structure using `ColumnLayout` or `GridLayout` in `main.qml`.
- Step 1.5: Create and add the `Header.qml` component to the top, displaying static "Device ID" and "Location".
- Step 1.6: Add a central placeholder area (e.g., `Dashboard.qml`) to the main layout.

**PHASE 2: Dashboard Core Components**
- Step 2.1: Create the `WaterGauge.qml` component with a basic visual representation (e.g., a `Rectangle` with a fill and a `Text` element for the value).
- Step 2.2: Add the `WaterGauge.qml` instance to the `Dashboard.qml`.
- Step 2.3: Create the `SensorCard.qml` component with `Text` elements for sensor name, value/unit, and status (using placeholder data).
- Step 2.4: Create the `StatCard.qml` component with `Text` elements for system stats like battery, uptime (using placeholder data).
- Step 2.5: Add multiple `SensorCard.qml` and `StatCard.qml` instances to the `Dashboard.qml` layout.

**PHASE 3: Basic Interactivity and Data Simulation**
- Step 3.1: Add a simple `Button` (e.g., "Refresh") to the `Header.qml`.
- Step 3.2: Connect the button's `onClicked` signal to a simple action (e.g., print to console or change a background color temporarily).
- Step 3.3: Add a `Timer` in QML (e.g., in `Dashboard.qml` or `main.qml`) to simulate data updates.
- Step 3.4: Use the `Timer` to periodically update QML properties (like `currentWaterLevel`, `currentMPUValue`) with simulated values.
- Step 3.5: Bind the `Text` elements in `WaterGauge.qml`, `SensorCard.qml`, and `StatCard.qml` to these simulated QML properties, showing dynamic changes.

**PHASE 4: Backend Integration (C++/Python Bridge)**
- Step 4.1: Create C++ classes (`Backend.h`, `Backend.cpp`) to handle communication with Python sensor scripts (e.g., using `QProcess`).
- Step 4.2: Register the C++ `Backend` class as a QML type or set it as a context property for access in QML.
- Step 4.3: Implement C++ methods to execute a Python script (e.g., `read_sensors.py`) that interfaces with the MPU6050, DHT22, and SIM800L (initially returning dummy JSON).
- Step 4.4: Add a QML function/method to call the C++ backend function.
- Step 4.5: Modify the QML `Timer` to trigger the C++ call instead of using simulated data, and update QML properties/models based on the (initially dummy) data received from the C++ backend.

**PHASE 5: Real Sensor Data Integration**
- Step 5.1: Develop the Python script (`read_sensors.py`) to correctly read data from the MPU6050 (using `smbus2` for I2C), DHT22 (using `Adafruit_DHT` or `dht11` library), and potentially SIM800L status (using `pyserial` for AT commands).
- Step 5.2: Ensure the Python script outputs data in a structured format (e.g., JSON) that the C++ backend can parse.
- Step 5.3: Integrate the real Python script execution into the C++ `Backend` class.
- Step 5.4: Parse the JSON output from the Python script in C++.
- Step 5.5: Update the QML properties/models with the *real* sensor data fetched via the C++/Python integration, displaying actual readings on the UI.

**PHASE 6: Enhance UI with Operational Logic**
- Step 6.1: Add logic in C++/QML to determine and display the current system operating mode (NORMAL, FLOOD, LOW_POWER, etc.) based on sensor data and thresholds (from documentation).
- Step 6.2: Implement visual indicators in the UI (e.g., in `StatCard.qml` or a dedicated status area) to show the current mode, using colors defined in constants (e.g., blue for NORMAL, red for FLOOD).
- Step 6.3: Add logic to calculate and display the "Rate of Change" (e.g., cm/15min) based on historical data points stored in QML or C++.
- Step 6.4: Implement the display for battery level, uptime, and other system stats by reading them via Python/C++ (e.g., using `psutil` for system stats, reading from a configuration/log file for uptime).
- Step 6.5: Add a basic, scrollable `LogConsole.qml` component to display system messages (e.g., data read success/failure, mode changes) received from the backend.

**PHASE 7: Communication and Control Features**
- Step 7.1: Create a `Controls.qml` component or add control buttons to the `Header.qml` (e.g., "STATUS", "CALIBRATE", "RESET").
- Step 7.2: Implement C++/Python functions to execute SMS command sending scripts when these buttons are pressed (e.g., calling a `send_sms_command.py` script).
- Step 7.3: Connect the control buttons' `onClicked` signals to the corresponding C++ functions.
- Step 7.4: Add visual feedback in the UI (e.g., log message in `LogConsole.qml`, temporary button state change) when a command is sent.






```
varuna_ui/                                # Root project directory
├── CMakeLists.txt                       # CMake build configuration file (or .pro if using qmake)
├── main.cpp                           # Main C++ application entry point
├── varuna_ui.h                        # (Optional) Main application header if needed
├── varuna_ui.cpp                      # (Optional) Main application logic if needed
├── src/                               # Directory for C++ source files
│   ├── backend/                       # Backend logic (communication, data processing)
│   │   ├── Backend.h                  # Header for the main backend class (Q_OBJECT, Q_INVOKABLE)
│   │   ├── Backend.cpp                # Implementation for Backend class
│   │   ├── SensorReader.h             # Header for sensor reading logic (if separate from Backend)
│   │   ├── SensorReader.cpp           # Implementation for sensor reading logic
│   │   ├── CommunicationHandler.h     # Header for GSM/SMS/HTTP logic (if separate)
│   │   └── CommunicationHandler.cpp   # Implementation for GSM/SMS/HTTP logic
│   └── utils/                         # Utility functions/classes (e.g., logging, config)
│       ├── Logger.h
│       ├── Logger.cpp
│       ├── ConfigManager.h
│       └── ConfigManager.cpp
├── qml/                               # Directory for QML files
│   ├── main.qml                       # Main application window and root layout
│   ├── Constants.qml                  # QML file defining design tokens (colors, fonts, etc.)
│   ├── components/                    # Reusable QML components
│   │   ├── Header.qml                 # Component for the top header (Device ID, Location, Controls)
│   │   ├── Dashboard.qml              # Main dashboard layout container
│   │   ├── WaterGauge.qml             # Component for the main water level visualization
│   │   ├── SensorCard.qml             # Component for displaying individual sensor data
│   │   ├── StatCard.qml               # Component for displaying system stats (battery, uptime, etc.)
│   │   ├── AlertItem.qml              # Component for displaying individual alerts
│   │   ├── AlertsSection.qml          # Component for the alerts list container
│   │   ├── LogConsole.qml             # Component for displaying system logs
│   │   ├── ControlsSection.qml        # Component for manual command buttons (STATUS, CALIBRATE, etc.)
│   │   └── ChartComponent.qml         # (Optional) Component for historical data chart (if using custom QML chart)
│   └── utils/                         # QML utility files (e.g., custom types if needed)
│       └── Helpers.js                 # (Optional) JavaScript functions for QML if needed
├── assets/                            # Static assets (images, icons, sounds)
│   └── icons/                         # Directory for icon files (e.g., PNG, SVG)
│       ├── device_icon.png
│       ├── info_icon.png
│       ├── warning_icon.png
│       └── danger_icon.png
├── resources/                         # Qt resource files (.qrc)
│   └── resources.qrc                  # Resource file listing assets and QML files for embedding
├── python/                            # Directory for Python sensor scripts
│   ├── config/                        # Configuration files (e.g., device_id, thresholds, calibration)
│   │   └── config.json
│   ├── scripts/                       # Main Python scripts
│   │   ├── read_sensors.py            # Script to read MPU6050, DHT22, SIM800L, etc.
│   │   ├── send_sms_command.py        # Script to send SMS commands via SIM800L
│   │   ├── process_data.py            # (Optional) Script for data processing before sending
│   │   └── log_manager.py             # (Optional) Script for managing local logs
│   └── lib/                           # Python libraries/utilities (if not using system/site-packages)
│       └── sensor_drivers/            # (Optional) Custom sensor driver modules
│           ├── mpu6050_driver.py
│           └── dht22_driver.py
├── docs/                              # Documentation files (if kept locally)
│   └── varuna_ui_design.md            # (Example) Local notes on UI design
├── build/                             # (Generated during build) Build output directory
└── README.md                          # Project description and build/run instructions
```
