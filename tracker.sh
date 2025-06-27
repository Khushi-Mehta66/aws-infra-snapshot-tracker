#!/bin/bash

echo "Taking snapshot..."
cd scripts
bash snapshot.sh

echo "This are the snapshots"
echo "============================"
ls ../snapshots/
echo "============================"

echo "To compare snapshot, run: "
echo "./scripts/compare.sh <service> <old_date> <new-date> To COMPARE PARTICULAR SERVICE"
echo "OR Run: ./scripts/compare.sh <old_date> <new-date> TO COMPARE ALL SERVICES AT ONCE"
