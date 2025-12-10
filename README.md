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
