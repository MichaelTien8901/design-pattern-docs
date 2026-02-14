#!/bin/bash
set -e
echo "=== Building and running all Delphi/Free Pascal design pattern examples ==="
for f in *.pas; do
    name="${f%.pas}"
    echo ""
    echo "--- $name ---"
    fpc -O2 -o"$name" "$f" 2>&1 | tail -1
    ./"$name"
done
