cd varuna-os
rm -rf build && mkdir build && cd build
cmake ..
make -j$(nproc)

# Test kiosk mode
./bin/VarunaOS --kiosk

# Test windowed mode (normal)
./bin/VarunaOS --windowed

# Test with hidden cursor
./bin/VarunaOS --no-cursor







----------------------
----------
-
-
-
--




sudo nano /etc/systemd/system/varuna-kiosk.service



[Unit]
Description=VARUNA Water Level Monitoring Kiosk
After=graphical.target
Wants=graphical.target

[Service]
Type=simple
User=pi
Environment=DISPLAY=:0
Environment=QT_QPA_PLATFORM=eglfs
Environment=QT_QPA_EGLFS_HIDECURSOR=1
ExecStartPre=/bin/sleep 5
ExecStart=/opt/varuna/VarunaOS --kiosk
Restart=always
RestartSec=5

[Install]
WantedBy=graphical.target
