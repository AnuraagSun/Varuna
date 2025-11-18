
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




### **VARUNA UI Specification**

#### **1. Overall Design Aesthetic**

*   **Style:** Modern, minimalistic.
*   **Theme:** Dark theme.
*   **Primary Background:** `#0A0A0F`.
*   **Secondary Backgrounds (Cards, Panels):** `#1F2937` (or similar subtle variations like `#111827`).
*   **Borders:** `#374151`.
*   **Dark Text:** `#F9FAFB`.
*   **Light Text:** `#D1D5DB`.
*   **Accent Colors:**
    *   **Primary/Link:** `#3B82F6`
    *   **Success/OK:** `#10B981` (e.g., `#d1fae5` background with `#065f46` text for OK status)
    *   **Warning:** `#F59E0B`
    *   **Danger/Error/Alert:** `#EF4444` (e.g., `#fee2e2` background with `#991b1b` text for Fault status)
*   **Typography:** Clean, readable fonts like Roboto or Noto Sans, available on Raspberry Pi OS.

---

#### **2. Main Application Window**

*   **Layout:** Uses `ColumnLayout` or `GridLayout` as the root.
*   **Structure:**
    *   **Header Area:** Fixed at the top, containing device identity and location.
    *   **Central Dashboard Area:** The main, scrollable or flexibly arranged area for data visualization and status cards.
    *   **(Optional for later phases)** **Controls Area:** Potentially a side panel or a section within the header for manual commands.

---

#### **3. Header Component (`Header.qml`)**

*   **Layout:** `RowLayout` or a `Rectangle` with internal `Row`.
*   **Elements:**
    *   **Device Icon:** A visual element (e.g., an emoji `🌊` or a loaded SVG/PNG icon) representing the device type.
    *   **Device Information Section:**
        *   **Device ID:** Large, prominent text (e.g., `CWC-RJ-001`) in the primary text color (`#F9FAFB`).
        *   **Location:** Smaller text (e.g., `Jaipur, Rajasthan • River Yamuna`) in the lighter text color (`#D1D5DB`).
    *   **Header Controls Section (Optional for initial phases):**
        *   A placeholder or basic buttons (e.g., "Refresh", "Settings") if needed for interaction.

---

#### **4. Central Dashboard Component (`Dashboard.qml`)**

*   **Layout:** `GridLayout` or a combination of `ColumnLayout` and `RowLayout` to arrange the main data components.
*   **Components:**
    *   **Water Level Gauge (`WaterGauge.qml`):**
        *   **Visual:** A prominent, custom visual element (e.g., a vertical bar, a semi-circular gauge) representing the current water level against the maximum (e.g., 300 cm). The fill level should visually indicate the current measurement.
        *   **Current Level Text:** Large, clear text displaying the current water level (e.g., `145.8 cm`) and unit, centered or prominently placed near the gauge.
        *   **Markers:** Optional visual markers or labels for specific levels (e.g., INFO, WARNING, DANGER thresholds).
    *   **System Status Cards (`StatCard.qml` instances):**
        *   **Battery Level:** Card showing battery percentage (e.g., `78%`) and potentially charging status.
        *   **Uptime:** Card showing system uptime (e.g., `342 hrs`).
        *   **CPU Temperature:** Card showing CPU temperature (e.g., `48°C`).
        *   **Operating Mode:** Card showing the current system mode (e.g., `NORMAL`, `FLOOD MODE`, `LOW POWER`). The text color should change based on the mode (e.g., blue for NORMAL, red for FLOOD, yellow for LOW POWER).
        *   **GSM Signal Strength:** Card showing signal strength (e.g., `-67 dBm`).
        *   **Rate of Change:** Card showing the calculated rate of water level change (e.g., `+12 cm/15min`).
    *   **Sensor Reading Cards (`SensorCard.qml` instances):**
        *   **MPU-6050:** Card displaying pitch angle (e.g., `32.5 deg`) and calculated water level (e.g., `87.3 cm`). Includes status indicator (OK/FAULT).
        *   **DHT22 (if integrated):** Card displaying temperature (e.g., `24.5°C`) and humidity (e.g., `65% RH`). Includes status indicator.
        *   **SIM800L/SIM7600G (Status):** Card showing GSM status (e.g., `REGISTERED`, `GPRS ACTIVE`) and potentially GPS fix status (e.g., `FIX OK`). Includes status indicator.
    *   **Alerts Section (`AlertsSection.qml` - Optional for initial phases):**
        *   A dedicated area (could be a top card or a separate section) to display the current highest priority active alert (INFO, WARNING, DANGER) with corresponding color coding and brief description.

---

#### **5. Reusable Card Components**

*   **`StatCard.qml` & `SensorCard.qml`:**
    *   **Layout:** `ColumnLayout` or `Item` with `Text` elements.
    *   **Background:** `Rectangle` with color `#1F2937`.
    *   **Border:** Optional, color `#374151`.
    *   **Padding:** Consistent internal padding.
    *   **Content:**
        *   **Title/Label:** Smaller text identifying the stat/sensor (e.g., "Battery", "MPU6050").
        *   **Value:** Larger, bold text for the main value (e.g., `78%`, `145.8 cm`).
        *   **Unit:** Smaller text next to or below the value (e.g., `cm`, `°C`).
        *   **Status Indicator:** A small `Rectangle` or `Text` element showing the status (e.g., "OK", "FAULT") with appropriate color coding (`#10B981` for OK, `#EF4444` for FAULT).

---

#### **6. Data Binding and Updates**

*   The UI elements (Text values, gauge fill, card statuses) must be bound to QML properties or models.
*   These properties/models will be updated by the C++ backend component (`Backend.qml`) which fetches data from the Python sensor scripts.
*   Updates should occur periodically (e.g., every 15-60 seconds based on the system's read cycle) or triggered by events (e.g., mode change, alert).

---

#### **7. Log Console Component (`LogConsole.qml` - Optional for initial phases)**

*   **Layout:** `TextArea` or a `ListView` with a model containing log entries.
*   **Background:** `Rectangle` with color `#1F2937`.
*   **Text Color:** `#D1D5DB`.
*   **Font:** Monospace font (e.g., `Monospace`, `Courier New`) for readability.
*   **Content:** Displays recent system logs, sensor readings, communication status, errors. Each entry includes a timestamp, log level (INFO, WARNING, DANGER), and message. Log levels could be color-coded within the console (e.g., INFO in light text, WARNING in yellow, DANGER in red).

---

#### **8. Controls Section (`ControlsSection.qml` - Optional for initial phases)**

*   **Layout:** Could be a `ColumnLayout` in a side panel or a row within the header.
*   **Elements:** Buttons for sending SMS commands (e.g., "STATUS", "CALIBRATE", "RESET", "MODE FLOOD").
*   **Interaction:** Buttons should trigger corresponding functions in the C++ backend to execute the relevant Python scripts.

---

#### **9. Performance Considerations for RPi 3B**

*   Use efficient QML components (`Rectangle`, `Text`, `Image`).
*   Minimize complex animations or heavy visual effects that could impact performance on the 1GB RAM system.
*   Optimize the C++/Python communication for low latency and minimal resource usage.
*   Ensure the UI remains responsive even when the backend is polling sensors or communicating.



### **VARUNA UI Functionality Specifications**

**1. Core Data Display & Visualization:**

*   **Real-Time Water Level Gauge:**
    *   **Functionality:** Display the current water level in centimeters (e.g., `145.8 cm`) using a prominent, visually appealing gauge or bar graph.
    *   **Data Source:** `sensors.mpu6050.water_level_cm` (or `consensus_level_cm` if multi-sensor fusion is implemented in the backend) from the Python script's output.
    *   **Visuals:** Should visually represent the level relative to the maximum (e.g., 300 cm). Use colors to indicate normal levels vs. approaching thresholds (e.g., green/yellow/red zones). Match the modern, minimalistic aesthetic (e.g., using `#0A0A0F` background, `#1F2937` for card backgrounds).
*   **Sensor Readings Display:**
    *   **Functionality:** Show the current readings from all connected sensors (MPU6050 angle, DHT22 temp/humidity if added, potentially MS5837 pressure if integrated).
    *   **Visuals:** Use `SensorCard.qml` components. Each card displays:
        *   Sensor name/type (e.g., "MPU-6050").
        *   Current value with unit (e.g., "32.5 deg", "24.5°C", "65% RH").
        *   Status indicator ("OK" or "FAULT") with appropriate color coding (e.g., green `#d1fae5` for OK, red `#fee2e2` for FAULT).
    *   **Data Source:** `sensors.mpu6050.pitch_angle`, `sensors.mpu6050.status`, `sensors.hcsr04.distance_cm`, `sensors.ms5837.pressure_mbar`, etc., from the Python script's output.
*   **System Statistics Display:**
    *   **Functionality:** Show key system health and operational metrics.
    *   **Visuals:** Use `StatCard.qml` components. Display:
        *   Battery Level (e.g., `78%`) - `power.battery_percentage`.
        *   Uptime (e.g., `342 hrs`) - `system.uptime_hours`.
        *   Last Boot Time (from system logs or RTC if available).
        *   CPU Temperature (e.g., `48°C`) - `system.cpu_temp_celsius`.
        *   Current Operating Mode (e.g., `NORMAL`, `FLOOD MODE`, `LOW POWER`) - `system.mode`. Color code based on mode (e.g., blue `#3B82F6` for NORMAL, red `#EF4444` for FLOOD, yellow `#F59E0B` for LOW POWER).
        *   GSM Signal Strength (e.g., `-67 dBm`) - `system.gsm_signal_strength`.
        *   Rate of Change (e.g., `+12 cm/15min`) - `rate_of_change_cm_per_hour` (calculated or provided by backend).
    *   **Data Source:** `power`, `system`, `rate_of_change_cm_per_hour` fields from the Python script's output or system queries via C++/Python.
*   **Alerts Section (Conditional):**
    *   **Functionality:** If any alerts are active (`alerts` array in the data packet is not empty), display the current alert level (INFO, WARNING, DANGER) prominently.
    *   **Visuals:** A dedicated area (e.g., `AlertsSection.qml`) showing the highest severity alert from the `alerts` array with corresponding colors (INFO: blue, WARNING: yellow, DANGER: red) and a brief description if available in the data packet.
    *   **Data Source:** `alerts` array from the Python script's output.

**2. Backend Integration & Data Handling:**

*   **Periodic Data Fetching:**
    *   **Functionality:** The UI application (via C++ backend) must periodically (e.g., every 15-60 seconds, configurable) execute the Python sensor reading script (e.g., `read_sensors.py`) and retrieve the JSON output.
    *   **Implementation:** Use `QProcess` in C++ to run the script and capture its standard output. Parse the resulting JSON string into C++ objects/`QVariantMap` and expose the data to QML.
*   **Data Parsing & Model Updates:**
    *   **Functionality:** Parse the JSON data received from the Python script. Update QML models or properties bound to the UI elements (gauge value, sensor cards, stat cards, alerts).
    *   **Implementation:** C++ class parses JSON, updates `Q_PROPERTY` or signals, QML slots/properties update UI elements.
*   **Error Handling & Fallback:**
    *   **Functionality:** If the Python script fails to execute, returns invalid JSON, or sensor readings are marked as "FAULT", the UI must handle this gracefully. Display an error message in the log console and potentially mark affected sensor cards as "FAULT".
    *   **Implementation:** Check `QProcess` exit status, catch JSON parsing errors in C++, update UI state accordingly.

**3. User Interaction & Control:**

*   **Refresh Button:**
    *   **Functionality:** When clicked, the UI should trigger an *immediate* data fetch from the Python script, updating all displayed values.
    *   **Implementation:** Button `onClicked` signal calls the C++ function to execute the script.
*   **SMS Command Buttons (Optional for Phase 1):**
    *   **Functionality:** Provide buttons (e.g., in `ControlsSection.qml`) to send predefined SMS commands to the device (e.g., "STATUS", "CALIBRATE", "RESET", "MODE NORMAL/FLOOD").
    *   **Implementation:** Buttons trigger C++ functions that execute a separate Python script (e.g., `send_sms_command.py`) with the appropriate command string.
    *   **Visual Feedback:** Indicate command sent (e.g., log message in `LogConsole.qml`, temporary button state).

**4. Operational Logic Representation:**

*   **Mode Indication:**
    *   **Functionality:** Accurately reflect the current operating mode (NORMAL, FLOOD, LOW_POWER) as determined by the Python backend based on sensor readings and thresholds.
    *   **Implementation:** UI reads the `system.mode` value from the parsed JSON data and updates the display (e.g., in `StatCard.qml`) with appropriate styling.
*   **Rate of Change Calculation Display:**
    *   **Functionality:** Display the rate of water level change (e.g., `+2.3 cm/hour` or `+12 cm/15min`).
    *   **Implementation:** This value should ideally be calculated by the Python backend by comparing recent readings and included in the JSON output. The UI simply displays it.

**5. System Monitoring & Logging:**

*   **Log Console:**
    *   **Functionality:** Display a scrollable list of system messages, including data fetch results, errors, command sent confirmations, and potentially parsed messages from the Python script's logging output (if redirected).
    *   **Visuals:** Use `LogConsole.qml` with `TextArea` or `ListView`. Color-code log entries by level (INFO: blue `#3B82F6`, WARNING: yellow `#F59E0B`, ERROR: red `#EF4444`). Include timestamp if available.
    *   **Implementation:** C++ backend or QML can manage a `ListModel` of log entries, adding new entries when data is fetched, errors occur, or commands are sent. Python script output can also be captured and added to the log.

**6. Performance & Resource Constraints (Raspberry Pi 3B):**

*   **Efficiency:** The UI application must be designed to run smoothly on the RPi 3B's limited resources (1GB RAM, ARM CPU). Avoid heavy computations or animations in QML. Offload data processing and sensor interaction to the Python/C++ backend.
*   **Update Frequency:** Balance update frequency with performance. Very frequent updates (e.g., every second) might be unnecessary and could impact performance on the RPi 3B. A 15-60 second interval is likely sufficient for water level monitoring.
*   **Memory Usage:** Monitor the memory footprint of the Qt application.

