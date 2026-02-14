#!/bin/bash
set -e
mkdir -p build && cd build
cmake .. && make -j$(nproc)
echo "=== Running all design pattern examples ==="
for exe in *; do
    if [ -x "$exe" ] && [ -f "$exe" ]; then
        echo ""
        echo "--- $exe ---"
        ./"$exe"
    fi
done
